# cpackget: Pack Installer

## Table of Contents

- [cpackget: Pack Installer](#cpackget-pack-installer)
  - [Table of Contents](#table-of-contents)
  - [Usage Overview](#usage-overview)
  - [Specify CMSIS-Pack root directory](#specify-cmsis-pack-root-directory)
  - [Initialize CMSIS-Pack root directory](#initialize-cmsis-pack-root-directory)
  - [Update Pack Index File](#update-pack-index-file)
  - [Add packs](#add-packs)
    - [Install public packs](#install-public-packs)
    - [Install a list of software packs](#install-a-list-of-software-packs)
    - [Accept End User License Agreement (EULA) from command line](#accept-end-user-license-agreement-eula-from-command-line)
    - [Work behind a proxy](#work-behind-a-proxy)
    - [Install a private software pack](#install-a-private-software-pack)
    - [Install a repository](#install-a-repository)
  - [List software packs](#list-software-packs)
  - [Remove packs](#remove-packs)

## Usage Overview

This `cpackget` utility allows to install (or uninstall) software packs to the local development environment.

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->

```txt
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
  -R, --pack-root string            Specifies pack root folder. Defaults to CMSIS_PACK_ROOT environment variable (default "C:\\Users\\reikei01\\AppData\\Local\\Arm\\Packs")
  -q, --quiet                       Run cpackget silently, printing only error messages
  -T, --timeout uint                Set maximum duration (in seconds) of a download. Disabled by default
  -v, --verbose                     Sets verboseness level: None (Errors + Info + Warnings), -v (all + Debugging). Specify "-q" for no messages
  -V, --version                     Prints the version number of cpackget and exit

Use "cpackget [command] --help" for more information about a command.
```

<!-- markdownlint-restore -->

Usage help for a specific command available, with for example: `cpackget rm --help`.

## Specify CMSIS-Pack root directory

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

## Initialize CMSIS-Pack root directory

CMSIS-Packs are typically distributed via a public web service, that offers a
[**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html)
of available software packs. To initialize the CMSIS-Pack root directory run the command:

```bash
~ $ cpackget init https://www.keil.com/pack/index.pidx
```

This command creates in the CMSIS-PACK root directory the following sub-directories.

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->

Sub-Directory   | Content
:---------------|:------------------------
`.Web`          | [**Pack Index File**](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/packIndexFile.html) of a public web service and `*.PDSC` files.
`.Download`     | Packs that are installed from a web service. Stores `*.PDSC` pack description file, `*.pack` content file, and related license information.
`.Local`        | Index file `local_repository.pidx` that points to local installations for development of a software pack. Contains also the `*.PDSC` files from private software packs.

<!-- markdownlint-restore -->

## Update Pack Index File

When new software packs are available in on a public web service, the local copy of the **Pack Index File** requires an update. To update the **Pack Index File**, run the command:

```bash
~ $ cpackget update-index
```

## Add packs

There are different ways to install software packs.

### Install public packs

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

<!-- markdownlint-capture -->
<!-- markdownlint-disable MD013 -->

```bash
~ $ cpackget add Vendor::PackName>=x.y.z`         # check if there is any version greater than or equal to x.y.z, install latest
~ $ cpackget add Vendor::PackName@~x.y.z`         # check if there is any version greater than or equal to x.y.z 
```

<!-- markdownlint-restore -->

### Install a list of software packs

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

### Accept End User License Agreement (EULA) from command line

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

### Work behind a proxy

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

### Install a private software pack

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

### Install a repository

During development of a software pack it is possible to map the content of a local directory (that typically maps to
the repository of the software pack) as software pack.  In this case the `*.pdsc` file is specified as shown below:

```bash
~ $ cpackget add <local_path>/Vendor.PackName.pdsc
```

Example:

```bash
~ $ cpackget add /work/IoT_Socket/MDK-Packs.IoT_Socket.pdsc
```

## List software packs

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

## Remove packs

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
