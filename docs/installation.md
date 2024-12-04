# Installation

<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **&raquo; Installation**

This chapter explains the setup of the CMSIS-Toolbox along with a build environment.

There are three different ways to setup the CMSIS-Toolbox:

- [Manual setup](#manual-setup) with operating system commands and environment variables.
- [vcpkg - CLI](#vcpkg---setup-using-cli) using the vcpkg tool in command-line mode
- [vcpkg - VS Code](#vcpkg---setup-in-vs-code) using the vcpkg tool with VS Code integration

**Chapter Contents:**

- [Installation](#installation)
  - [Manual Setup](#manual-setup)
    - [Requirements](#requirements)
    - [Compiler Toolchains](#compiler-toolchains)
    - [Environment Variables](#environment-variables)
      - [Default Values](#default-values)
      - [Compiler Registration](#compiler-registration)
      - [Setup Win64](#setup-win64)
      - [Setup Linux or Bash](#setup-linux-or-bash)
      - [Setup macOS](#setup-macos)
    - [Registering CMSIS\_PACK\_ROOT with cpackget](#registering-cmsis_pack_root-with-cpackget)
  - [vcpkg - Setup using CLI](#vcpkg---setup-using-cli)
  - [vcpkg - Setup in CI](#vcpkg---setup-in-ci)
    - [GitHub Actions](#github-actions)
    - [Other CI Systems](#other-ci-systems)
  - [vcpkg - Setup in VS Code](#vcpkg---setup-in-vs-code)
  - [CMSIS\_PACK\_ROOT](#cmsis_pack_root)
  
## Manual Setup

Download the CMSIS-Toolbox from the [**Arm tools artifactory**](https://artifacts.keil.arm.com/cmsis-toolbox/). Signed binaries are provided for Windows (amd64), Linux (amd64, arm64), and MacOS/Darwin (amd64, arm64) in an archive file.

To setup the **CMSIS-Toolbox** on a local computer, copy the content of the archive file to an `<cmsis-toolbox-installation-dir>`, for example to `~/cmsis-toolbox`.

### Requirements

The CMSIS-Toolbox uses the CMake build system with a Ninja generator. The installation of these tools is required.

- [**CMake**](https://cmake.org/download) version 3.25.2 or higher.

  > **Note:**
  >
  > For Win64, enable the install option *Add CMake to the system PATH*.

- [**Ninja**](https://github.com/ninja-build/ninja/releases) version 1.10.2 or higher.

  > **Note:**
  >
  > [**Ninja**](https://github.com/ninja-build/ninja/releases) may be copied to the `<cmsis-toolbox-installation-dir>/bin` directory.

### Compiler Toolchains

The CMSIS-Toolbox works with the following compiler toolchains. Install one or more compilers depending on your requirements.

- [**GNU Arm Embedded Compiler**](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/downloads) version 10.3.1 or higher.

- [**Keil MDK**](https://www.keil.com/mdk5/install) version 5.36 or higher.

- [**Arm Compiler for Embedded**](https://developer.arm.com/tools-and-software/embedded/arm-compiler/downloads/version-6) version 6.18.0 or higher
  - Arm FuSa Compiler for Embedded version 6.16.2 or higher is also supported

- [**IAR EW-Arm**](https://www.iar.com/products/architectures/arm/iar-embedded-workbench-for-arm/) version 9.32.1 or higher.

- [**CLANG Embedded Compiler**](https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/latest) version 17.0.1 or higher.

### Environment Variables

It maybe required to customize the installation for the actual setup of your development environment as described in the following.

The various tools use the following environment variables.

Environment Variable     |             | Description
:------------------------|:------------|:------------
`<name>`**\_TOOLCHAIN_**`<major>`\_`<minor>`\_`<patch>` | **Required** | Path to the [compiler binaries](#compiler-registration) where `<name>` is one of AC6, GCC, IAR, CLANG.
**CMSIS_PACK_ROOT**      | Optional | Path to the [CMSIS-Pack Root](#cmsis_pack_root) directory that stores [software packs](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html).
**CMSIS_COMPILER_ROOT**  | Optional | Path to the CMSIS-Toolbox `etc` directory (i.e. `/c/cmsis-toolbox/etc`).
**Path**                 | **Required** | Add to the system path the CMSIS-Toolbox `bin` directory (i.e. `/c/cmsis-toolbox/bin`) as well as CMake and Ninja.

#### Default Values

The environment variable **CMSIS_PACK_ROOT** and **CMSIS_COMPILER_ROOT** are optional. If missing, default settings are used.

- **CMSIS_PACK_ROOT** default values:

  Platform    | Default path
  :-----------|:------------
  Linux       | `${HOME}/.cache/arm/packs`
  Windows     | `%LOCALAPPDATA%\Arm\Packs`
  MacOS       | `${HOME}/.cache/arm/packs`
  WSL_Windows | `${LOCALAPPDATA}/Arm/Packs`

- **CMSIS_COMPILER_ROOT** default is `<toolbox>/bin/../etc`, i.e., `etc` folder relative to the toolbox executables. It is used to locate:

  - Toolchain cmake files `<compiler-name>.<major>.<minor>.<patch>.cmake` for the selected [compiler](YML-Input-Format.md#compiler).
  - Default [linker script files](build-overview.md#linker-script-management) (to be preprocessed): `<compiler-name>_linker_script.<ext>.src`
  - The `cdefault.yml` that is used when no other [`cdefault.yml`](YML-Input-Format.md#cdefault) file is found.

#### Compiler Registration

The compiler toolchain is registered with an environment variable that includes compiler name (AC6, GCC, IAR, LLVM) and version number (major, minor and patch). This information is used by the [`compiler:`](YML-Input-Format.md#compiler) node or the `--toolchain` option to choose the compiler.

**Format:**

```txt
<name>_TOOLCHAIN_<major>_<minor>_<patch>=<path/to/toolchain/binaries>
```

**Example for Windows:**

```txt
set AC6_TOOLCHAIN_6_19_0=C:\Keil_v5\ARM\ARMCLANG\bin
```

**Example for Unix:**

```txt
export GCC_TOOLCHAIN_10_3_1=/opt/gcc-arm-none-eabi-10.3-2021.10/bin
```

#### Setup Win64

For Windows, use the dialog **System Properties - Advanced** and add the **Environment Variables** listed above.

**Keil MDK version 5**

When using Keil MDK version 5, the CMSIS-Toolbox is shipped as part of the installer. The tools are located in the directory `.\ARM\cmsis-toolbox` of the MDK installation.

Adding the binary directory of the cmsis-toolbox directory to your **PATH** environment variable allows you to invoke the tools at the
command line without the need to specify the full path (default: `C:\Keil_v5\ARM\cmsis-toolbox\bin`)

For sharing the pack directory between MDK and the CMSIS-Toolbox it is required that both **CMSIS_PACK_ROOT** environment variable
and the **RTEPATH** setting in the MDK's TOOLS.INI (default: C:\Keil_v5\TOOLS.INI) point to the same directory.
Note that in case the default location `%LOCALAPPDATA%\Arm\Packs` was selected during installation, the setting of **CMSIS_PACK_ROOT**
environment variable is not required.

The **CMSIS_COMPILER_ROOT** environment variable is not required if the compiler configuration files provided in cmsis-toolbox/etc are used.

> **Notes:**
>
> At the Windows command prompt, use `set` to list all environment variables.
>
> Keil µVision may be used to:
>
> - [*open*](https://developer.arm.com/documentation/101407/latest/User-Interface/Project-Menu-and-Commands) projects in `*.csolution.yml` format (since v5.40).
> - [*export*](https://www.keil.com/support/man/docs/uv4/uv4_ui_export.htm) project files in `*.csolution.yml` format.
> - [*import*](https://www.keil.com/support/man/docs/uv4/uv4_ui_import.htm) project files in `*.CPRJ` format.

#### Setup Linux or Bash

In Linux,  there are multiple ways to configure the **Environment Variables**. In a Bash environment, add the following content to the file `.bashrc` for example:

**Example:**

```txt
export CMSIS_PACK_ROOT=/home/ubuntu/packs
export CMSIS_COMPILER_ROOT=/opt/cmsis-toolbox/etc
export PATH=/opt/cmsis-toolbox/bin:$PATH
```

> Note: The command `printenv` should list these environment variables.

#### Setup macOS

Add execution permissions for all executables in `./bin`

```Shell
chmod +x <cmsis-toolbox-installation-dir>/bin/cbridge
chmod +x <cmsis-toolbox-installation-dir>/bin/cbuild
...
```

### Registering CMSIS_PACK_ROOT with cpackget

Once you are done with setting up the environment variables, run the following on the command line:

```Shell
cpackget init https://www.keil.com/pack/index.pidx
```

> **Note:**
>
> Arm is running a public indexing server at the URL provided. You can specify any indexing server URL if you do not wish to use this service.

## vcpkg - Setup using CLI

The [vcpkg](https://vcpkg.io/en/) is a management tool for packages and includes features to manage tool artifacts. Arm provides an artifactory system for tools. Refer to [Arm Tools Available in vcpkg](https://www.keil.arm.com/packages/) for more information.

> **Note:**
>
> Microsoft changed the name of the shell version from `vcpkg` to `vcpkg-shell`. Depending on the version that you are using, you may need to call `vcpkg-shell` from the command line instead of `vcpkg`.

The following describes how to setup the CMSIS-Toolbox with `vcpkg` in a command line (CLI) environment. In many examples there is already the file `vcpkg-configuration.json` which describes the tool environment required for the example. Refer to the last step to create an new `vcpkg-configuration.json` file.

1. Install and enable vcpkg; the command depends on the shell.

   - Windows Command Prompt (cmd)

      ```bat
      curl -LO https://aka.ms/vcpkg-init.cmd && .\vcpkg-init.cmd
      %USERPROFILE%\.vcpkg\vcpkg-init.cmd
      ```

   - Windows PowerShell

      ```ps1
      iex (iwr -useb https://aka.ms/vcpkg-init.ps1)
      . ~/.vcpkg/vcpkg-init.ps1
      ```

   - Linux (x64)/macOS

      ```sh
      . <(curl https://aka.ms/vcpkg-init.sh -L)
      . ~/.vcpkg/vcpkg-init
      ```
  
    > **Note:**
    > vcpkg is currently not working on
    >
    > - MSYS Bash (such as Git Bash) on Windows.
    > - Linux (aarch64)

2. Activate required tools using one of the following methods:
  
   Prerequisite: a `vcpkg-configuration.json` file is present in the current directory or any parent directory.

    ```txt
    vcpkg activate
    ```

   > **Note:**
   >
   > In case that activate fails, update registries to access latest versions of the tools artifacts:
   >
   > ```txt
   > vcpkg x-update-registry --all
   > ```

3. Deactivate previous configuration

   ```txt
   vcpkg deactivate
   ```

4. Create a new `vcpkg-configuration.json` file with these commands:

   ```txt
   vcpkg new --application
   vcpkg add artifact arm:cmsis-toolbox [--version major.minor.patch]
   vcpkg add artifact arm:cmake
   vcpkg add artifact arm:ninja
   vcpkg add artifact arm:arm-none-eabi-gcc
   vcpkg activate
   ```  

Alternatively, you may use an existing repository, for example [github.com/Open-CMSIS-Pack/vscode-get-started](
https://github.com/Open-CMSIS-Pack/vscode-get-started) with a `vcpkg-configuration.json` file.

## vcpkg - Setup in CI

Using vcpkg in Continuous Integration (CI) environments is basically like [using it in a CLI environment](#vcpkg---setup-using-cli).

The way how `vcpkg artifacts` updates the current shell environment needs to be taken into account when creating CI
pipelines. The command `vcpkg activate` updates the current environment variables by extending `PATH` and adding
additional variables required by installed artifacts. These modifications are only visible in the current running
shell and spawned subprocesses.

This enables also manual usage on a local prompt, given a typical user runs subsequent commands from the same
parent shell process. In contrast, typical CI systems such as GitHub Actions or Jenkins spawn a new sub-shell for each
step of a pipeline. Hence, modifications made to the environment in one sub-shell by running the `vcpkg activate`
command are not persisted into the subsequent steps.

Another aspect to consider is about handling the local vcpkg cache (e.g., `~/.vcpkg`). Common practice on CI systems is
to recreate a clean environment for each run. Hence, vcpkg and all required artifacts are re-downloaded on every run.
This may cause massive bandwidth requirements for downloading the same (huge) archives all the time. Instead, consider preserving the local vcpkg cache between runs.

### GitHub Actions

GitHub Actions allow you to preserve environment settings via the files
exposed in `$GITHUB_PATH` and `$GITHUB_ENV`. Refer to the custom action provided in [github.com/ARM-software/cmsis-actions - Action: vcpkg](https://github.com/ARM-software/cmsis-actions) for more information.

Preserving the runners, between runs `vcpkg cache` is achieved with an `actions/cache` step preceding the
first `vcpkg activate` command. The above custom action uses this `actions/cache` step.

### Other CI Systems

In CI Systems without a vcpkg integration:

- Keep all tool installations depending on an activated environment within the same shell block, or
- Repeat activation for each new shell block before running any dependent command.

  ```sh
  . ~/.vcpkg/vcpkg-init
  vcpkg activate
  ```

## vcpkg - Setup in VS Code

1. Download & Install [Microsoft Visual Studio Code](https://code.visualstudio.com/download) for your operating system.
2. Launch Visual Studio Code. Using the menu `View` and open `Extensions` and install the `Keil Studio Pack` extensions.
3. Use the menu `View` and open `Source Control`. Select 'Clone Repository' and enter as url [`https://github.com/Open-CMSIS-Pack/vscode-get-started`](https://github.com/Open-CMSIS-Pack/vscode-get-started).
4. Specify the destination folder to clone to and select 'Open' when asked 'Would you like to open the cloned directory?'
5. Use `View` menu 'Explorer' and select the file `vcpkg-configuration.json`. This file instructs [Microsoft vcpkg](https://github.com/microsoft/vcpkg-tool#vcpkg-artifacts) to install the prerequisite artifacts required for building the solution and installs therefore:

    - CMSIS-Toolbox 2.6.1
    - cmake 3.28.4
    - ninja 1.12.0
    - arm-none-eabi-gcc 13.3.1-mpacbti (GNU Arm Embedded Toolchain 13.3.1)

> **Note:**
>
> In case vcpkg shows an error in the VSCode status bar, you can see further information in the `vcpkg` output.

Once the tools are installed, you may use the [CMSIS-Toolbox commands](build-tools.md) in a **Terminal** window of VS Code. If the terminal icon shows a yellow triangle with exclamation mark, you have to start a new terminal. This ensures that the environment settings updates triggered by the vcpkg activation are reflected in the terminal.

Alternatively use `View` and open the `CMSIS` Extension. Then use the `Build` buttons to translate the project, flash your connected board and/or launch a debug connection.

## CMSIS_PACK_ROOT

The [environment variable `CMSIS_PACK_ROOT`](#environment-variables) defines location of the directory that stores the software packs. This directory has the following structure.

Content of `CMSIS_PACK_ROOT` | Description
:----------------------------|:----------------
`pack.idx`                   | Empty file that is touched (timestamp is updated) when packs are added or removed.
`/.Web`                      | Contains `*.pdsc` files available on public web pages.
`/.Web/index.pidx`           | An index file that lists public available software packs.
`/.Download`                 | A local cache of packs that are downloaded.
`/.Local`                    | Stores the file `local_repository.pidx` that refers local `*.pdsc` files during pack development. Refer to  [install a repository](build-tools.md#install-a-repository) for more information.
`/<vendor>/<name>/<version>` | Extracted software packs that are available for development using the CMSIS-Toolbox.

> **Note:**
>
> For more details refer to the [CMSIS_PACK_ROOT Directory Wiki page](https://github.com/Open-CMSIS-Pack/devtools/wiki/The-CMSIS-PACK-Root-Directory).

[**Overview**](overview.md) **&laquo; Chapters &raquo;** [**Build Overview**](build-overview.md)
