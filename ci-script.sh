#!/usr/bin/env bash

SLN_FILE=`find . -name '*.sln'`

echo "checking for sln list"

SLN=$(readlink -f `ls *.sln`)
DCPROJ=`dotnet sln list | grep dcproj || true`
if [ ! -z "$DCPROJ" ]; then
	echo "Found dcproj files and remove them"
	dotnet sln $SLN remove $DCPROJ
fi


echo "Calculating Version...."

GitVersion_NuGetVersionV2=$(mono ./GitVersion/tools/GitVersion.exe /showvariable NuGetVersionV2)
GitVersion_PreReleaseTag=$(mono ./GitVersion/tools/GitVersion.exe /showvariable PreReleaseTag)

echo "Calculated version $GitVersion_NuGetVersionV2"
echo "PreRelease Tag is $GitVersion_PreReleaseTag"

echo "Restoring..."
dotnet restore $SLN_FILE -f --no-cache

NUPKG_PATH="$PWD/packages"
mkdir -p $NUPKG_PATH
echo $NUPKG_PATH

echo "Building..."
dotnet build $SLN_FILE --no-restore --configuration Release /p:Version="$GitVersion_NuGetVersionV2"

if [ ! -z "$TESTS_PATH" ]; then
        for TEST_CSPROJ in  `find $TESTS_PATH/* -name *.csproj`; do
                echo "dotnet test $TEST_CSPROJ --no-build --configuration Release"
                dotnet test $TEST_CSPROJ --configuration Release
        done
else
        echo "No tests path was mentioned"
fi

#TAGS=`echo $PROJECTNAME | tr '.' ' '`
echo "Packing...."
dotnet pack $SLN_FILE -o "$NUPKG_PATH" --include-symbols \
                        --no-restore \
                        --no-build \
                        --configuration Release \
                        --verbosity normal \
                        /p:PackageProjectUrl="$STANDARD_CI_REPOSITORY_URL" \
                        /p:PackageIconUrl="https://s3.amazonaws.com/market-badges/market_logo.png" \
                        /p:RepositoryUrl="$STANDARD_CI_REPOSITORY_URL" \
                        /p:PackageVersion="$GitVersion_NuGetVersionV2" \
                        /p:Authors="Market Group" \
                        /p:Copyright="Copyright © Market Group LTD."

NUPKG_FILES=`ls $NUPKG_PATH | grep -v 'symbols.nupkg$'`
for FILENAME in $NUPKG_FILES; do
	FILENAME="${FILENAME%.*}"
	mv -f $NUPKG_PATH/$FILENAME.symbols.nupkg $NUPKG_PATH/$FILENAME.nupkg
done

echo "Pushing package..."
dotnet nuget push "$NUPKG_PATH/*.nupkg" --source $NUGET_FEED --api-key $NUGET_API_KEY --no-symbols true
