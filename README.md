# Market.Tools.Std2np

[![Build Status](https://travis-ci.org/market-group/std2np.svg?branch=master)](https://travis-ci.org/market-group/std2np)

|                                            |                Stable                                                                                     |                                                       Pre-release                                           |                                   Downloads                                                             |
| -----------------------------------------: | :-------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------: |
| **Market.Tools.Std2np**  |     ![nuget-extensions-stable](https://img.shields.io/nuget/v/Market.Tools.Std2np.svg)  | ![nuget-extensions-unstable](https://img.shields.io/nuget/vpre/Market.Tools.Std2np.svg)   | ![nuget-extensions-unstable](https://img.shields.io/nuget/dt/Market.Tools.Std2np.svg) |

This tool redirects its `stdout`, `stderr`, `stdtin` to named pipes

## Install

This tool is published using NuGet and can be install using dotnet-cli:  
`dotnet tool install -g Market.Tools.Std2np`

(`dotnet tool` updates the `PATH` variable, so you might need to re-open shell to use the tool)

## Usage

```
Usage: std2np [options]

Options:
  --help     Show help information
  --version  Show version information
  --out|-o   Stdout pipe name
  --in|-i    Stdin pipe name
  --err|-e   Stderr pipe name
  --logs|-l  Log file
```
