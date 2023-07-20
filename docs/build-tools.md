# Build Tools

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

[**> CMSIS-Toolbox**](README.md) **> Build Tools**

This chapter describes the tools [`cbuild`](#cbuild-invocation) (build projects), [`csolution`](#csolution-invocation) (transform *user input files*), and [`cpackget`](#cpackget-invocation) (manage software packs). It includes command line syntax details and examples.

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
    - [Add Software Packs](#add-software-packs)
    - [List Installed Packs](#list-installed-packs)
    - [Install Missing Packs](#install-missing-packs)
    - [List Devices or Boards](#list-devices-or-boards)
    - [List Unresolved Dependencies](#list-unresolved-dependencies)
    - [Create Build Information](#create-build-information)
    - [Select a Toolchain](#select-a-toolchain)
    - [List Compatible Layers](#list-compatible-layers)
    - [Use Generators (i.e. CubeMX)](#use-generators-ie-cubemx)
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

## Requirements

The CMSIS-Pack repository must be present in the host development environment.

- There are several ways to initialize and configure the pack repository, for example using the
  tool `cpackget` that is part of the CMSIS-Toolbox.
- Before running the CMSIS-Toolbox tools the location of the pack repository shall be set via the environment variable
  `CMSIS_PACK_ROOT` otherwise its [default location](installation.md#environment-variables) will be taken.

## `cbuild` Invocation

```txt
cbuild: Build Invocation 2.0.0 (C) 2023 Arm Ltd. and Contributors

Usage:
  cbuild [command] <name>.csolution.yml [options]

Commands:
  buildcprj   Use a *.CPRJ file as build input
  help        Help about any command
  list        List information about environment, toolchains, and contexts

Options:
  -C, --clean              Remove intermediate and output directories
  -c, --context arg [...]  Input context names [<project-name>][.<build-type>][+<target-type>]
  -d, --debug              Enable debug messages
  -g, --generator arg      Select build system generator (default "Ninja")
  -h, --help               Print usage
  -j, --jobs int           Number of job slots for parallel execution
  -l, --load arg           Set policy for packs loading [latest | all | required]
      --log arg            Save output messages in a log file
  -O, --output arg         Set directory for all output files
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

## `csolution` Invocation

```text
csolution: Project Manager 2.0.0 (C) 2023 Arm Ltd. and Contributors

Usage:
  csolution <command> [<name>.csolution.yml] [options]

Commands:
  convert                  Convert user input *.yml files to *.cprj files
  list boards              Print list of available board names
  list contexts            Print list of contexts in a <name>.csolution.yml
  list components          Print list of available components
  list dependencies        Print list of unresolved project dependencies
  list devices             Print list of available device names
  list environment         Print list of environment configurations
  list generators          Print list of code generators of a given context
  list layers              Print list of available, referenced and compatible layers
  list packs               Print list of used packs from the pack repository
  list toolchains          Print list of supported toolchains
  run                      Run code generator
  update-rte               Create/update configuration files and validate solution

Options:
  -c, --context arg [...]  Input context names [<project-name>][.<build-type>][+<target-type>]
  -d, --debug              Enable debug messages
  -e, --export arg         Set suffix for exporting <context><suffix>.cprj retaining only specified versions
  -f, --filter arg         Filter words
  -g, --generator arg      Code generator identifier
  -l, --load arg           Set policy for packs loading [latest | all | required]
  -L, --clayer-path arg    Set search path for external clayers
  -m, --missing            List only required packs that are missing in the pack repository
  -n, --no-check-schema    Skip schema check
  -N, --no-update-rte      Skip creation of RTE directory and files
  -o, --output arg         Output directory
  -t, --toolchain arg      Selection of the toolchain used in the project optionally with version
  -v, --verbose            Enable verbose messages
  -V, --version            Print version

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

### Select a Toolchain

List and select a specific toolchain (in this case AC6 for Arm Compiler version 6) for the compilation of a project. The `--verbose` option provides additional details.

```bash
cbuild list toolchains -v
cbuild example.csolution.yml -t AC6
```

### List Compatible Layers

List compatible layers for `./fxls8962_normal_spi.csolution.yml` and the context `*+frdmk22f_agmp03`. This contains also setup information.

```bash
csolution list layers ./fxls8962_normal_spi.csolution.yml -c *+frdmk22f_agmp03
```

Refer to [Working with Layers](build-overview#working-with-layers) for more information.

### Use Generators (i.e. CubeMX)

List external code generators that are used to create software components in `*.gpdsc` format. It outputs the generator
ID that is required for the `run` command.

```bash
csolution list generators mysolution.csolution.yml
```

Run a generator (in this case STCubeMX) for a specific project context.

```bash
csolution run -g STCubeMX mysolution.csolution.yml -c Blinky.Debug+STM32L4
```

## `cpackget` Details

### Specify CMSIS-Pack root directory

`cpackget` is compatible with other CMSIS-Pack management tools, such as the Pack Installer available in MDK or Eclipse
variants. There are two ways to specify the CMSIS-PACK root directory:

1. With the `CMSIS_PACK_ROOT` environment variable.
   Refer to [Installation - Environment Variables](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/installation.md#environment-variables).

2. with the option `--pack-root <path>`, for example:

   ```bash
   ~ $ cpackget add Vendor.PackName --pack-root ./MyLocal/Packs
   ```

>NOTE: As the various tools of the CMSIS-Toolbox rely all on the CMSIS-Pack root directory, it is recommended to use
       the `CMSIS_PACK_ROOT` environment variable.

### Initialize CMSIS-Pack root directory

CMSIS-Packs are typically distributed via a public web service, that offers a
[**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html)
of available software packs. To initialize the CMSIS-Pack root directory run the command:

```bash
~ $ cpackget init https://www.keil.com/pack/index.pidx
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
~ $ cpackget update-index
```

### Add packs

There are different ways to install software packs.

#### Install public packs

The commands below install software packs from a public web service. The available packs along with download URL and
version information are listed in the **Pack Index File**.

Install the latest published version of a public software pack:

```bash
~ $ cpackget add Vendor.PackName                 # or 
~ $ cpackget add Vendor::PackName
```

Install a specific version of a public software pack:

```bash
~ $ cpackget add Vendor.PackName.x.y.z            # or 
~ $ cpackget add Vendor::PackName@x.y.z
```

Install a public software pack using version modifiers:

```bash
~ $ cpackget add Vendor::PackName>=x.y.z`         # check if there is any version greater than or equal to x.y.z, install latest
~ $ cpackget add Vendor::PackName@~x.y.z`         # check if there is any version greater than or equal to x.y.z 
```

#### Install a list of software packs

Frequently a list of software packs should be installed that are used by a project. An ASCII file can specify a list of
packs, whereby line specifies a single pack, optionally with version information as shown above:

```bash
~ $ cpackget add -f list-of-packs.txt
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
~ $ cpackget add -f list-of-packs.txt --agree-embedded-license
```

In some cases the user might want to only extract the license agreement of the software pack. This is supported with the
command line flag `--extract-embedded-license`:

```bash
~ $ cpackget add --extract-embedded-license Vendor.PackName
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
~ % set HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
~ % set HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests

# Unix
~ $ export HTTP_PROXY=http://my-proxy         # proxy used for HTTP requests
~ $ export HTTPS_PROXY=https://my-https-proxy # proxy used for HTTPS requests
```

Then **all** HTTP/HTTPS requests will be going through the specified proxy.

#### Install a private software pack

A software pack can be distributed via different methods, for example via file exchange systems.  

Once the software pack is available on the local computer, it can be installed by referring to the `*.pack` file
itself:

```bash
~ $ cpackget add <path>/Vendor.PackName.x.y.z.pack
```

A software pack that is available for downloaded via a URL can be downloaded and installed with:

```bash
~ $ cpackget add https://vendor.com/example/Vendor.PackName.x.y.z.pack
```

#### Install a repository

During development of a software pack it is possible to map the content of a local directory (that typically maps to
the repository of the software pack) as software pack.  In this case the `*.pdsc` file is specified as shown below:

```bash
~ $ cpackget add <local_path>/Vendor.PackName.pdsc
```

Example:

```bash
~ $ cpackget add /work/IoT_Socket/MDK-Packs.IoT_Socket.pdsc
```

### List all software packs

List of all installed packs that are available in the CMSIS-Pack root directory.

```bash
~ $ cpackget list
```

This will include all packs that are installed via `cpackget add` command, regardless of the source of the software
pack. There are also a couple of flags that allow listing extra information.

List all cached packs, that are present in the `.Download/` folder:

```bash
~ $ cpackget list --cached
```

List all packs present in the local copy of the **Pack Index File** (`index.pidx`):

```bash
~ $ cpackget list --public
```

>NOTE: [Update Pack Index File](#update-pack-index-file) before the `list` command to list all public software packs.

### Remove packs

The commands below demonstrate how to remove packs. It is unimportant how the software pack has been added.

Remove software pack with a specific version:

```bash
~ $ cpackget rm Vendor.PackName.x.y.z      # or
~ $ cpackget rm Vendor::PackName@x.y.z
```

Remove all versions of software pack:

```bash
~ $ cpackget rm Vendor.PackName            # or
~ $ cpackget rm Vendor::PackName
```

Same as above, but also remove the cached files that relate to this pack in the `.Download/` directory.

```bash
~ $ cpackget rm --purge Vendor.PackName`
```
