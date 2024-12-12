# Overview

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

## Target Audience

This user's guide assumes basic knowledge about Cortex-M software development. It is written for embedded software developers that work with C/C++ compiler toolchains and utilize microcontroller devices with Cortex-M processors and Ethos-U NPUs. The CMSIS-Toolbox supports currently:

- [Arm Compiler for Embedded](https://developer.arm.com/Tools%20and%20Software/Arm%20Compiler%20for%20Embedded) version 6.18 or higher
  - Arm FuSa Compiler for Embedded version 6.16.2 or higher is also supported
- [Arm GNU Toolchain (GCC)](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) version 10.3.1 or higher
- [IAR Compiler](https://www.iar.com/products/architectures/arm/) version 9.32.1 or higher
- [CLANG Compiler version 17.0.1](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases) or higher based on LLVM technology

## Overall Workflow

The CMSIS-Toolbox uses *software packs* for device/board support and access reusable software components.  The operation is controlled via intuitive [*csolution project files* in YAML format](YML-Input-Format.md). The overall application is defined in the `*.csolution.yml` file and contains one or more projects that can utilize pre-configured software layers. The build engine CMake/Ninja calls the C/C++ compiler toolchain that generates the Build Output.

The [**cbuild: Build Invocation**](build-tools.md#cbuild-invocation) command orchestrates the overall build steps. This command calls individual command line tools to generate the application as outlined in the following diagram.

![cbuild workflow](./images/cbuild-workflow.png "cbuild workflow")

The build steps are:

1. [**cpackget**](build-tools.md#cpackget-invocation) downloads Software Packs that are required for `*.csolution.yml` when using the option `--pack`.
2. [**csolution**](build-tools.md#csolution-invocation) processes the User Input and the Software Packs to generate the overall Build Information. Refer to [Overview of Operation](build-overview.md#overview-of-operation) for details.
3. **cbuild2cmake** converts this Build Information into CMake format.
4. **CMake/Ninja** call the C/C++ compiler toolchain to translate the source files into the application image.

!!! Note
    The CMSIS-Toolbox build system does not use the CMake compiler and linker flags specified by environment variables [CFLAGS, LDFLAGS](https://cmake.org/cmake/help/latest/envvar/CFLAGS.html).  
    Refer to the chapter [Build Operation](build-operation.md) for further details of the build process.

## Command Line and IDE Usage

The CMSIS-Toolbox is a set of command line tools that are designed for stand-alone usage and integration into IDEs or DevOps systems for Continuous Integration (CI) workflows.

![Operation of `csolution` tool](./images/tool-overview.png "Operation of `csolution` tool")

The [VS Code](https://marketplace.visualstudio.com/items?itemName=Arm.keil-studio-pack) IDE integration available from Arm is a viewer to the [*csolution project files*](YML-Input-Format.md) and provides graphical ways to modify the content. Refer to [DevOps Usage](build-tools.md#devops-usage) for more information on integration into CI workflows.

## Benefits

The overall benefits of the CMSIS-Toolbox are:

- Flexible command line tools that can be used stand-alone or integrated into [VS Code](https://marketplace.visualstudio.com/items?itemName=Arm.keil-studio-pack) or [DevOps systems for Continuous Integration (CI)](build-tools.md#devops-usage).
- Stand-alone tools are available [for all host platforms](https://artifacts.keil.arm.com/cmsis-toolbox/) (Windows, Mac, Linux) for flexible deployment.
- [*Software packs*](https://www.keil.arm.com/packs/) simplify tool setup with `device:` or `board:` selection and project creation with access to reusable software components.
- Organize solutions with projects that are independently managed simplifies a wide range of use cases including  multi-processor applications or unit testing.
- Integrates with domain specific [generators](build-overview.md#use-a-generator) (i.e. CubeMX) that support configuration of devices/boards and complex software stacks such as motor control.
- Provisions for product lifecycle management (PLM) with versioned *software packs* that ease update and management for configuration files.
- Software layers enable code reuse across similar applications with a pre-configured set of source files and software components.
- Target types allow application deployment to different hardware (test board, production hardware, virtual simulation models, etc.).
- Build types support software testing and verification (debug build, test build, release build, ect.).
- Support for multiple toolchains, even within the same set of *project files* and command line options to select different toolchains during verification.
- [Linker Script Management](build-overview.md#linker-script-management) utilizes device and board information of *software packs* to define available memory and allows flexible control of linker operation.
- Uses a CMake backend for the build process that integrates with other tools such as VS Code intellisense.
- Provides a [list of software licenses](YML-CBuild-Format.md#licenses) used by the various software packs and software components.
