# CMSIS Toolbox Installer

This is the installer for the CMSIS-Toolbox.

## Download and Install

The **CMSIS-Toolbox** is currently under development but supports already a wide range of use cases.

- [**Download CMSIS-Toolbox**](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases)
- [**Setup and Installation**](./docs/installation.md)
- [**Implementation Progress**](./docs/progress.md)

This installer provides:

Tool                     | Binary         | Description                                         | Origin Repo
:------------------------|:---------------|:----------------------------------------------------|:------------------------------------------------------------------
Package Installer        | cpackget       | Install packs into local environment                | [Open-CMSIS-Pack/cpackget](https://github.com/Open-CMSIS-Pack/cpackget)
Project Manager          | csolution      | Validate multiproject solutions and generate CPRJs  | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
Build Invocation         | cbuild         | Utility orchestrating the build steps for a CPRJ    | [Open-CMSIS-Pack/cbuild](https://github.com/Open-CMSIS-Pack/cbuild)
Build Generator          | cbuildgen      | Generate CMakeLists.txt from CPRJ                   | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
Pack Verification        | packchk        | Semantic validation of a software pack              | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
System View Verification | svdconv        | Semantic validation of System View description files and device header file generator | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
