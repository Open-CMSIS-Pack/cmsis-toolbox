# Build Tools

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **> Build Tools**

This chapter describes the tools [`cbuild`](#cbuild-invocation) (build projects), [`csolution`](#csolution-invocation) (transform *csolution project files*), and [`cpackget`](#cpackget-invocation) (manage software packs). It includes command line syntax details and examples.

**Chapter Contents:**

- [Build Tools](#build-tools)
  - [Requirements](#requirements)
  - [`cbuild` Invocation](#cbuild-invocation)
  - [`csolution` Invocation](#csolution-invocation)
  - [`cpackget` Invocation](#cpackget-invocation)
  - [Command Examples](#command-examples)
    - [List Environment](#list-environment)
    - [List Available Toolchains](#list-available-toolchains)
    - [Update Pack Index File](#update-pack-index-file)
    - [Build Project](#build-project)
    - [Update RTE Configuration Files](#update-rte-configuration-files)
    - [Add Software Packs](#add-software-packs)
    - [List Installed Packs](#list-installed-packs)
    - [Install Missing Packs](#install-missing-packs)
    - [List Devices or Boards](#list-devices-or-boards)
    - [List Unresolved Dependencies](#list-unresolved-dependencies)
    - [Create Build Information](#create-build-information)
    - [List Compatible Layers](#list-compatible-layers)
    - [Use Generators (i.e. CubeMX)](#use-generators-ie-cubemx)
    - [Use context set](#use-context-set)
    - [List configuration files](#list-configuration-files)
    - [Setup Project (for IDE)](#setup-project-for-ide)
  - [`cpackget` Details](#cpackget-details)
    - [Specify CMSIS-Pack root directory](#specify-cmsis-pack-root-directory)
    - [Initialize CMSIS-Pack root directory](#initialize-cmsis-pack-root-directory)
    - [Pack Index File](#pack-index-file)
    - [Add packs](#add-packs)
      - [Install public packs](#install-public-packs)
      - [Install a list of software packs](#install-a-list-of-software-packs)
      - [Accept End User License Agreement (EULA) from command line](#accept-end-user-license-agreement-eula-from-command-line)
      - [Work behind a proxy](#work-behind-a-proxy)
      - [Install a private software pack](#install-a-private-software-pack)
      - [Install a repository](#install-a-repository)
    - [List all software packs](#list-all-software-packs)
    - [Remove packs](#remove-packs)
  - [DevOps Usage](#devops-usage)
    - [Examples](#examples)

## Requirements

Install the CMSIS-Toolbox as described in chapter [Installation](installation.md).

The CMSIS-Pack repository must be present in the host development environment.

There are several ways to configure the CMSIS-Pack repository:

- Use the **`cpackget` Package Installer** command `init` to [initialize the CMSIS-Pack root directory](#initialize-cmsis-pack-root-directory), [update the pack index file](#update-pack-index-file). Then [add software packs](build-tools.md#add-packs).

- Share an existing CMSIS-Pack repository (i.e. from Keil MDK) via the environment variable `CMSIS_PACK_ROOT`.

## `cbuild` Invocation

Orchestrate the overall build steps utilizing the various tools of the CMSIS-Toolbox and a CMake-based compilation process.

```txt
cbuild: Build Invocation 2.5.0 (C) 2024 Arm Ltd. and Contributors

Usage:
  cbuild [command] <name>.csolution.yml [options]

Commands:
  help        Help about any command
  list        List information about environment, toolchains, and contexts
  setup       Generate project data for IDE environment

Options:
      --cbuild2cmake       Use build information files with cbuild2cmake backend (default)
      --cbuildgen          Use build information files with cbuildgen backend
  -C, --clean              Remove intermediate and output directories
  -c, --context arg [...]  Input context names [<project-name>][.<build-type>][+<target-type>]
  -S, --context-set        Select the context names from cbuild-set.yml for generating the target application
  -d, --debug              Enable debug messages
      --frozen-packs       Pack list and versions from cbuild-pack.yml are fixed and raises errors if it changes
  -g, --generator arg      Select build system generator (default "Ninja")
  -h, --help               Print usage
  -j, --jobs int           Number of job slots for parallel execution (default 8)
  -l, --load arg           Set policy for packs loading [latest | all | required] (default "required")
      --log arg            Save output messages in a log file
  -O, --output arg         Add prefix to 'outdir' and 'tmpdir'
  -p, --packs              Download missing software packs with cpackget
  -q, --quiet              Suppress output messages except build invocations
  -r, --rebuild            Remove intermediate and output directories and rebuild
  -s, --schema             Validate project input file(s) against schema
  -t, --target arg         Optional CMake target name
      --toolchain arg      Input toolchain to be used
      --update-rte         Update the RTE directory and files
  -v, --verbose            Enable verbose messages from toolchain builds
  -V, --version            Print version

Use "cbuild [command] --help" for more information about a command.
```

> **Note:**
>
> By default, the `cbuild` invocation does not update the [**RTE Directory**](build-overview.md#rte-directory-structure). Use the option `--update-rte` if this is required.

## `csolution` Invocation

Create build information for embedded applications that consist of one or more related projects.

```text
csolution: Project Manager 2.5.0 (C) 2024 Arm Ltd. and Contributors

Usage:
  csolution <command> [<name>.csolution.yml] [options]

Commands:
  convert                       Convert user input *.yml files to *.cprj files
  list boards                   Print list of available board names
  list configs                  Print list of configuration files
  list contexts                 Print list of contexts in a <name>.csolution.yml
  list components               Print list of available components
  list dependencies             Print list of unresolved project dependencies
  list devices                  Print list of available device names
  list environment              Print list of environment configurations
  list generators               Print list of code generators of a given context
  list layers                   Print list of available, referenced and compatible layers
  list packs                    Print list of used packs from the pack repository
  list toolchains               Print list of supported toolchains
  run                           Run code generator
  update-rte                    Create/update configuration files and validate solution

Options:
  -c, --context arg [...]       Input context names [<project-name>][.<build-type>][+<target-type>]
  -d, --debug                   Enable debug messages
  -D, --dry-run                 Enable dry-run
  -e, --export arg              Set suffix for exporting <context><suffix>.cprj retaining only specified versions
  -f, --filter arg              Filter words
  -g, --generator arg           Code generator identifier
  -l, --load arg                Set policy for packs loading [latest | all | required]
  -L, --clayer-path arg         Set search path for external clayers
  -m, --missing                 List only required packs that are missing in the pack repository
  -n, --no-check-schema         Skip schema check
  -N, --no-update-rte           Skip creation of RTE directory and files
  -O, --output arg              Add prefix to 'outdir' and 'tmpdir'
  -q, --quiet                   Run silently, printing only error messages
  -R, --relative-paths          Print paths relative to project or ${CMSIS_PACK_ROOT}
  -S, --context-set             Select the context names from cbuild-set.yml for generating the target application
  -t, --toolchain arg           Selection of the toolchain used in the project optionally with version
  -v, --verbose                 Enable verbose messages
  -V, --version                 Print version

Use 'csolution <command> -h' for more information about a command.
```

## `cpackget` Invocation

``` txt
Usage:
  cpackget [command] [flags]

Available Commands:
  add              Add Open-CMSIS-Pack packages
  checksum-create  Generates a .checksum file containing the digests of a pack
  checksum-verify  Verifies the integrity of a pack using its .checksum file
  completion       Generate the autocompletion script for the specified shell
  help             Help about any command
  init             Initializes a pack root folder
  list             List installed packs
  rm               Remove Open-CMSIS-Pack packages
  signature-create Digitally signs a pack with a X.509 certificate or PGP key
  signature-verify Verifies a signed pack
  update-index     Update the public index

Flags:
  -C, --concurrent-downloads uint   Number of concurrent batch downloads. Set to 0 to disable concurrency (default 5)
  -h, --help                        help for cpackget
  -R, --pack-root string            Specifies pack root folder. Defaults to CMSIS_PACK_ROOT environment variable
  -q, --quiet                       Run cpackget silently, printing only error messages
  -T, --timeout uint                Set maximum duration (in seconds) of a download. Disabled by default
  -v, --verbose                     Sets verboseness level: None (Errors + Info + Warnings), -v (all + Debugging). Specify "-q" for no messages
  -V, --version                     Prints the version number of cpackget and exit

Use "cpackget [command] --help" for more information about a command.
```

## Command Examples

### List Environment

Print the current settings of the host development environment which allows to verify the correctness of the tool installation.

```bash
cbuild list environment
```

### List Available Toolchains

Print the install toolchains which allows to identify the available compilers in the  host development environment. The option `--verbose` provides additional path information.

```bash
cbuild list toolchains -v
```

### Update Pack Index File

When new software packs are available in on a public web service, the local copy of the Pack Index File requires an update. To update the Pack Index File, run the command:

```bash
cpackget update-index
```

### Build Project

This command builds a project that is defined in the file `example.csolution.yml`:

```bash
cbuild example.csolution.yml
```

Options allow to rebuild and download missing software packs or to select specific context settings

```bash
cbuild example.csolution.yml --rebuild --packs --context .Release
```

For reproducible builds in CI environment, fix software pack versions as provided by the file `*.cbuild-pack.yml`. An error is reported if the file `*.cbuild-pack.yml` does not exist or packs are added/removed. Refer to [reproducible builds](build-overview.md#reproducible-builds) for more information.

```bash
cbuild example.csolution.yml --frozen-packs --packs --rebuild
```

It is also possible to overwrite the toolchain selection and use a different toolchain for translation:

```bash
cbuild example.csolution.yml --toolchain GCC
```

> **Note:**
>
> The `--toolchain` option is useful for:
>
> - Testing a new compiler or new compiler version on the overall project.
> - For unit test applications to allow the usage of different compilers.

In CI systems that run a matrix build it is sometimes required to add a prefix to the [output directory](YML-Input-Format.md#output-dirs) names for `outdir:`. The following command builds the project with the AC6 and GCC compiler and separates the directories for output and temporary files.

```bash
cbuild example.csolution.yml --toolchain AC6 --output outAC6
cbuild example.csolution.yml --toolchain GCC --output outGCC
```

### Update RTE Configuration Files

The [Component Configuration​](build-overview.md#project-structure) is stored in the [RTE directory](build-overview.md#rte-directory-structure). When files are missing or new software pack versions are installed it might be required to update the RTE configuration files with this command:

```bash
csolution example.csolution.yml --update-rte
```

### Add Software Packs

To install software packs from a public web service use the following command:

```bash
cpackget add Arm::CMSIS
cpackget add Arm::CMSIS@5.9.0     # optional with version specification
```

### List Installed Packs

Print list of installed packs. The list can be filtered by words provided with the option `--filter`:

```bash
csolution list packs [-f "<filter words>"]
```

Print list of packs that are required by the `example.csolution.yml`.

```bash
csolution list packs example.csolution.yml
```

### Install Missing Packs

Print list of missing packs to the file `packs.txt` that are required by the `example.csolution.yml` but not available
in the pack repository. This missing packs might be installed using [`cpackget`](#cpackget-invocation) tool.

```bash
csolution list packs example.csolution.yml -m >packs.txt
cpackget update-index               # optional to ensure that pack index is up-to-date
cpackget add -f packs.txt
```

### List Devices or Boards

Print list of available device or board names. The list can be filtered by words provided with the option `--filter`:

```bash
csolution list devices
csolution list boards --filter NXP
```

### List Unresolved Dependencies

Print list of unresolved project dependencies. Device, board, and software components are specified as part of the
`*.csolution.yml` and `*.cproject.yml` files. The list may be filtered by words provided with the option `--filter`:

```bash
csolution list dependencies mysolution.csolution.yml [-f "<filter words>"]
```

### Create Build Information

Convert `example.csolution.yml` into build information files.

```bash
csolution convert example.csolution.yml
```

Convert specific contexts of a `*.csolution.yml` file into build information files.

```bash
csolution convert SimpleTZ.csolution.yml -c CM33_s.Debug -c CM33_ns.Release+AVH
```

### List Compatible Layers

List compatible layers for `./fxls8962_normal_spi.csolution.yml` and the context `*+frdmk22f_agmp03`. This contains also setup information.

```bash
csolution list layers ./fxls8962_normal_spi.csolution.yml -c *+frdmk22f_agmp03
```

Refer to [Software Layers](build-overview.md#software-layers) for more information.

### Use Generators (i.e. CubeMX)

List external code generators that are used to create software components. It outputs the generator ID that is required for the `run` command. When using the option `--verbose` the generator out directory is listed.

```bash
csolution list generators mysolution.csolution.yml -v
```

Run a generator (in this case STM32 CubeMX) for a specific project context.  Note that the context can be omitted when the same generator output directory is used.

```bash
csolution run -g CubeMX mysolution.csolution.yml -c Blinky.Debug+STM32L4
```

### Use context set

When working with [multiple related projects](build-overview.md#project-setup-for-related-projects), it might be necessary to combine different build types for debug and download in the target hardware. With the option `--context-set` the selected `--context` options can be saved and re-used.

Write to the file `SimpleTZ.cbuild-set.yml` the selected `--context` options . Refer to [file structure of `*.cbuild-set.yml`](YML-CBuild-Format.md#file-structure-of-cbuild-setyml) for details.

```bash
cbuild SimpleTZ.csolution.yml -S -c CM33_s.Release -c CM33_ns.Debug
```

Read from the file `SimpleTZ.cbuild-set.yml` to previous stored `--context` setup.

```bash
cbuild SimpleTZ.csolution.yml -S
```

### List configuration files

List all configuration files that belong to software components and are stored in the [RTE directory](build-overview.md#rte-directory-structure). When [updating software packs](CreateApplications.md#update-software-packs), it shows also the update status of each file.

```bash
csolution list configs SimpleTZ.csolution.yml -S
```

### Setup Project (for IDE)

This command downloads missing packs, creates [build information files](YML-CBuild-Format.md), and generates the file `compile_commands.json` for IntelliSense in an IDE environment. Refer to [cbuild setup command](build-operation.md#details-of-the-setup-mode) for more information.

```bash
cbuild setup example.csolution.yml --context-set --packs
```

> **Note:**
>
> - `cbuild setup` always enables the option `--schema` to validate the correct YML syntax in the *csolution project* files.

## `cpackget` Details

### Specify CMSIS-Pack root directory

`cpackget` is compatible with other CMSIS-Pack management tools, such as the Pack Installer available in MDK or Eclipse
variants. There are two ways to specify the CMSIS-PACK root directory:

1. With the `CMSIS_PACK_ROOT` environment variable.
   Refer to [Installation - Environment Variables](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/installation.md#environment-variables).

2. with the option `--pack-root <path>`, for example:

   ```bash
   cpackget add Vendor.PackName --pack-root ./MyLocal/Packs
   ```

>**Note:**
>
> As the various tools of the CMSIS-Toolbox rely all on the CMSIS-Pack root directory, it is recommended to use        the `CMSIS_PACK_ROOT` environment variable.

### Initialize CMSIS-Pack root directory

CMSIS-Packs are typically distributed via a public web service, that offers a
[**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html)
of available software packs. To initialize the CMSIS-Pack root directory run the command:

```bash
cpackget init https://www.keil.com/pack/index.pidx
```

This command creates in the CMSIS-PACK root directory the following sub-directories.

Sub-Directory   | Content
:---------------|:------------------------
`.Web`          | [**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html) of a public web service and `*.PDSC` files.
`.Download`     | Packs that are installed from a web service. Stores `*.PDSC` pack description file, `*.pack` content file, and related license information.
`.Local`        | Index file `local_repository.pidx` that points to local installations for development of a software pack. Contains also the `*.PDSC` files from private software packs.

### Pack Index File

When new software packs are available in on a public web service, the local copy of the **Pack Index File** requires an update. To update the **Pack Index File**, run the command:

```bash
cpackget update-index
```

### Add packs

There are different ways to install software packs.

#### Install public packs

The commands below install software packs from a public web service. The available packs along with download URL and
version information are listed in the **Pack Index File**.

Check if a pack exists. If it does not exist install the latest version of a public software pack:

```bash
cpackget add Vendor.PackName                   # or 
cpackget add Vendor::PackName
```

Update an installed pack to the latest version of a public software pack:

```bash
cpackget add Vendor.PackName@latest           # or 
cpackget add Vendor::PackName@latest
```

Install a specific version of a public software pack:

```bash
cpackget add Vendor.PackName.x.y.z            # or 
cpackget add Vendor::PackName@x.y.z
cpackget add Vendor::PackName@>=x.y.z         # check if there is any version greater  or equal to x.y.z, install latest
```

Install latest version of a public software pack with the same major version or same major/minor version. Within the rules of semantic versioning only compatible packs are used.

```bash
cpackget add Vendor::PackName@^x.y.z         # check if there is any version greater or equal to x.y.z, but with same major version x
cpackget add Vendor::PackName@~x.y.z         # check if there is any version greater or equal to x.y.z, but with same major/minor version x.y
```

#### Install a list of software packs

Frequently a list of software packs should be installed that are used by a project. An ASCII file can specify a list of
packs, whereby line specifies a single pack, optionally with version information as shown above:

```bash
cpackget add -f list-of-packs.txt
```

Content of `list-of-packs.txt`:

```txt
ARM::CMSIS
ARM::CMSIS-Driver
ARM::CMSIS-FreeRTOS@10.4.6
ARM::mbedTLS@1.7.0
AWS::backoffAlgorithm@1.0.0-Beta
  :
```

#### Accept End User License Agreement (EULA) from command line

Some packs come with licenses and by default `cpackget` will prompt the user acceptance of this license agreement. For
automated installation of software packs, this user prompting can be suppressed with the command line flag `--agree-embedded-license`:

```bash
cpackget add -f list-of-packs.txt --agree-embedded-license
```

In some cases the user might want to only extract the license agreement of the software pack. This is supported with the
command line flag `--extract-embedded-license`:

```bash
cpackget add --extract-embedded-license Vendor.PackName
```

The extracted license file will be placed next to the pack's. For example if Vendor.PackName.x.y.z had a license file
named `LICENSE.txt`, cpackget would extract it to `.Download/Vendor.PackName.x.y.z.LICENSE.txt`.

#### Work behind a proxy

In some cases `cpackget` seems to be unable to download software packs, for example when used behind a corporate
firewall. Typically this is indicated by error messages such as:

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->

```txt
E: Get "<url>/<pack-name>.pack": dial tcp <ip-address>: connectex: No connection could be made because the target machine actively refused it.
E: failed to download file
```

<!-- markdownlint-restore -->

In such cases it might be required to access the internet via a proxy. This can be done via environment variables that
are used by `cpackget`:

```bash
# Windows
set HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
set HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests

# Unix
export HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
export HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests
```

Then **all** HTTP/HTTPS requests will be going through the specified proxy.

#### Install a private software pack

A software pack can be distributed via different methods, for example via file exchange systems.  

Once the software pack is available on the local computer, it can be installed by referring to the `*.pack` file
itself:

```bash
cpackget add <path>/Vendor.PackName.x.y.z.pack
```

A software pack that is available for downloaded via a URL can be downloaded and installed with:

```bash
cpackget add https://vendor.com/example/Vendor.PackName.x.y.z.pack
```

#### Install a repository

During development of a software pack it is possible to map the content of a local directory (that typically maps to
the repository of the software pack) as software pack.  In this case the `*.pdsc` file is specified as shown below:

```bash
cpackget add <local_path>/Vendor.PackName.pdsc
```

Example:

```bash
cpackget add /work/IoT_Socket/MDK-Packs.IoT_Socket.pdsc
```

### List all software packs

List of all installed packs that are available in the CMSIS-Pack root directory.

```bash
cpackget list
```

This will include all packs that are installed via `cpackget add` command, regardless of the source of the software
pack. There are also a couple of flags that allow listing extra information.

List all cached packs, that are present in the `.Download/` folder:

```bash
cpackget list --cached
```

List all packs present in the local copy of the **Pack Index File** (`index.pidx`):

```bash
cpackget list --public
```

>**Note:**
>
> [Update Pack Index File](#update-pack-index-file) before using the `list` command to list all public software packs.

### Remove packs

The commands below demonstrate how to remove packs. It is unimportant how the software pack has been added.

Remove software pack with a specific version:

```bash
cpackget rm Vendor.PackName.x.y.z      # or
cpackget rm Vendor::PackName@x.y.z
```

Remove all versions of software pack:

```bash
cpackget rm Vendor.PackName            # or
cpackget rm Vendor::PackName
```

Same as above, but also remove the cached files that relate to this pack in the `.Download/` directory.

```bash
cpackget rm --purge Vendor.PackName`
```

## DevOps Usage

The CMSIS-Toolbox supports Continuous Integration (CI) tests in DevOps systems. The `./out` directory contains all build artifacts of an application for execution on physical hardware or simulation models. [Arm Virtual Hardware - Fixed Virtual Platforms (AVH FVP)](https://github.com/ARM-software/AVH) enable unit tests and integration tests with simulation models and various virtual interfaces. Using layers allows a [Project Setup for Multiple Targets](build-overview.md#project-setup-for-multiple-targets-and-builds), for example to test on physical hardware or AVH-FVP simulation models. The following commands show typical usage of the CMSIS-Toolbox build system in CI environments.

The commands below show typical builds in a CI system. Using `--packs` installs all public packs with implicit acceptance of licenses. Without further option the command builds all projects, target-types, and build-types. Using [`--context`](build-overview.md#context) reduces the scope of the build. Using [`--frozen-packs`](build-overview.md#reproducible-builds) uses exactly the packs that are specified in the file `*.cbuild-pack.yml`.

```bash
cbuild Hello.csolution.yml --packs                          # install packs and build all
cbuild Hello.csolution.yml --packs --context +AVH-SSE-300   # only build target +AVH-SSE-300
cbuild Hello.csolution.yml --packs --frozen-packs           # use exact pack versions
```

Packs are that not public are installed using `cpackget`.  The following commands use the MDK-Middleware development repository to install a pre-release pack in a GitHub Actions CI workflow. The `cbuild` command above uses then the MDK-Middleware development repository instead of the public MDK-Middleware pack.

```yml
    - name: Checkout MDK-Middleware
      uses: actions/checkout@v4
      with:
        repository: ARM-software/MDK-Middleware
        path: ./MDK-Middleware

    - name: Initialize CMSIS pack system and use MDK-Middleware pack from development repo
      run: |
        cpackget init https://www.keil.com/pack/index.pidx
        cpackget update-index
        cpackget add ./MDK-Middleware/Keil.MDK-Middleware.pdsc        
```

### Examples

There are several examples that show CI workflows using the CMSIS-Toolbox.

Example            | Description
:------------------|:------------------
[csolution-examples](https://github.com/Open-CMSIS-Pack/csolution-examples) | Four different examples that execute CI tests with showing various concepts including matrix tests and AVH FVP simulation.
[AVH-Hello](https://github.com/Arm-Examples/AVH-Hello) | Build and execution test for "Hello World" example using a GitHub Action matrix to target all Cortex-M processors, Arm Compiler or GCC, and AVH simulation.
[AVH_CI_Template](https://github.com/Arm-Examples/AVH_CI_Template)     | CI Template for unit test automation that uses GitHub Actions.
[CMSIS Version 6](https://github.com/ARM-software/CMSIS_6/actions) | Runs a CMSIS-Core validation test across the supported processors using multiple compilers.
[RTOS2 Validation](https://github.com/ARM-software/CMSIS-RTX/actions) | Runs the CMSIS-RTOS2 validation across Keil RTX using source and library variants.
[STM32H743I-EVAL_BSP](https://github.com/Open-CMSIS-Pack/STM32H743I-EVAL_BSP) | Build test of a Board Support Pack (BSP) with MDK-Middleware [Reference Applications](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/ReferenceApplications.md) using Arm Compiler or GCC. The artifacts store the various example projects for testing on the hardware board.
[TFL Micro Speech](https://github.com/arm-software/AVH-TFLmicrospeech) | This example project shows the Virtual Streaming Interface with Audio input and uses [software layers](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/build-overview.md#software-layers) for retargeting.
