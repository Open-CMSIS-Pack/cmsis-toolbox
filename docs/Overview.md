# CMSIS-Toolbox

The **CMSIS-Toolbox** provides command-line tools that provide the foundation for software development flows.  The CMSIS-Toolbox contains the following tools:

**Package creation** and validation:

- [**packgen**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/packgen/docs/packgen.md) : create a software pack from a `CMake` based software repository
- [**packchk**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/packchk/docs/packchk.md) : semantic validation of a software pack description and the archive content

**Package management** including discovery of components, devices, boards and examples:

- [**cpackget**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/cpackget/docs/cpackget.md) : download, add and remove packs and local repositories to CMSIS_PACK_ROOT

**Project management** for constructing projects from local files and software components:

- [**csolution**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/Manual/Overview.md) : manage complex applications with `*.yaml` user input files and content from CMSIS-Packs; output `*.cprj` files for reproducible builds using **cbuild** in IDE and CI environments

**Build management** to compile and generate executable program images:

- [**cbuild**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/buildmgr/docs/cbuild.md) (aka CMSIS-Build): convert a `*.cprj` file that describes a single target and single configuration of a project to a CMake input; start the build process.

## Download and Install

The **CMSIS-Toolbox** is currently under development but supports already a wide range of use cases.

- [**Download CMSIS-Toolbox**](https://github.com/Open-CMSIS-Pack/devtools/releases)
- [**Setup and Installation**](./toolbox/docs/installation.md)
- [**Implementation Progress**](./toolbox/docs/progress.md)

## Development Cycle - Create Applications

The tools of the CMSIS-Toolbox provide a command-line interface for creating application projects that are based on software packs. The development flow is outlined in the diagram below.  An IDE that supports import and export of `*.cprj` project files is included for completeness.

![CMSIS-Toolbox - Create Applications - Workflow Overview](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/images/CMSIS-Toolbox-Development-Workflow.png "CMSIS-Toolbox - Create Applications - Workflow Overview")

Discover packs for an application by using a [*catalog of software packs*](https://www.keil.com/dd2/pack).These packs may be installed using [**cpackget**](cpackget/docs/cpackget.md) and by [**csolution**](projmgr/docs/Manual/Overview.md), for example to list devices or software components. Along with user code, these items are used to describe the application project in `*.csolution.yml` and `cproject.yml` format and convert it with [**csolution**](projmgr/docs/Manual/Overview.md) into `*.cprj` files.

These `*.cprj` files describe a reproducible build and are the input for [**cbuild**](buildmgr/docs/cbuild.md). Using different `target-types` at the `*.csolution.yml`-level allows to create applications that run on  hardware boards or simulation models (Arm Virtual Hardware).

## Development Cycle - Software Packs

The following diagram illustrates how the tools of the CMSIS-Toolbox improve the software component reuse by providing a development flow to create packs.

![CMSIS-Toolbox - Create Software Packs - Workflow Overview](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/images/CMSIS-Toolbox-Overview.png "CMSIS-Toolbox - Create Software Packs - Workflow Overview")

CMSIS software packs may be created from a CMake based repository with [**packgen**](packgen/docs/packgen.md) or directly described in the `*.PDSC` format. These packs should be verified for consistency with [**packchk**](packchk/docs/packchk.md) before publishing in a vendor index (`*.vidx`) file.

Once the pack is published it is available in a [*catalog of software packs*](https://www.keil.com/dd2/pack) and can be discovered by developers. With [**cpackget**](cpackget/docs/cpackget.md) these packs can be installed local and used to create the application program as described above.
