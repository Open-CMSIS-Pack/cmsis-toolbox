# CMSIS-Toolbox: Installation

Content:

- [CMSIS-Toolbox: Installation](#cmsis-toolbox-installation)
  - [Download](#download)
  - [Installation](#installation)
    - [Requirements](#requirements)
    - [Toolchain Options](#toolchain-options)
  - [Configuration](#configuration)
    - [Environment Variables](#environment-variables)
    - [./etc/\*.cmake](#etccmake)
    - [Setup Win64](#setup-win64)
    - [Setup Linux or Bash](#setup-linux-or-bash)
    - [Setup MacOS](#setup-macos)
  - [Using VS Code](#using-visual-studio-code)
  - [Get Started](#get-started)
  

## Download

Download the CMSIS-Toolbox from the [**release page**](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases). It is provided for Win64, Linux, and MacOS in an archive file.

> Note: The `cmsis-toolbox.sh` is provided for legacy reasons, but may be deprecated in future versions.

## Installation

To setup the **CMSIS-Toolbox** on a local computer, copy the content of the archive file to an `<cmsis-toolbox-installation-dir>`, for example to `/c/ctools`.

### Requirements

The CMSIS-Toolbox uses the CMake build system with a Ninja generator. The installation of these tools is required.

- [**CMake**](https://cmake.org/download) version 3.18.0 or higher.
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

It is required to customize the installation for the actual setup of your development environment as described in the following.

### Environment Variables

The various tools use the following environment variables.

Environment Variable     | Description
:------------------------|:------------
**CMSIS_PACK_ROOT**      | Path to the CMSIS-Pack Root directory (i.e. /c/open-cmsis/pack) that stores software packs
**CMSIS_COMPILER_ROOT**  | Path to the CMSIS-Toolbox `etc` directory (i.e. /c/ctools/etc)
**Path**                 | Add to the system path to the CMSIS-Toolbox 'bin' directory (i.e. /c/ctools/bin)

#### **CMSIS_PACK_ROOT:** This variable points to the [CMSIS-Pack Root Directory](https://github.com/Open-CMSIS-Pack/devtools/wiki/The-CMSIS-PACK-Root-Directory) that stores [software packs](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html).

- The default values for the supported platforms are listed below.
  Platform    | Default path
  :-----------|:------------
  Linux       | ${HOME}/.cache/arm/packs
  Windows     | ${LOCALAPPDATA}/Arm/Packs
  MacOS       | ${HOME}/.cache/arm/packs
  WSL_Windows | ${LOCALAPPDATA}/Arm/Packs

> Note: If you do not have a CMSIS-Pack root yet, use [**cpackget**](../../cpackget/docs/cpackget.md) to initialize your repository.

### ./etc/\*.cmake

The support of the various toolchains is defined by `*.cmake` files in the directory `<cmsis-toolbox-installation-dir>/etc`.

> Note: The filenames reflect the available compiler versions on the host system.  There may be multiple files for each compiler to support different versions, for example `AC6.6.16.0.cmake` and `AC6.6.18.0.cmake`.

Each of these `*.cmake` files defines the path (`TOOLCHAIN_ROOT`) to the toolchain binaries, the file extension (`EXT`) of the executable binaries, the version (`CMAKE_C_COMPILER_VERSION`) and other compiler related parameters for the invocation. Edit the files to reflect the path as shown in the example (for `AC6`) below:

```CMake
############### EDIT BELOW ###############
# Set base directory of toolchain
set(TOOLCHAIN_ROOT "C:/Keil_v5/ARM/ARMCLANG/bin")
set(TOOLCHAIN_VERSION "6.19.0")
set(EXT .exe)
############ DO NOT EDIT BELOW ###########
```

### Setup Win64

For Windows, use the dialog **System Properties - Advanced** and add the **Environment Variables** listed above.

#### Keil MDK
The CMSIS-Toolbox is shipped as part of the installer. The tools are located in the `ARM\ctools` directory of the MDK installation.

Adding the binary directory of the ctools directory to your **PATH** environment variable allows you to invoke the tools at the
command line without the need to specify the full path (default: `C:\Keil_v5\ARM\ctools\bin`)

For sharing the pack directory between MDK and the ctools it is required that both **CMSIS_PACK_ROOT** environment variable
and the **RTE_PATH** setting in the MDK's TOOLS.INI (default: C:\Keil_v5\TOOLS.INI) point to the same directory.
Note that in case the default location `%localappdata%\Arm\Packs` was selected during installation, the seeting of **CMSIS_PACK_ROOT**
environment variable is not required.

The **CMSIS_COMPILER_ROOT** environment varible is not required if the compiler configuration files provided in ctools/etc are used.

> Note: At the Windows command prompt, use `set` to list all environment variables.

### Setup Linux or Bash

In Linux,  there are multiple ways to configure the **Environment Variables**. In a Bash environment, add the following content to the file `.bashrc` for example:

**Example:**

```Shell
export CMSIS_PACK_ROOT=/home/ubuntu/packs
export CMSIS_COMPILER_ROOT=/opt/ctools/etc
export PATH=/opt/ctools/bin:$PATH
```

> Note: The command `printenv` should list these environment variables.

### Setup MacOS

MacOS protects by default execution of files that are downloaded and/or not signed. As the CMSIS-Toolbox is currently not signed, it is required to execute the following commands after installation:

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

## Using Visual Studio Code

[Visual Studio Code](https://code.visualstudio.com/) is an effective environment to create CMSIS-based projects.  As [**csolution**](../../projmgr/docs/Manual/Overview.md) files are in YAML format, it is recommended to install:

- [**YAML Language Support by Red Hat**](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml).

To work with the **CMSIS-Toolbox** in VS Code use:

- **Terminal - New Terminal** to open a terminal window, on Win64 choose as profile `Command prompt`.

- In the **Terminal** window, enter the commands for the tools as explained in [project creation](#project-creation).

### Project Creation

To create a new [**csolution**](projmgr/docs/Manual/Overview.md) based CMSIS project in VS Code:

- Copy the `{{SolutionName}}.csolution.yml` and `{{ProjectName}}.cproject.yml` templates from the `<cmsis-toolbox-installation-dir/etc/` into your project directory and choose filenames at your discretion.

- Edit the YAML files to select a device, add files and components. The template files have references to the YAML schemas in the first comment `#yaml-language-server`.

- Use the Package Installer [**cpackget**](../../cpackget/docs/cpackget.md) to create a new pack repository, download and install packs.

- Use the Project Manager [**csolution**](../../projmgr/docs/Manual/Overview.md) to get information from the installed packs such as device names and component identifiers, to validate the solution and to generate the `*.CPRJ` files for compilation.

- Use the Build Manager [**cbuild**](../../buildmgr/docs/cbuild.md) to generate CMakeLists, invoking CMake to generate artifacts and compilation database for enabling IntelliSense.

>Note: Keil MDK may be used to [*import*](https://www.keil.com/support/man/docs/uv4/uv4_ui_import.htm) and [*export*](https://www.keil.com/support/man/docs/uv4/uv4_ui_export.htm) project files in `*.CPRJ` format.
