# Installation

[**> CMSIS-Toolbox**](README.md) **> Installation**

This chapter explains the setup of the CMSIS-Toolbox along with a build environment.

**Chapter Contents:**

- [Installation](#installation)
  - [Download](#download)
  - [Setup](#setup)
    - [Requirements](#requirements)
    - [Toolchain Options](#toolchain-options)
  - [Configuration](#configuration)
    - [Environment Variables](#environment-variables)
      - [CMSIS\_PACK\_ROOT](#cmsis_pack_root)
      - [TOOLCHAIN Registration](#toolchain-registration)
      - [./etc/\*.cmake](#etccmake)
    - [Setup Win64](#setup-win64)
      - [Keil MDK](#keil-mdk)
    - [Setup Linux or Bash](#setup-linux-or-bash)
    - [Setup MacOS](#setup-macos)
  - [Setup a Build Environment](#setup-a-build-environment)
  - [Using Visual Studio Code](#using-visual-studio-code)
  
## Download

Download the CMSIS-Toolbox from the [**release page**](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases). It is provided for Windows (amd64), Linux (amd64, arm64), and MacOS (amd64) in an archive file.

## Setup

To setup the **CMSIS-Toolbox** on a local computer, copy the content of the archive file to an `<cmsis-toolbox-installation-dir>`, for example to `/c/cmsis-toolbox`.

### Requirements

The CMSIS-Toolbox uses the CMake build system with a Ninja generator. The installation of these tools is required.

- [**CMake**](https://cmake.org/download) version 3.22.0 or higher.

> Note: For Win64, enable the install option *Add CMake to the system PATH*.

- [**Ninja**](https://github.com/ninja-build/ninja/releases) version 1.10.0 or higher.

> Note: [**Ninja**](https://github.com/ninja-build/ninja/releases) may be copied to the `<cmsis-toolbox-installation-dir>/bin` directory.

### Toolchain Options

The CMSIS-Toolbox works with the following toolchains. Install one or more toolchains depending on your requirements.

- [**GNU Arm Embedded Toolchain**](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads) version 10.3.1 or higher.

- [**Keil MDK**](http://www.keil.com/mdk5/install) version 5.36 or higher.

- [**Arm Compiler**](https://developer.arm.com/tools-and-software/embedded/arm-compiler/downloads/version-6) version 6.18 or higher.

- [**IAR EW-Arm**](https://www.iar.com/products/architectures/arm/iar-embedded-workbench-for-arm/) is currently in alpha quality.

## Configuration

It maybe required to customize the installation for the actual setup of your development environment as described in the following.

### Environment Variables

The various tools use the following environment variables.

Environment Variable     | Description
:------------------------|:------------
`<name>`**\_TOOLCHAIN_**`<major>`\_`<minor>`\_`<patch>` | Path to the toolchain binaries
**CMSIS_PACK_ROOT**      | Path to the CMSIS-Pack Root directory (i.e. /c/open-cmsis/pack) that stores software packs
**CMSIS_COMPILER_ROOT**  | Path to the CMSIS-Toolbox `etc` directory (i.e. /c/cmsis-toolbox/etc)
**Path**                 | Add to the system path to the CMSIS-Toolbox 'bin' directory (i.e. /c/cmsis-toolbox/bin)

#### CMSIS_PACK_ROOT

This variable points to the [CMSIS-Pack Root Directory](https://github.com/Open-CMSIS-Pack/devtools/wiki/The-CMSIS-PACK-Root-Directory) that stores [software packs](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html).

- The default values for the supported platforms are listed below.
  Platform    | Default path
  :-----------|:------------
  Linux       | ${HOME}/.cache/arm/packs
  Windows     | ${LOCALAPPDATA}/Arm/Packs
  MacOS       | ${HOME}/.cache/arm/packs
  WSL_Windows | ${LOCALAPPDATA}/Arm/Packs

> Note: If you do not have a CMSIS-Pack root yet, use [**cpackget**](./cpackget.md) to initialize your repository.

#### TOOLCHAIN Registration

The registration of a toolchain is manually defined by an environment variable with its name and semantic version numbers (major, minor and patch) in the format:

```txt
<name>_TOOLCHAIN_<major>_<minor>_<patch>=<path/to/toolchain/binaries>
```

For example in Windows:

```txt
set AC6_TOOLCHAIN_6_19_0=C:/Keil_v5/ARM/ARMCLANG/bin
```

For example in Unix:

```txt
export GCC_TOOLCHAIN_10_3_1=/opt/gcc-arm-none-eabi-10.3-2021.10/bin
```

#### ./etc/\*.cmake

The mappings and dictionaries for various toolchain version ranges are defined by `*.cmake` files in the directory `<cmsis-toolbox-installation-dir>/etc`.

> **Notes:**
>
> - Since cmsis-toolbox 1.5.0 these files are not specific to a single toolchain. Filenames reflect the **minimum compiler versions** that can be registered on the host system.
> - There may be multiple files for each compiler to support different version ranges, for example  `AC6.6.16.0.cmake` and `AC6.6.18.0.cmake`.
> - For backward compatibility it is still possible to set the CMake variables `TOOLCHAIN_ROOT` and `TOOLCHAIN_VERSION` in each of these `*.cmake` files defines, but this will be removed in cmsis-toolbox 2.0.0 and therefore it is already recommended to use the [environment variable registration](#toolchain-registration) instead.

```CMake
############### EDIT BELOW ###############
# Set base directory of toolchain
set(TOOLCHAIN_ROOT "C:/Keil_v5/ARM/ARMCLANG/bin")
set(TOOLCHAIN_VERSION "6.19.0")

############ DO NOT EDIT BELOW ###########
```

### Setup Win64

For Windows, use the dialog **System Properties - Advanced** and add the **Environment Variables** listed above.

#### Keil MDK

The CMSIS-Toolbox is shipped as part of the installer. The tools are located in the `ARM\cmsis-toolbox` directory of the MDK installation.

Adding the binary directory of the cmsis-toolbox directory to your **PATH** environment variable allows you to invoke the tools at the
command line without the need to specify the full path (default: `C:\Keil_v5\ARM\cmsis-toolbox\bin`)

For sharing the pack directory between MDK and the CMSIS-Toolbox it is required that both **CMSIS_PACK_ROOT** environment variable
and the **RTE_PATH** setting in the MDK's TOOLS.INI (default: C:\Keil_v5\TOOLS.INI) point to the same directory.
Note that in case the default location `%localappdata%\Arm\Packs` was selected during installation, the setting of **CMSIS_PACK_ROOT**
environment variable is not required.

The **CMSIS_COMPILER_ROOT** environment varible is not required if the compiler configuration files provided in cmsis-toolbox/etc are used.

> Note: At the Windows command prompt, use `set` to list all environment variables.

### Setup Linux or Bash

In Linux,  there are multiple ways to configure the **Environment Variables**. In a Bash environment, add the following content to the file `.bashrc` for example:

**Example:**

```Shell
export CMSIS_PACK_ROOT=/home/ubuntu/packs
export CMSIS_COMPILER_ROOT=/opt/cmsis-toolbox/etc
export PATH=/opt/cmsis-toolbox/bin:$PATH
```

> Note: The command `printenv` should list these environment variables.

### Setup MacOS

MacOS protects by default execution of files that are downloaded and/or not signed. As the CMSIS-Toolbox is not signed, it is required to execute the following commands after installation:

- Remove the flags that prevent execution for downloaded executables

```Shell
xattr -dr com.apple.quarantine <cmsis-toolbox-installation-dir>/bin/
```

- Add execution permissions for all executables in `./bin`

```Shell
chmod +x <cmsis-toolbox-installation-dir>/bin/cbuildgen
chmod +x <cmsis-toolbox-installation-dir>/bin/cbuild
...
```

## Setup a Build Environment

To create a new [**csolution**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/Manual/Overview.md) build environment for CMSIS-based project:

- Use the Package Installer [**cpackget**](cpackget.md) to [initialize the CMSIS-Pack root directory](./cpackget.md#initialize-cmsis-pack-root-directory), [update the pack index file](./cpackget.md#update-pack-index-file) and [add software packs](./cpackget.md#add-packs).

- Use the Project Manager [**csolution**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/Manual/Overview.md) to get information from the installed packs such as device names and component identifiers, to validate the csolution and to generate the `*.CPRJ` files for compilation.

- Use the Build Manager [**cbuild**](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/buildmgr/README.md) to generate `cmakelist.txt` files and control the build process.

>Note: Keil MDK may be used to [*import*](https://www.keil.com/support/man/docs/uv4/uv4_ui_import.htm) and [*export*](https://www.keil.com/support/man/docs/uv4/uv4_ui_export.htm) project files in `*.CPRJ` format.

## Using Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com/) is an effective environment to create CMSIS-based projects.  To setup an environment install the [Keil Studio Pack](https://marketplace.visualstudio.com/items?itemName=Arm.keil-studio-pack) extension from the Visual Studio marketplace.

To work with the **CMSIS-Toolbox** in VS Code use:

- **Terminal - New Terminal** to open a terminal window, on Win64 choose as profile `Command prompt`.

- In the **Terminal** window, enter the commands for the tools as explained in [project examples](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/docs/Manual/Overview.md#project-examples).\

Refer also to the repository [vscode-get-started](https://github.com/Open-Pack/vscode-get-started) for more information.
