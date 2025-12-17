# Build Tools

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

This chapter describes the tools [`cbuild`](#cbuild-invocation) (build projects), [`csolution`](#csolution-invocation) (transform *csolution project files*), and [`cpackget`](#cpackget-invocation) (manage software packs). It includes details on command line syntax and examples.

## Requirements

Install the CMSIS-Toolbox as described in chapter [Installation](installation.md).

The CMSIS-Pack repository must be present in the host development environment.

There are several ways to configure the CMSIS-Pack repository:

- Use the **`cpackget` Package Installer** command `init` to [initialize the CMSIS-Pack root directory](#initialize-cmsis-pack-root-directory), [update the pack index file](#update-pack-index). Then [add software packs](build-tools.md#add-packs).

- Share an existing CMSIS-Pack repository (i.e. from an IDE) via the environment variable `CMSIS_PACK_ROOT`.

## `cbuild` Invocation

Orchestrate the overall build steps utilizing the various tools of the CMSIS-Toolbox and a CMake-based compilation process.

```txt
cbuild: Build Invocation 2.12.0 (C) 2022-2025 Arm Ltd. and Contributors

Usage:
  cbuild [command] <name>.csolution.yml [options]

Commands:
  help        Help about any command
  list        List information about contexts, environment, target-sets and toolchains
  setup       Generate project data for IDE environment

Options:
  -a, --active arg         Select active target-set: <target-type>[@<set>]
      --cbuildgen          Generate legacy *.cprj files and use cbuildgen backend
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
  -n, --no-schema-check    Skip schema check
  -O, --output arg         Base folder for output files, 'outdir' and 'tmpdir' (default "Same as '*.csolution.yml'")
  -p, --packs              Download missing software packs with cpackget
  -j, --jobs int           Number of job slots for parallel execution (default 8)
  -l, --load arg           Set policy for packs loading [latest | all | required] (default "required")
      --log arg            Save output messages in a log file
  -n, --no-schema-check    Skip schema check
  -O, --output arg         Base folder for output files, 'outdir' and 'tmpdir' (default "Same as '*.csolution.yml'")
  -p, --packs              Download missing software packs with cpackget
  -q, --quiet              Suppress output messages except build invocations
  -r, --rebuild            Remove intermediate and output directories and rebuild
  -s, --schema             Validate project input file(s) against schema [deprecated]
      --skip-convert       Skip csolution convert step
  -t, --target arg         Optional CMake target name
      --toolchain arg      Input toolchain to be used
      --update-rte         Update the RTE directory and files
  -v, --verbose            Enable verbose messages from toolchain builds
  -V, --version            Print version

Use "cbuild [command] --help" for more information about a command.
```

!!! Note
    By default, the `cbuild` invocation does not update the [**RTE Directory**](build-overview.md#rte-directory-structure). If required, use the option `--update-rte`.

## `csolution` Invocation

Create build information for embedded applications that consist of one or more related projects.

```text
csolution: Project Manager 2.9.0 (C) 2022-2025 Arm Ltd. and Contributors

Usage:
  csolution <command> [<name>.csolution.yml] [options]

Commands:
  convert                       Convert user input *.yml files to *.cprj files
  list boards                   Print list of available board names
  list configs                  Print list of configuration files
  list contexts                 Print list of contexts in a <name>.csolution.yml
  list components               Print list of available components
  list debuggers                Print list of debuggers from debug-adapters.yml
  list dependencies             Print list of unresolved project dependencies
  list devices                  Print list of available device names
  list environment              Print list of environment configurations
  list examples                 Print list of examples
  list templates                Print list of templates
  list generators               Print list of code generators of a given context
  list layers                   Print list of available, referenced and compatible layers
  list packs                    Print list of used packs from the pack repository
  list target-sets              Print list of target-sets in a <name>.csolution.yml
  list toolchains               Print list of supported toolchains
  run                           Run code generator
  rpc                           Run remote procedure call server
  update-rte                    Create/update configuration files and validate solution

Options:
  -a, --active arg              Select active target-set: <target-type>[@<set>]
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
  -o,-O --output arg            Base folder for output files, 'outdir' and 'tmpdir' (default "Same as '*.csolution.yml'")
  -q, --quiet                   Run silently, printing only error messages
  -S, --context-set             Select the context names from cbuild-set.yml for generating the target application
  -t, --toolchain arg           Selection of the toolchain used in the project optionally with version
  -v, --verbose                 Enable verbose messages
  -V, --version                 Print version

Use 'csolution <command> -h' for more information about a command.
```

## `cpackget` Invocation

Manage the installation of *software packs* on the host computer.

``` txt
cpackget version 2.1.9
 (C) 2021-2023 Linaro, 2024-2025 Arm Ltd.

Usage:
  cpackget [command] [flags]

Available Commands:
  add              Add Open-CMSIS-Pack packages
  checksum-create  Generates a .checksum file containing the digests of a pack
  checksum-verify  Verifies the integrity of a pack using its .checksum file
  completion       Generate the autocompletion script for the specified shell
  connection       Check online connection to default or given URL
  help             Help about any command
  init             Initializes a pack root folder
  list             List installed packs
  rm               Remove Open-CMSIS-Pack packages
  signature-create Digitally signs a pack with a X.509 certificate or PGP key
  signature-verify Verifies a signed pack
  update           Update Open-CMSIS-Pack packages to latest
  update-index     Update the public index

Flags:
  -C, --concurrent-downloads uint   Number of concurrent batch downloads. Set to 0 to disable concurrency (default 20)
  -h, --help                        help for cpackget
  -R, --pack-root string            Specifies pack root folder. Defaults to CMSIS_PACK_ROOT environment variable.
  -q, --quiet                       Run cpackget silently, printing only error messages
  -T, --timeout uint                Set maximum duration (in seconds) of a download. Disabled by default
  -v, --verbose                     Sets verboseness level: None (Errors + Info + Warnings), -v (all + Debugging). Specify "-q" for no messages
  -V, --version                     Prints the version number of cpackget and exit

Use "cpackget [command] --help" for more information about a command and command-specific flags.
```

## Command Examples

### List Environment

Print the settings of the host development environment to verify the correctness of the tool installation.

```shell
cbuild list environment
```

### List Available Toolchains

Print the installed toolchains in the  host development environment to identify the available compilers. The option `--verbose` provides additional path information.

```shell
cbuild list toolchains -v
```

### Build a Project

This command builds a project that is defined in the file `example.csolution.yml`:

```shell
cbuild example.csolution.yml
```

A *csolution project* that defines a [debugger](build-overview.md#run-and-debug-configuration) using `target-set:` should be build using the option `--active` that selects the target-type.

```shell
cbuild example.csolution.yml --active MyBoard
```

Options allow to rebuild and download missing software packs or to select specific context settings:

```shell
cbuild example.csolution.yml --rebuild --packs --context .Release
```

For reproducible builds in CI environments, fixed software pack versions are provided by the file `*.cbuild-pack.yml`. An error is reported if the file `*.cbuild-pack.yml` does not exist or packs are added/removed. Refer to [reproducible builds](build-overview.md#reproducible-builds) for more information.

```shell
cbuild example.csolution.yml --frozen-packs --packs --rebuild
```

It is also possible to overwrite the toolchain selection and use a different toolchain for translation:

```shell
cbuild example.csolution.yml --toolchain GCC
```

The `--toolchain` option is useful for:

- Test a new compiler or a different compiler version for the overall project.
- For unit test applications to allow the usage of different compilers.

In [DevOps systems](#devops-usage) that run CI test with a matrix build, it is sometimes required to separate the output of various builds. The option `--output` adds a prefix to the [output directory](YML-Input-Format.md#output-dirs) for `outdir:`, `tmpdir:` and build information files. The following commands build the project with the AC6 and GCC compiler and separate the directories for output and temporary files.

```shell
cbuild example.csolution.yml --toolchain AC6 --output outAC6
cbuild example.csolution.yml --toolchain GCC --output outGCC
```

!!! Note
    The `--output` option may be used by an IDE environment to location build information files outside of the user space.

### Update RTE Configuration Files

The [Component Configuration​](build-overview.md#directory-structure) is stored in the [RTE directory](build-overview.md#rte-directory-structure). When files are missing or new software pack versions are installed, it might be required to update the RTE configuration files:

```shell
csolution update-rte example.csolution.yml
```

### Add Software Packs

To install software packs from a public web service, run:

```shell
cpackget add Arm::CMSIS
cpackget add Arm::CMSIS@6.1.0     # optional with version specification
```

### List Installed Packs

Print a list of installed packs. The list can be filtered by words provided with the option `--filter`:

```shell
csolution list packs [-f "<filter words>"]
```

Print a list of packs that are required by the `example.csolution.yml`.

```shell
csolution list packs example.csolution.yml
```

### Install Missing Packs

Print a list of missing packs required by the `example.csolution.yml` but not available
in the pack repository to the file `packs.txt`. These missing packs can then be installed using the [`cpackget`](#cpackget-invocation) tool.

```shell
csolution list packs example.csolution.yml -m >packs.txt
cpackget update-index               # optional to ensure that pack index is up-to-date
cpackget add -f packs.txt
```

### List Devices or Boards

Print a list of available device or board names. The list can be filtered by words provided with the option `--filter`:

```shell
csolution list devices
csolution list boards --filter NXP
```

### List Unresolved Dependencies

Device, board, and software components are specified as part of the `*.csolution.yml` and `*.cproject.yml` files. Print a list of unresolved project dependencies. The list may be filtered by words provided with the option `--filter`:

```shell
csolution list dependencies mysolution.csolution.yml [-f "<filter words>"]
```

### Create Build Information

Convert `example.csolution.yml` into build information files.

```shell
csolution convert example.csolution.yml
```

Convert specific contexts of a `*.csolution.yml` file into build information files.

```shell
csolution convert SimpleTZ.csolution.yml -c CM33_s.Debug -c CM33_ns.Release+AVH
```

### List Compatible Layers

List compatible layers for `./fxls8962_normal_spi.csolution.yml` and the context `*+frdmk22f_agmp03`. This contains also setup information.

```shell
csolution list layers ./fxls8962_normal_spi.csolution.yml -c *+frdmk22f_agmp03
```

Refer to [Software Layers](build-overview.md#software-layers) for more information.

### Use Generators

List external code generators that are used to create software components. It outputs the generator ID that is required for the `run` command. When using the option `--verbose`, the generator out directory is listed.

```shell
csolution list generators mysolution.csolution.yml -v
```

Run a generator (in this case, STM32CubeMX) for a specific project context.  Note that the context can be omitted when the same generator output directory is used.

```shell
csolution run -g CubeMX mysolution.csolution.yml -c Blinky.Debug+STM32L4
```

### Use context set

When working with [multiple related projects](build-overview.md#configure-related-projects), it might be necessary to combine different build types for debugging and downloading in the target hardware. The option `--context-set` allows you to save and reuse the selected `--context` options.

Write the selected `--context` options to the file `SimpleTZ.cbuild-set.yml`. Refer to [file structure of `*.cbuild-set.yml`](YML-CBuild-Format.md#cbuild-setyml) for details.

```shell
cbuild SimpleTZ.csolution.yml -S -c CM33_s.Release -c CM33_ns.Debug
```

Read the previously stored `--context` setup from the file `SimpleTZ.cbuild-set.yml`.

```shell
cbuild SimpleTZ.csolution.yml -S
```

### List configuration files

List all configuration files that belong to software components and are stored in the [RTE directory](build-overview.md#rte-directory-structure). When [updating software packs](CreateApplications.md#update-software-packs), it also shows the update status of each file.

```shell
csolution list configs SimpleTZ.csolution.yml -S
```

### Setup Project (for IDE)

In an IDE environment, this command downloads missing packs creates [build information files](YML-CBuild-Format.md), and generates the file `compile_commands.json` for IntelliSense. Refer to [cbuild setup command](build-operation.md#details-of-the-setup-mode) for more information.

```shell
cbuild setup example.csolution.yml --context-set --packs
```

### Specify CMSIS-Pack root directory

`cpackget` is compatible with other CMSIS-Pack management tools, such as the Pack Installer, available in MDK or Eclipse
variants. There are two ways to specify the CMSIS-PACK root directory:

1. With the `CMSIS_PACK_ROOT` environment variable.
   Refer to [Installation - Environment Variables](installation.md#environment-variables).

2. With the option `--pack-root <path>`, for example:

```shell
cpackget add Vendor.PackName --pack-root ./MyLocal/Packs
```

!!! Note
    As the various tools of the CMSIS-Toolbox all rely on the CMSIS-Pack root directory, it is recommended to use the `CMSIS_PACK_ROOT` environment variable.

### Initialize CMSIS-Pack root directory

CMSIS-Packs are typically distributed via a public web service that offers a
[**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html)
of available software packs. To initialize the CMSIS-Pack root directory, run the command:

```shell
cpackget init https://www.keil.com/pack/index.pidx
```

This command creates in the CMSIS-PACK root directory the following sub-directories.

Sub-Directory   | Content
:---------------|:------------------------
`.Web`          | [**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html) of a public web service and `*.PDSC` files.
`.Download`     | Packs that are installed from a web service. Stores `*.PDSC` pack description file, `*.pack` content file, and related license information.
`.Local`        | Index file `local_repository.pidx` that points to local installations for the development of a software pack. Contains also the `*.PDSC` files from private software packs.

The `cpackget init` command [initializes the CMSIS-Pack root directory](#initialize-cmsis-pack-root-directory) but does not download PDSC files. Combined with the option `--all-pdsc-files` it also downloads all PDSC files that are available in the public index.

```shell
cpackget init https://www.keil.com/pack/indexpidx --all-pdsc-files
```

### Update Pack Index

When new software packs are available on a public web service, the local copy of the **Pack Index File** requires an update. To update the **Pack Index File**, run:

```shell
cpackget update-index
```

The option `--sparse` avoids updating the PDSC files and improves, therefore, the speed.

```shell
cpackget update-index --sparse
```

Use the option `--all-pdsc-files` to download all PDSC files available in the public index.

```shell
cpackget update-index --all-pdsc-files
```

### Add packs

There are different ways to install software packs.

#### Install public packs

The commands below install software packs from a public web service. The available packs along with download URL and version information are listed in the **Pack Index File**.

Check if a pack is installed. If not, install the latest version of a public software pack:

```shell
cpackget add Vendor.PackName                   # or
cpackget add Vendor::PackName
```

Update an installed pack to the latest version of a public software pack:

```shell
cpackget add Vendor.PackName@latest           # or
cpackget add Vendor::PackName@latest
```

Install a specific version of a public software pack:

```shell
cpackget add Vendor.PackName.x.y.z            # or
cpackget add Vendor::PackName@x.y.z
cpackget add Vendor::PackName@>=x.y.z         # check if there is any version greater  or equal to x.y.z, install latest
```

Install latest version of a public software pack with the same major version or same major/minor version. Within the rules of semantic versioning only compatible packs are used.

```shell
cpackget add Vendor::PackName@^x.y.z         # check if there is any version greater or equal to x.y.z, but with same major version x
cpackget add Vendor::PackName@~x.y.z         # check if there is any version greater or equal to x.y.z, but with same major/minor version x.y
```

#### Install a list of software packs

Frequently, a list of software packs should be installed that are used by a project. A text file can specify a list of packs, whereby each line specifies a single pack, optionally with version information as shown above:

```shell
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

#### Accept End User License Agreement (EULA) from the command line

Some packs come with licenses. By default, `cpackget` will prompt the user's acceptance of this license agreement. For
automated installation of software packs, this user prompting can be suppressed with the command line flag `--agree-embedded-license`:

```shell
cpackget add -f list-of-packs.txt --agree-embedded-license
```

In some cases, the user might want to only extract the license agreement of the software pack. This is supported by the
command line flag `--extract-embedded-license`:

```shell
cpackget add --extract-embedded-license Vendor.PackName
```

The extracted license file will be placed next to the pack. For example, if Vendor.PackName.x.y.z had a license file named `LICENSE.txt`, cpackget would extract it to `.Download/Vendor.PackName.x.y.z.LICENSE.txt`.

#### Work behind a proxy

Sometimes, `cpackget` seems to be unable to download software packs, for example, when used behind a corporate firewall. Typically this is indicated by error messages such as:

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->

```txt
E: Get "<url>/<pack-name>.pack": dial tcp <ip-address>: connectex: No connection could be made because the target machine actively refused it.
E: failed to download the file
```

<!-- markdownlint-restore -->

In such cases, accessing the Internet via a proxy might be required. This can be done via environment variables that are used by `cpackget`:

```shell
# Windows
set HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
set HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests

# Unix
export HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
export HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests
```

Then **all** HTTP/HTTPS requests will be going through the specified proxy.

#### Install a private software pack

A software pack can be distributed via different methods, such as file exchange systems.

Once the software pack is available on the local computer, it can be installed by referring to the `*.pack` file
itself:

```shell
cpackget add <path>/Vendor.PackName.x.y.z.pack
```

A software pack that is available for download via a URL can be downloaded and installed with:

```shell
cpackget add https://vendor.com/example/Vendor.PackName.x.y.z.pack
```

#### Install a repository

During the development of a software pack, it is possible to mark the content of a local directory (that typically reflects the repository of the software pack) as a software pack.  In this case, the `*.pdsc` file is specified as shown below:

```shell
cpackget add <local_path>/Vendor.PackName.pdsc
```

Example:

```shell
cpackget add /work/IoT_Socket/MDK-Packs.IoT_Socket.pdsc
```

### List all software packs

List of all installed packs that are available in the CMSIS-Pack root directory.

```shell
cpackget list
```

This will include all packs that are installed via `cpackget add` command, regardless of the source of the software
pack. There are also a couple of flags that allow listing extra information.

List all cached packs that are present in the `.Download/` folder:

```shell
cpackget list --cached
```

List all packs present in the local copy of the **Pack Index File** (`index.pidx`):

```shell
cpackget list --public
```

!!! Note
    [Update Pack Index File](#update-pack-index) before using the `list` command to list all public software packs.

### Remove packs

The commands below demonstrate how to remove packs. This is independent of how the software pack was added.

Remove a software pack with a specific version:

```shell
cpackget rm Vendor.PackName.x.y.z      # or
cpackget rm Vendor::PackName@x.y.z
```

Remove all versions of a software pack:

```shell
cpackget rm Vendor.PackName            # or
cpackget rm Vendor::PackName
```

The procedure is the same as above, but you should also remove the cached files related to this pack from the `.Download/` directory.

```shell
cpackget rm --purge Vendor.PackName`
```

Remove a pack that was [installed via a repository](#install-a-repository).

```shell
cpackget rm Vendor.PackName.pdsc
```

## DevOps Usage

The CMSIS-Toolbox supports Continuous Integration (CI) tests in DevOps systems. The `./out` directory contains all build artifacts of an application for execution on physical hardware or simulation models. [Arm Virtual Hardware - Fixed Virtual Platforms (AVH FVP)](https://github.com/ARM-software/AVH) enables unit tests and integration tests with simulation models and various virtual interfaces. Using [software layers](build-overview.md#software-layers) allows, for example, to test on physical hardware or AVH-FVP simulation models. The following commands show typical usage of the CMSIS-Toolbox build system in CI environments.

The commands below show typical builds in a CI system. Using `--packs` installs all public packs with implicit acceptance of licenses. This command builds all projects, target-types, and build-types. Using [`--context`](build-overview.md#context) reduces the scope of the build. Using [`--frozen-packs`](build-overview.md#reproducible-builds) uses exactly the packs that are specified in the file `*.cbuild-pack.yml`.

```shell
cbuild Hello.csolution.yml --packs                          # install packs and build all
cbuild Hello.csolution.yml --packs --context +AVH-SSE-300   # only build target +AVH-SSE-300
cbuild Hello.csolution.yml --packs --frozen-packs           # use exact pack versions
```

Packs that are not public are installed using `cpackget`.  The following commands use the MDK-Middleware development repository to install a pre-release pack in a GitHub Actions CI workflow.

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

Several examples show CI workflows using the CMSIS-Toolbox.

Example            | Description
:------------------|:------------------
[csolution-examples](https://github.com/Open-CMSIS-Pack/csolution-examples) | Four different examples that execute CI tests showing various concepts, including matrix tests and AVH FVP simulation.
[AVH-Hello](https://github.com/Arm-Examples/AVH-Hello) | Build and execution test for "Hello World" example using a GitHub Action matrix to target all Cortex-M processors, Arm Compiler or GCC, and AVH simulation.
[AVH_CI_Template](https://github.com/Arm-Examples/AVH_CI_Template)     | CI Template for unit test automation that uses GitHub Actions.
[CMSIS Version 6](https://github.com/ARM-software/CMSIS_6/actions) | Runs a CMSIS-Core validation test across the supported processors using multiple compilers.
[RTOS2 Validation](https://github.com/ARM-software/CMSIS-RTX/actions) | Runs the CMSIS-RTOS2 validation across Keil RTX using source and library variants.
[STM32H743I-EVAL_BSP](https://github.com/Open-CMSIS-Pack/STM32H743I-EVAL_BSP) | Build test of a Board Support Pack (BSP) with MDK-Middleware [Reference Applications](ReferenceApplications.md) using Arm Compiler or GCC. The artifacts store the various example projects for testing on the hardware board.
[TFL Micro Speech](https://github.com/arm-software/AVH-TFLmicrospeech) | This example project shows the Virtual Streaming Interface with Audio input and uses [software layers](build-overview.md#software-layers) for retargeting.

## IDE Usage

An IDE may use the following `cbuild setup` command to set up the project outline view and get information about components and software layers.

```shell
cbuild setup example.csolution.yml --context-set [--packs] [--update-rte]
```

The command above is used when the IDE starts:

- The option `--context-set` uses one `target-type` and optionally multiple related projects that are selected by a user in the file `*.cbuild-set.yml`. If this file is missing, it is created with the first `target-type` and the first `build-type` which are defined in the `*.csolution.yml` file.
- The option `--packs` can enable the download of missing software packs that are public.
- The option `--update-rte` is used when the IDE changes `device:`, `board:` or `component:` settings.

The `cbuild setup` command creates [build information files](YML-CBuild-Format.md) and generates the file `compile_commands.json` for IntelliSense in an VS Code IDE environment. Refer to [cbuild setup command](build-operation.md#details-of-the-setup-mode) for more information.

### Project Outline View

The project outline view in an IDE may utilize the project files as described below:

- The file `*.csolution.yml` contains the overall structure of projects, `build-types`, and `target-types`.
- The file `*cbuild-set.yml` specifies the selected contexts; if it does not exist, the IDE may select the first project, first `build-type`, and first `target-type` from the file `*.csolution.yml`.
- The file `*.cproject.yml` provides the source groups, source files, and the list of components (but without source files).
- The files `*.clayer.yml` or `*.cgen.yml` contain software layers with additional source groups, source files, and components. The `*.cbuild.<context>.yml` files provide the exact location of these files, for example, when variables are used.

Using the above information, it is possible to create an outline view, but without the file list for components. For software layers, the content may require the `*.cbuild.<context>.yml` files that are generated with the `cbuild setup` command.

The `cbuild-idx.yml` file provides the exact location of all `*.cbuild.<context>.yml` files that are used in this context-set. The `*.cbuild.<context>.yml` files contain for the components source files, configuration file information, API header files, user code templates, generator information, and links to documentation. The project outline view may provide access to this information.

### Build Process

An IDE may use the following `cbuild` command to build the overall application.

```shell
cbuild example.csolution.yml --context-set [--packs] [--quite] [--rebuild]
```

- The option `--context-set` selects the projects along with `target-type` and `build-type` for the application.
- The option `--packs` can be enable the download missing software packs that are public.
- The option `--quite` suppresses details about the build process.
- The option `--rebuild` may be used to force a complete rebuild of the output files.
