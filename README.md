# CMSIS-Toolbox

This contains the executable tools of the CMSIS-Toolbox that provides a set of command-line tools to work with software packs in Open-CMSIS-Pack format.

## Users Guide

The [**Users Guide**](./docs/README.md) provides detailed information.

## Project Creation

The following tools support the creation of build information for embedded applications:

Tool           | Description
:--------------|:-------------
**cpackget**   | **Pack Manager:** install and manage software packs in the development environment.
**cbuild**     | **Build Invocation:** orchestrate the build steps utilizing CMSIS tools and a CMake compilation process.
**csolution**  | **Project Manager:** create build information for embedded applications that consist of one or more related projects.

## Software Pack Creation

The following tools support the creation of Software Packs in [CMSIS-Pack format](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html):

Tool           | Description
:--------------|:-------------
**packchk**    | **Pack Validation:** installs and manages software packs in the local development environment.
**svdconv**    | **SVD Check / Convert:** validate and/or convert System View Description (SVD) files.

In addition several scripts are provided that simplify pack creation with desktop or cloud workflows. This is described in several hands-on tutorials:

Hands-on Tutorial         | Description
:-------------------------|:-------------
[**SW-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/SW-Pack-HandsOn)    | Explains the steps to create a simple software pack using the Open-CMSIS-Pack technology.
[**DFP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/DFP-Pack-HandsOn)  | Explains the structure and creation of a Device Family Pack (DFP).
[**BSP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/DFP-Pack-HandsOn)  | Explains the structure and creation of a Board Support Pack (BSP).  
