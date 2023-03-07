# CMSIS-Toolbox Installer

This is the installer for the CMSIS-Toolbox. The CMSIS-Toolbox provides a set of command-line tools for software packs that covers the complete lifecycle including:
- creation and maintenance of software packs.
- distribution and installation of software packs.
- project build with interfaces to various compilation tools.

It is currently under development but supports already a wide range of use cases (refer to [**implementation progress**](./docs/progress.md)).

The [**CMSIS-Toolbox: Installation**](./docs/installation.md) explains the download, installation, and configuration process.

The CMSIS-Toolbox includes:

Tool           | Description                                         | Tool source code repository
:--------------|:----------------------------------------------------|:------------------------------------------------------------------
[cpackget](https://github.com/Open-CMSIS-Pack/cpackget/blob/main/README.md)              | Package Installer: manage packs in local environment                   | [Open-CMSIS-Pack/cpackget](https://github.com/Open-CMSIS-Pack/cpackget)
[csolution](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/Manual/Overview.md) | Project Manager: create build information for multi-project solutions  | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
[cbuild](https://github.com/Open-CMSIS-Pack/cbuild/blob/main/README.md)                   | Build Invocation: orchestrate the build steps                          | [Open-CMSIS-Pack/cbuild](https://github.com/Open-CMSIS-Pack/cbuild)
cbuildgen      | Build Generator: generate CMakeLists.txt from `*.CPRJ` files           | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
[packchk](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/packchk/README.md)  | Pack Verification: validate a software pack before release             | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
[svdconv](https://arm-software.github.io/CMSIS_5/SVD/html/svd_SVDConv_pg.html)             | System View Verification: validate `*.SVD` files and convert to  device header file | [Open-CMSIS-Pack/devtools](https://github.com/Open-CMSIS-Pack/devtools)
