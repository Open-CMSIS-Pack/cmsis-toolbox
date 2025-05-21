# Overview

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

## Target Audience

This user's guide assumes basic knowledge about Cortex-M software development. It is written for embedded software developers that work with C/C++ compiler toolchains and utilize microcontroller devices with Cortex-M processors and Ethos-U NPUs.

The CMSIS-Toolbox contains stand-alone tools [for all host platforms](https://artifacts.keil.arm.com/cmsis-toolbox/) (Windows, Mac, Linux) that support:

- [Arm Compiler for Embedded](https://developer.arm.com/Tools%20and%20Software/Arm%20Compiler%20for%20Embedded) version 6.18 or higher
    - Arm FuSa Compiler for Embedded version 6.16.2 or higher is also supported
- [Arm GNU Toolchain (GCC)](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) version 10.3.1 or higher
- [IAR Compiler](https://www.iar.com/products/architectures/arm/) version 9.32.1 or higher
- [CLANG Compiler version 17.0.1](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases) or higher based on LLVM technology

!!! Notes
    - This documentation uses the filename extension `*.yml`, but the extension `*.yaml` is also supported.
    - The term *CMSIS solution* refers to an application project that is specified with *csolution project files* (`*.csolution.yml`, `*cproject.yml`, and `*.clayer.yml`).
    - *Software packs* describe software components in Open-CMSIS-Pack format that can contain middleware, drivers, board support, or device support. *Software packs* also provide documentation, examples, and reusable software layers.

## Overall Workflow

The CMSIS-Toolbox includes the following tools for the creation of embedded applications:

Tool                     | Description
:------------------------|:-----------------------
[cpackget](build-tools.md#cpackget-invocation)  | Pack Manager: install and manage software packs in the host development environment.
[cbuild](build-tools.md#cbuild-invocation)      | Build Invocation: orchestrate the build steps utilizing CMSIS tools and a CMake compilation process.
[csolution](build-tools.md#csolution-invocation)| Project Manager: create build information for embedded applications that consist of one or more related projects.

These tools use *software packs* for device/board support and access to reusable software components. The operation is controlled via [*csolution project files* in YAML format](YML-Input-Format.md). The overall application is defined in the `*.csolution.yml` file and contains one or more projects that can utilize pre-configured software layers. The build engine CMake/Ninja calls the C/C++ compiler toolchain that generates the Build Output.

The [**cbuild**](build-tools.md#cbuild-invocation) command orchestrates the overall build steps. This command calls individual tools to generate the application as outlined in the following diagram.

![cbuild workflow](./images/cbuild-workflow.png "cbuild workflow")

The build steps are:

1. [**cpackget**](build-tools.md#cpackget-invocation) downloads *Software Packs* that are required for `*.csolution.yml` when using the option `--pack`.
2. [**csolution**](build-tools.md#csolution-invocation) processes the *csolution project* and the *Software Packs* to generate the overall *Build Information*. Refer to [CSolution Project Structure](build-overview.md#overview-of-operation) for details.
3. **cbuild2cmake** converts this *Build Information* into CMake format.
4. **CMake/Ninja** call the C/C++ compiler toolchain to translate the source files into the application image.

!!! Note
    The CMSIS-Toolbox build system does not use the CMake compiler and linker flags specified by environment variables [CFLAGS, LDFLAGS](https://cmake.org/cmake/help/latest/envvar/CFLAGS.html).  
    Refer to the chapter [Build Operation](build-operation.md) for further details of the build process.

## Command Line and IDE Usage

The CMSIS-Toolbox is a set of command line tools that are designed for stand-alone usage and integration into [IDEs](build-tools.md#ide-usage) or [DevOps](build-tools.md#devops-usage) systems for Continuous Integration (CI) workflows.

![Operation of `csolution` tool](./images/tool-overview.png "Operation of `csolution` tool")

!!! Tip
    - The [VS Code extension Arm CMSIS Solution](https://marketplace.visualstudio.com/items?itemName=Arm.cmsis-csolution) is a graphical user interface for [*csolution projects*](YML-Input-Format.md).

    - The [AVH-FVP examples](https://github.com/Arm-Examples) and many projects on [github.com/Open-CMSIS-Pack](https://github.com/Open-CMSIS-Pack) exemplify CI workflows.

## Benefits

The overall benefits of the CMSIS-Toolbox are:

- [*Software packs*](https://www.keil.arm.com/packs/) simplify tool setup with `device:` or `board:` selection and provide access to reusable software components.

- Organize solutions with independent projects to support a wide range of use cases, including multi-processor applications or unit testing.

- Integrates with domain-specific [generators](build-overview.md#use-a-generator) (e.g., CubeMX or MCUXpresso Config Tools) for configuring devices/boards and complex software stacks such as motor control.

- Target types allow application deployment to different hardware (test board, production hardware, virtual simulation models, etc.).

- Build types support software testing and verification (debug build, test build, release build, ect.).

- Software layers enable code reuse across similar applications with a pre-configured set of source files and software components.

- [Linker Script Management](build-overview.md#linker-script-management) utilizes device and board information of *software packs* to define available memory and allows flexible control of linker operation.

- The [Run and Debug Configuration](build-overview.md#run-and-debug-configuration) collects all information to program and debug an application in a target system.

- [Product lifecycle management (PLM)](build-overview.md#plm-of-configuration-files) with versioned *software packs* that ease update and management for configuration files.

- Provides a [list of software licenses](YML-CBuild-Format.md#nodes-for-license-information) used by the various software packs and software components.
