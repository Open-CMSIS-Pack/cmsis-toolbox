# CMSIS Toolbox Installer

This is the installer for the CMSIS-Toolbox.

## Download and Install

The **CMSIS-Toolbox** is currently under development but supports already a wide range of use cases.

- [**Download CMSIS-Toolbox**](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases)
- [**Setup and Installation**](./docs/installation.md)
- [**Implementation Progress**](./docs/progress.md)

This installer provides:

Tool               | Binary         | Description
:------------------|:---------------|:-------------------------------------------------
Package Installer  | cpackget       | Install packs into local environment
Project Manager    | csolution      | Validate multiproject solutions and generate CPRJs
Build Invocation   | cbuild         | Start the build process via Build Generator
Build Generator    | cbuildgen      | Generate CMakeLists and start CMake/
Ninja
Pack Verification  | packchk        | Semantic validation of a software pack
