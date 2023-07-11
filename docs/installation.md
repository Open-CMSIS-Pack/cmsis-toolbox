# Installation

<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **> Installation**

This chapter explains the setup of the CMSIS-Toolbox along with a build environment.

There are three different ways to setup the CMSIS-Toolbox:

- [Manual setup](#manual-setup) with operating system commands and environment variables.
- [vcpkg - CLI](#vcpkg---setup-using-cli) using the vcpkg tool in command-line mode
- [vcpgk - VS Code](#vcpgk---setup-in-vs-code) using the vcpgk tool with VS Code integration

**Chapter Contents:**

- [Installation](#installation)
  - [Manual Setup](#manual-setup)
    - [Requirements](#requirements)
    - [Toolchain Options](#toolchain-options)
    - [Environment Variables](#environment-variables)
      - [Default Values](#default-values)
      - [TOOLCHAIN Registration](#toolchain-registration)
      - [Setup Win64](#setup-win64)
      - [Setup Linux or Bash](#setup-linux-or-bash)
      - [Setup MacOS](#setup-macos)
  - [vcpkg - Setup using CLI](#vcpkg---setup-using-cli)
  - [vcpgk - Setup in VS Code](#vcpgk---setup-in-vs-code)
  
## Manual Setup

Download the CMSIS-Toolbox from the [**release page**](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/releases). It is provided for Windows (amd64), Linux (amd64, arm64), and MacOS/Darwin (amd64, arm64) in an archive file.

To setup the **CMSIS-Toolbox** on a local computer, copy the content of the archive file to an `<cmsis-toolbox-installation-dir>`, for example to `/c/cmsis-toolbox`.

### Requirements

The CMSIS-Toolbox uses the CMake build system with a Ninja generator. The installation of these tools is required.

- [**CMake**](https://cmake.org/download) version 3.25.2 or higher.

> Note: For Win64, enable the install option *Add CMake to the system PATH*.

- [**Ninja**](https://github.com/ninja-build/ninja/releases) version 1.10.2 or higher.

> Note: [**Ninja**](https://github.com/ninja-build/ninja/releases) may be copied to the `<cmsis-toolbox-installation-dir>/bin` directory.

### Toolchain Options

The CMSIS-Toolbox works with the following toolchains. Install one or more toolchains depending on your requirements.

- [**GNU Arm Embedded Toolchain**](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads) version 10.3.1 or higher.

- [**Keil MDK**](http://www.keil.com/mdk5/install) version 5.36 or higher.

- [**Arm Compiler**](https://developer.arm.com/tools-and-software/embedded/arm-compiler/downloads/version-6) version 6.18 or higher.

- [**IAR EW-Arm**](https://www.iar.com/products/architectures/arm/iar-embedded-workbench-for-arm/) version 9.32.1 or higher.

- [**CLANG**](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/latest) version 16.0.0 or higher (experimental).

### Environment Variables

It maybe required to customize the installation for the actual setup of your development environment as described in the following.

The various tools use the following environment variables.

Environment Variable     | Description
:------------------------|:------------
`<name>`**\_TOOLCHAIN_**`<major>`\_`<minor>`\_`<patch>` | Path to the toolchain binaries
**CMSIS_PACK_ROOT**      | Path to the [CMSIS-Pack Root Directory](https://github.com/Open-CMSIS-Pack/devtools/wiki/The-CMSIS-PACK-Root-Directory) that stores [software packs](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html).
**CMSIS_COMPILER_ROOT**  | Path to the CMSIS-Toolbox `etc` directory (i.e. /c/cmsis-toolbox/etc)
**Path**                 | Add to the system path the CMSIS-Toolbox 'bin' directory (i.e. /c/cmsis-toolbox/bin) as well as CMake and Ninja.
**CMSIS_BUILD_ROOT**     | ** DEPRECATED **: Ensure that no environment variable with this name is defined in your environment, otherwise `cbuild` will use tools from the directory specified instead of the tools located side by side.

#### Default Values

The environment variable **CMSIS_PACK_ROOT** and **CMSIS_COMPILER_ROOT** are optional. If missing, default settings are used.

- **CMSIS_PACK_ROOT** default values:
  Platform    | Default path
  :-----------|:------------
  Linux       | ${HOME}/.cache/arm/packs
  Windows     | ${LOCALAPPDATA}/Arm/Packs
  MacOS       | ${HOME}/.cache/arm/packs
  WSL_Windows | ${LOCALAPPDATA}/Arm/Packs

- **CMSIS_COMPILER_ROOT** default is `

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

#### Setup Win64

For Windows, use the dialog **System Properties - Advanced** and add the **Environment Variables** listed above.

**Keil MDK**

When using Keil MDK version 5, the CMSIS-Toolbox is shipped as part of the installer. The tools are located in the `ARM\cmsis-toolbox` (in older versions `ARM\ctools`) directory of the MDK installation.

Adding the binary directory of the cmsis-toolbox directory to your **PATH** environment variable allows you to invoke the tools at the
command line without the need to specify the full path (default: `C:\Keil_v5\ARM\cmsis-toolbox\bin`)

For sharing the pack directory between MDK and the CMSIS-Toolbox it is required that both **CMSIS_PACK_ROOT** environment variable
and the **RTE_PATH** setting in the MDK's TOOLS.INI (default: C:\Keil_v5\TOOLS.INI) point to the same directory.
Note that in case the default location `%localappdata%\Arm\Packs` was selected during installation, the setting of **CMSIS_PACK_ROOT**
environment variable is not required.

The **CMSIS_COMPILER_ROOT** environment varible is not required if the compiler configuration files provided in cmsis-toolbox/etc are used.

> **Notes:**
>
> At the Windows command prompt, use `set` to list all environment variables.
>
> Keil MDK may be used to [*import*](https://www.keil.com/support/man/docs/uv4/uv4_ui_import.htm) and [*export*](https://www.keil.com/support/man/docs/uv4/uv4_ui_export.htm) project files in `*.CPRJ` format.

#### Setup Linux or Bash

In Linux,  there are multiple ways to configure the **Environment Variables**. In a Bash environment, add the following content to the file `.bashrc` for example:

**Example:**

```txt
export CMSIS_PACK_ROOT=/home/ubuntu/packs
export CMSIS_COMPILER_ROOT=/opt/cmsis-toolbox/etc
export PATH=/opt/cmsis-toolbox/bin:$PATH
```

> Note: The command `printenv` should list these environment variables.

#### Setup MacOS

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

## vcpkg - Setup using CLI

The following setups describe how to setup the CMSIS-Toolbox using a command line (CLI) environment.

1. Install and enable vcpkg; the command depends on the shell.

   - Windows Command Prompt (cmd)

   ```txt
   curl -LO https://aka.ms/vcpkg-init.cmd && .\vcpkg-init.cmd
   %USERPROFILE%\.vcpkg\vcpkg-init.cmd
     ```

   - Windows powerShell

    ```txt
    iex (iwr -useb https://aka.ms/vcpkg-init.ps1)
    . ~/.vcpkg/vcpkg-init.ps1
    ```

   - Linux / macOS

    ```txt
    . <(curl https://aka.ms/vcpkg-init.sh -L)
    . ~/.vcpkg/vcpkg-init
    ```

2. Activate required tools using one of the following methods:
  
   - `vcpkg-configuration.json` configuration file in current directory or any parent directory

   ```txt
   vcpkg activate
   ```

   - explicitly specify a `configuration.json` file

   ```txt
   vcpkg activate --project mypath/vcpkg-configuration.json
   ```

   - with explict commands

   ```txt
   vcpkg use arm:cmsis-toolbox microsoft:cmake microsoft:ninja arm:arm-none-eabi-gcc
   ```

3. Deactivate previous configuration

   ```txt
   vcpkg deactivate
   ```

4. Update registries to access latest versions of the tools artifacts.

   ```txt
   vcpkg  x-update-registry --all
   ```

5. Create a new vcpkg configuration file with these commands:

   ```txt
   vcpkg new --application
   vcpkg add artifact arm:cmsis-toolbox [--version major.minor.patch]
   vcpkg add artifact microsoft:cmake
   vcpkg add artifact microsoft:ninja
   vcpkg add artifact arm:arm-none-eabi-gcc
   vcpkg  activate
   ```  

Alternatively you may use an existing repository, for example [github.com/Open-CMSIS-Pack/vscode-get-started](
https://github.com/Open-CMSIS-Pack/vscode-get-started) with a vcpkg-configuration.json file.

## vcpgk - Setup in VS Code

1. Download & Install [Microsoft Visual Studio Code](https://code.visualstudio.com/download) for your operating system.
2. Launch Visual Studio Code. Using the menu `View` and open `Extensions` and install the `Keil Studio Pack` extensions.
3. Use the menu `View` and open `Source Control`. Select 'Clone Repository' and enter as url [`https://github.com/Open-CMSIS-Pack/vscode-get-started`](https://github.com/Open-CMSIS-Pack/vscode-get-started).
4. Specify the destination folder to clone to and select 'Open' when asked 'Would you like to open the cloned directory?'
5. Use `View` menu 'Explorer' and select the file `vcpkg-configuration.json`. This file instructs [Microsoft vcpkg](https://github.com/microsoft/vcpkg-tool#vcpkg-artifacts) to install the prerequisite artifacts required for building the solution and installs therefore:

    - CMSIS-Toolbox 2.0.0
    - cmake 3.25.2
    - ninja 1.10.2
    - arm-none-eabi-gcc 12.2.1-mpacbti (GNU Arm Embedded Toolchain 12.2.1)

> **Notes:**
>
> - In case vcpkg shows an error in the VSCode status bar, you can see further information in the `vcpkg` output.
>
> - In case of `Error: Unable to resolve dependency ... in \<registry\>` you may need to update the registry with the menu `View` option `Command Palette...`, select `vcpkg: Run vcpkg command` and enter: `z-ce update <registry>`. Newer versions of vcpkg support `x-update-registry --all` to update all registries.

Once the tools are installed you may use the [CMSIS-Toolbox commands](build-tools.md) in a **Terminal** window of VS Code. If the terminal icon shows a yellow triangle with exclamation mark, you have to start a new terminal for the environment settings updates triggered by the vcpkg activation to be reflected in the terminal. 

Alternatively use `View` and open the `CMSIS` Extension. Then use the `Build` buttons to translate the project, flash your connected board and/or launch a debug connection.
