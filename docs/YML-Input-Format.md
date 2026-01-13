# CSolution Project Format

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

The following chapter explains the CMSIS Solution Project File Format (short form *csolution project files*), the YAML files that describe the software of an embedded application.

## Name Conventions

### Filename Extensions

The **`csolution` Project Manager** recognizes the [categories](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#FileCategoryEnum) of [files](#files) based on the filename extension in the YAML input files as shown in the table below.

File Extension           | [Category](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#FileCategoryEnum) | Description
:--------------------------------------------|:-------------|:---------------------
`.c`, `.C`                                   | sourceC      | C source file
`.cpp`, `.c++`, `.C++`, `.cxx`, `.cc`, `.CC` | sourceCpp    | C++ source file
`.h`,`.hpp`                                  | header       | Header file
`.asm`, `.s`, `.S`                           | sourceAsm    | Assembly source file
`.ld`, `.scf`, `.sct`, `.icf`                | linkerScript | Linker Script file
`.a`, `.lib`                                 | library      | Library file
`.o`                                         | object       | Object file
`.txt`, `.md`, `.pdf`, `.htm`, `.html`       | doc          | Documentation
`.scvd`                                      | other        | [Software Component View Description](https://arm-software.github.io/CMSIS-View/latest/SCVD_Format.html) for CMSIS-View

### `pack:` Name Conventions

The **`csolution` Project Manager** uses the following syntax to specify the `pack:` names in the `*.yml` files.

```yml
vendor::pack-name                # Use the latest version of the pack
vendor::pack-name@version        # With exact version
vendor::pack-name@>=version      # With version equal or higher
vendor::pack-name@^version       # With version equal or higher but the same major version
vendor::pack-name@~version       # With version equal or higher but the same major and minor version
```

Element      |              | Description
:------------|--------------|:---------------------
`vendor`     | **Required** | Vendor name of the software pack.
`pack-name`  | **Required** | Name of the software pack; wildcards (\*, ?) can be used.
`@version`   | Optional     | Software pack version number must exactly match, i.e. `@1.2.3`
`@>=version` | Optional     | Automatically update to any version higher or equal.
`@^version`  | Optional     | Automatically update minor/patch version, i.e. `@^1.2.3` uses releases from `1.2.3` to `< 2.0.0`.
`@~version`  | Optional     | Automatically update patch version, i.e. `@^1.2.3` uses releases from `1.2.3` to `< 1.3.0`.

!!!Notes
    - When no version is specified, the **`csolution` Project Manager** only loads the latest installed version of a software pack. This also applies when wildcards are used in the `pack-name`.
    - Use [**`cpackget`**](build-tools.md#cpackget-invocation) to download and install new pack versions.
    - To accept a [pre-release version of a pack](pack-tools.md#versioning) specify the `-pre-release` label. Use for example `- pack: Keil::MDK-Middleware@^8.0.0-0` to accept any pre-release version that is higher or equal.

**Examples:**

```yml
- pack:   ARM::CMSIS@5.9.0                 # 'CMSIS' Pack with version 5.5.0
- pack:   Keil::MDK-Middleware@>=7.13.0    # latest version 7.13.0 or higher
- pack:   Keil::MDK-Middleware@^7.13.0     # latest version 7.13.0 or higher, but lower than 8.0.0
- pack:   Keil::TFM                        # 'TFM' Pack from vendor Keil, latest installed version
- pack:   AWS                              # All Software Packs from vendor 'AWS', latest version
- pack:   Keil::STM*                       # Software Packs that start with 'STM' from vendor 'Keil'
- pack:   Keil::MDK-Middleware@>=8.0.0-0   # version 8.0.0 or higher including pre-release versions
```

### `component:` Name Conventions

The **`csolution` Project Manager** uses the following syntax to specify the `component:` names in the `*.yml` files.

```yml
[Cvendor::] Cclass [&Cbundle] :Cgroup [:Csub] [&Cvariant] [@[>=]Cversion]
```

Components are defined using the [Open-CMSIS-Pack - `<component>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#element_component). Several parts of a `component` are optional.  For example, it is possible to just define a component using the `Cclass` and `Cgroup` names. All elements of a component name are summarized in the following table.

Element    |              | Description
:----------|--------------|:---------------------
`Cvendor`  | Optional     | Name of the component vendor as defined in `<components>` element or by the package vendor of the software pack.
`Cclass`   | **Required** | Component class name as defined in `<components>` element of the software pack.
`Cbundle`  | Optional     | Bundle name of the component class as defined in `<bundle>` element of the software pack.
`Cgroup`   | **Required** | Component group name as defined in `<components>` element of the software pack.
`Csub`     | Optional     | Component sub-group name as defined in `<components>` element of the software pack.
`Cvariant` | Optional     | Component sub-group name as defined in `<components>` element of the software pack.
`Cversion` | Optional     | Version number of the component, with `@1.2.3` that must exactly match, or `@>=1.2.3` that allows any version higher or equal.

**Partly defined components**

A component can be partly defined in *csolution project files* (`*.cproject.yml`, `*.clayer.yml`, `*.genlayer.yml`) by omitting `Cvendor`, `Cvariant`, and `Cversion`, even when this are part of the `components` element of the software pack. The component select algorithm resolves this to a fully defined component by:

- when a partly specified component resolves to several possible choices, the tool selects:
    - (a) the default `Cvariant` of the component as defined in the PDSC file.
    - (b) the component with the higher `Cversion` value.
    - (c) an error message is issued when two identical components are defined by multiple vendors and `Cvendor` is not specified.
- the partly specified component is extended by:
    - version information from the software pack.
    - default variant definition from the software pack.

The fully resolved component name is shown in the [`*.cbuild.yml`](YML-CBuild-Format.md) output file.

!!! Note
    Before CMSIS-Toolbox 2.7, a component that omitted `Csub` resolved to the first matching component. Installing additional software packs could change therefore component selection. When a component is defined with `Csub` it is now required to specify.

**Multiple component definitions are rejected**

- If a component is added more than once in the *csolution project files* and an *error* is issued.
- An attempt to select multiple variants (using `Cvariant`) of a component results in an *error*.

**Examples:**

```yml
- component: CMSIS:CORE                               # CMSIS Core component (vendor selected by `csolution` ARM)
- component: ARM::CMSIS:CORE                          # CMSIS Core component from vendor ARM (any version)
- component: ARM::CMSIS:CORE@5.5.0                    # CMSIS Core component from vendor ARM (with version 5.5.0)
- component: ARM::CMSIS:CORE@>=5.5.0                  # CMSIS Core component from vendor ARM (with version 5.5.0 or higher)

- component: Device:Startup                           # Device Startup component from any vendor

- component: CMSIS:RTOS2:Keil RTX5                    # CMSIS RTOS2 Keil RTX5 component with default variant (any version)
- component: ARM::CMSIS:RTOS2:Keil RTX5&Source@5.5.3  # CMSIS RTOS2 Keil RTX5 component with variant 'Source' and version 5.5.3

- component: Keil::USB&MDK-Pro:CORE&Release@6.15.1    # USB CORE component from bundle MDK-Pro in variant 'Release' and version 6.15.1
```

### `device:` Name Conventions

The device specifies multiple attributes about the target that range from the processor architecture to Flash
algorithms used for device programming. The following syntax is used to specify a `device:` value in the `*.yml` files.

```yml
[ [ Dvendor:: ] Dname] [:Pname]
```

Element       |          | Description
:-------------|----------|:---------------------
`Dvendor`     | Optional | Name (without enum field) of the device vendor-defined in `<devices><family>` element of the software pack.
`Dname`       | Optional | Device name (Dname attribute) or, when used, the variant name (Dvariant attribute) as defined in the \<devices\> element.
`Pname`       | Optional | Processor identifier (Pname attribute) as defined in the `<devices>` element.

!!! Note
    - All elements of a device name are optional, which allows to supply of additional information, such as the `:Pname` at
      different stages of the project. However, the `Dname` itself is a mandatory element and must be specified in
      the context of the various project files.
    - `Dvendor::` must be used in combination with the `Dname`.

**Examples:**

```yml
device: NXP::LPC1768                       # The LPC1788 device from NXP
device: LPC1788                            # The LPC1788 device (vendor is evaluated from DFP)
device: LPC55S69JEV98                      # Device name (exact name as defined in the DFP)
device: LPC55S69JEV98:cm33_core0           # Device name (exact name as defined in the DFP) with Pname specified
device: :cm33_core0                        # Pname added to a previously defined device name (or a device derived from a board)
```

### `board:` Name Conventions

Evaluation Boards define a device indirectly via the related BSP. The following syntax is used to specify a `board:`
value in the `*.yml` files.

```yml
[vendor::] board_name [:revision]
```

Element      |              | Description
:------------|--------------|:---------------------
`vendor`     | Optional     | Name of the board vendor-defined in `<boards><board>` element of the board support pack (BSP).
`Bname`      | **Required** | Board name (name attribute) as defined in the \<board\> element of the BSP.
`revision`   | Optional     | Board revision (revision attribute) as defined in the \<board\> element of the BSP.

!!! Note
    When a `board:` is specified, the `device:` specification can be omitted, however it is possible to overwrite the device setting in the BSP with an explicit `device:` setting.

**Examples:**

```yml
board: Keil::MCB54110                             # The Keil MCB54110 board (with device NXP::LPC54114J256BD64)
board: LPCXpresso55S28                            # The LPCXpresso55S28 board
board: STMicroelectronics::NUCLEO-L476RG:Rev.C    # A board with revision specification
```

### `context:` Name Conventions

A `context:` name combines `project-name`, `built-type`, and `target-type` and is used in various places in the CMSIS-Toolbox.  The following syntax is used to specify a `context:` name.

```yml
[project-name][.build-type][+target-type]
```

Element             |              | Description
:-------------------|--------------|:---------------------
`project-name`      |   Optional   | Project name of a project (base name of the *.cproject.yml file).
`.build-type`       |   Optional   | The [`build-type`](#build-types) name that is currently processed (specified with `- type: name`).
`+target-type`      |   Optional   | The [`target-type`](#target-types) name that is currently processed (specified with `- type: name`).

!!! Note
    The `.build-type` and `+target-type` names allow letters (A-Z, a-z), digits (0-9), dash ('-'), and underscore ('_'); the maximum length is 32 characters.

- When `project-name` is omitted, the `project-name` is the base name of the `*.cproject.yml` file.
- When `.build-type` is omitted, it matches with any possible `.build-type`.
- When `+target-type` is omitted, it matches with any possible `+target-type`.

By default, the specified `- type: name` of [`build-types:`](#build-types) and [`target-types:`](#target-types) nodes in the `*.csolution.yml` file are directly mapped to the `context` name.
Using the [`context-map:`](#context-map) node, it is possible to assign a different `.build-type` and/or `+target-type` mapping for a specific `project-name`.

**Example:**

Show the different possible context settings of a `*.csolution.yml` file.

```txt
AWS_MQTT_MutualAuth_SW_Framework>csolution list contexts -s Demo.csolution.yml
Demo.Debug+AVH
Demo.Debug+IP-Stack
Demo.Debug+WiFi
Demo.Release+AVH
Demo.Release+IP-Stack
Demo.Release+WiFi
```

The `context` name is also used in [`for-context:`](#for-context) and [`not-for-context:`](#not-for-context) nodes that allow to include or exclude items depending on the `context`. In many cases, the `project-name` can be omitted as the `context` name is within a specific `*.cproject.yml` file or applied to a specific `*.cproject.yml` file.

## Access Sequences

The **access sequences** export values from the CMSIS Project Manager for the
`*.yml` file nodes [`define:`](#define), [`define-asm:`](#define-asm), [`add-path:`](#add-path), [`misc:`](#misc), [`files:`](#files), [`executes:`](#executes), and [`variables:`](#variables). The **access sequences**
can specify a different project and describe, therefore, project dependencies.

!!! Note
    - [`variables:`](#variables) that are defined in the `*.csolution.yml` file can be accessed also using the `$<key>$` notation.

Access Sequence                                | Description
:----------------------------------------------|:--------------------------------------
**Target**                                     | **Access to target and build related settings**
`$Bname$`                                      | [Bname](#board-name-conventions) of the selected board as specified in the [`board:`](#board) node.
`$Dname$`                                      | [Dname](#device-name-conventions) of the selected device as specified in the [`device:`](#device) node.
`$Pname$`                                      | [Pname](#device-name-conventions) of the selected device as specified in the [`device:`](#device) node.
`$BuildType$`                                  | [Build-type](#build-types) name of the currently processed project.
`$TargetType$`                                 | [Target-type](#target-types) name of the currently processed project.
`$Compiler$`                                   | [Compiler](#compiler) name of the compiler used in this project context as specified in the [`compiler:`](#compiler) node.
**YML Input**                                  | **Access to YML Input Directories and Files**
`$Solution$`                                   | Solution name (base name of the *.csolution.yml file).
`$SolutionDir()$`                              | Path to the directory of the current processed `csolution.yml` file.
`$Project$`                                    | Project name of the current processed `cproject.yml` file.
`$ProjectDir(context)$`                        | Path to the directory of a related `cproject.yml` file.
**Output**                                     | **Access to Output Directories and Files**
`$OutDir(context)$`                            | Path to the output directory of a related project that is defined in the `*.csolution.yml` file.
`$bin(context)$`                               | Path and filename of the binary output file generated by the related context.
`$cmse-lib(context)$`                          | Path and filename of the object file with secure gateways of a TrustZone application generated by the related context.
`$elf(context)$`                               | Path and filename of the ELF/DWARF output file generated by the related context.
`$hex(context)$`                               | Path and filename of the HEX output file generated by the related context.
`$lib(context)$`                               | Path and filename of the library file of the related context.
**Pack**                                       | **Access to Pack Directories and Files**
`$Bpack$`                                      | Path to the pack that defines the selected board (BSP).
`$Dpack$`                                      | Path to the pack that defines the selected device (DFP).
`$Pack(vendor::name)$`                         | Path to a specific pack. Example: `$Pack(NXP::K32L3A60_DFP)$`.

For a [`context`](#context-name-conventions), the `project-name`, `.build-type`, and `+target-type` are optional. An **access sequence** that specifies only `project-name` uses the context that is currently processed. It is important that the `project` is part of the [selected build variant](build-overview.md#working-with-target-set) in the build process. Example: `$ProjectDir()$` is the directory of the current processed `cproject.yml` file.

**Example:**

This example uses the following `build-type`, `target-type`, and `projects` definitions.

```yml
solution:
  target-types:
    - type: Board               # target-type: Board
      board: NUCLEO-L552ZE-Q    # specifies board
      target-set:
        - set:
          - project-context: TFM.Debug
          - project-context: MQTT_AWS.Debug

    - type: Production-HW       # target-type: Production-HW
      device: STM32L5X          # specifies device
      target-set:
        - set:
          - project-context: TFM.Release
          - project-context: MQTT_AWS.Debug

  build-types:
    - type: Debug               # build-type: Debug
      optimize: none
      debug: on

    - type: Release             # build-type: Release
      optimize: size

  projects:
    - project: ./bootloader/Bootloader.cproject.yml           # relative path
    - project: /MyDevelopmentTree/security/TFM.cproject.yml   # absolute path
    - project: ./application/MQTT_AWS.cproject.yml            # relative path
```

The `project: /application/MQTT_AWS.cproject.yml` may use **access sequences** to reference files or directories in other projects that belong to the same *csolution project*.

For example, these references are possible in the file `MQTT_AWS.cproject.yml`.

```yml
    files:
      - file: $cmse-lib(TFM)$                         # use symbol output file of TFM Project
```

The example above uses the `build-type` and `target-type` of the processed context for the project `TFM`. With a [target-set](build-overview.md#working-with-target-set) you may mix different `build-types` for an application. Note that it is important to build both projects using the same build process, for example by specifying the option `--active` to [select a build variant](build-overview.md#working-with-target-set).

```bash
cbuild iot-product.csolution.yml --active Production-HW
```

The example below uses from the TFM project always `build-type: Debug` and the `target-type: Production-HW`.

```yml
    files:
    - file: `$cmse-lib(TFM.Release+Production-HW)$` # use symbol output file of TFM Project
```

The example below uses the `build-type: Debug` and the `target-type` of the current processed context is used.

```yml
  executes:
    - execute: GenImage
      run: gen_image %input% -o %output%
      input:
        - $elf(TFM.Debug)$
        - $elf(Bootloader.Release)$
      output:
        - $OutDir(TFM.Debug)$
```

The example below creates a `define` that uses the device name.

```yml
groups:
  - group:  "Main File Group"
    define:
      - $Dname$                           # Generate a #define 'device-name' for this file group
```

## Order of List Nodes

The *key*/*value* pairs in a list node can be in any order.  The two following list nodes are logically identical. This
might be confusing for `yml` files that are generated by an IDE.

```yml
  build-types:
    - type: Release         # build-type name
      optimize: size        # optimize for size
      debug: off            # generate no debug information for the release build
```

```yml
  build-types:
    - debug: off            # generate no debug information for the release build
      optimize: size        # optimize for size
      type: Release         # build-type name
```

## Project File Structure

The table below explains the top-level elements in each of the different `*.yml` input files that define the overall application.

Keyword                          | Description
:--------------------------------|:------------------------------------
[`default:`](#cdefault)          | Start of `cdefault.yml` file that is used to setup the compiler along with some compiler-specific controls.
[`solution:`](#solution)         | Start of `*.csolution.yml` file that [collects related projects](build-overview.md#project-examples) along with `build-types:` and `target-types:`.
[`project:`](#project)           | Start of `*.cproject.yml` file that defines files, components, and layers which can be independently translated to a binary image or library.
[`layer:`](#layer)               | Start of `*.clayer.yml` file that contains pre-configured software components along with source files.

### `cdefault:`

When [`cdefault:`](#solution) is specified in the `*.csolution.yml` file, the **`csolution` Project Manager** uses a file with the name [`cdefault.yml`](build-overview.md#cdefaultyml) to setup
the compiler with specific default controls. The search order for this file is:

- A [`cdefault.yml`](build-overview.md#cdefaultyml) file in the same directory as the `<solution-name>.csolution.yml` file.
- A [`cdefault.yml`](build-overview.md#cdefaultyml) file in the directory [`<cmsis-toolbox-installation-dir>/etc`](installation.md#environment-variables).

The `default:` node is the start of a [`cdefault.yml`](build-overview.md#cdefaultyml) file and contains the following.

`default:`                                                |            | Content
:---------------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp; [`misc:`](#misc)                             |  Optional  | Literal tool-specific controls. Refer to [CSolution Project Structure - `cdefault.yml`](build-overview.md#cdefaultyml) for an example.

!!! Note
    The [`compiler:`](#compiler) selection in `cdefault.yml` has been deprecated in CMSIS-Toolbox 2.6.0.

### `solution:`

The `solution:` node is the start of a `*.csolution.yml` file that collects related projects as described in the section
["Configure Related Projects"](build-overview.md#configure-related-projects).

`solution:`                                          |            | Content
:----------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; `created-by:`                     |  Optional  | Identifies the tool that created this solution.
&nbsp;&nbsp;&nbsp; `created-for:`                    |  Optional  | Specifies the tool for building this solution, i.e. **CMSIS-Toolbox@2.5.0**
&nbsp;&nbsp;&nbsp; `description:`                    |  Optional  | Brief description text of this solution.
&nbsp;&nbsp;&nbsp; [`select-compiler:`](#select-compiler) |  Optional  | Lists the possible compiler selection that this project is tested with.
&nbsp;&nbsp;&nbsp; [`cdefault:`](#cdefault)          |  Optional  | When specified, the [`cdefault.yml`](build-overview.md#cdefaultyml) file is used to setup compiler specific controls.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)          |  Optional  | Overall toolchain selection for this solution.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)      |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)  |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`output-dirs:`](#output-dirs)    |  Optional  | Control the output directories for the build output.
&nbsp;&nbsp;&nbsp; [`generators:`](#generators)      |  Optional  | Control the directory structure for generator output.
&nbsp;&nbsp;&nbsp; [`packs:`](#packs)                |  Optional  | Defines local packs and/or scope of packs that are used.
&nbsp;&nbsp;&nbsp; [`target-types:`](#target-types)  |**Required**| List of target-types that define the target system (device or board).
&nbsp;&nbsp;&nbsp; [`build-types:`](#build-types)    |  Optional  | List of build-types (i.e. Release, Debug, Test).
&nbsp;&nbsp;&nbsp; [`projects:`](#projects)          |**Required**| List of projects that belong to the solution.
&nbsp;&nbsp;&nbsp; [`executes:`](#executes)          |  Optional  | Additional pre or post build steps using external tools.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                  |  Optional  | Literal tool-specific controls.

**Example:**

```yml
solution:
  created-for: cmsis-toolbox@2.6  # minimum CMSIS-Toolbox version required for project build
  cdefault:                       # use default setup of toolchain-specific controls.
  compiler: GCC                   # overwrite compiler definition in 'cdefaults.yml'

  packs:
    - pack: ST                    # add ST packs in 'cdefaults.yml'

  build-types:                    # additional build types
    - type: Test                  # build-type: Test
      optimize: none
      debug: on
      packs:                      # with explicit pack specification
        - pack: ST::TestSW
          path: ./MyDev/TestSW

  target-types:
    - type: Board                 # target-type: Board
      board: NUCLEO-L552ZE-Q

    - type: Production-HW         # target-type: Production-HW
      device: STM32U5X            # specifies device

  projects:
    - project: ./blinky/Bootloader.cproject.yml
    - project: /security/TFM.cproject.yml
    - project: /application/MQTT_AWS.cproject.yml
```

### `project:`

The `project:` node is the start of a `*.cproject.yml` file and can contain the following:

`project:`                                          |            | Content
:---------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; `description:`                   |  Optional  | Brief description text of this project.
&nbsp;&nbsp;&nbsp; [`output:`](#output)             |  Optional  | Configure the generated output files.
&nbsp;&nbsp;&nbsp; [`generators:`](#generators)     |  Optional  | Control the directory structure for generator output.
&nbsp;&nbsp;&nbsp; [`rte:`](#rte)                   |  Optional  | Control the directory structure for [RTE (run-time environment)](build-overview.md#rte-directory-structure) files.
&nbsp;&nbsp;&nbsp; [`packs:`](#packs)               |  Optional  | Defines packs that are required for this project.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)     |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp) |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)         |  Optional  | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`linker:`](#linker)             |  Optional  | Instructions for the linker.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)               |  Optional  | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)             |  Optional  | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)     |  Optional  | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)         |  Optional  | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)         |  Optional  | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)         |  Optional  | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                 |  Optional  | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`device:`](#device)             |  Optional  | Specify processor core.
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)       |  Optional  | Processor specific settings.
&nbsp;&nbsp;&nbsp; [`setups:`](#setups)             |  Optional  | Configurations specific to a compiler, target-type, and/or built-type.
&nbsp;&nbsp;&nbsp; [`groups:`](#groups)             |**Required**| List of source file groups along with source files.
&nbsp;&nbsp;&nbsp; [`components:`](#components)     |  Optional  | List of software components used.
&nbsp;&nbsp;&nbsp; [`layers:`](#layers)             |  Optional  | List of software layers that belong to the project.
&nbsp;&nbsp;&nbsp; [`connections:`](#connections)   |  Optional  | List of consumed and provided resources.
&nbsp;&nbsp;&nbsp; [`executes:`](#executes)         |  Optional  | Additional pre or post build steps using external tools.

**Example:**

```yml
project:
  misc:
    - compiler: AC6                          # specify misc controls for Arm Compiler 6
      C: [-fshort-enums, -fshort-wchar]      # set options for C files
  add-path:
    - $OutDir(Secure)$                       # add the path to the secure project's output directory
  components:
    - component: Startup                     # Add startup component
    - component: CMSIS CORE
    - component: Keil RTX5 Library_NS
  groups:
    - group: Non-secure Code                 # Create group
      files:
        - file: main_ns.c                    # Add files to group
        - file: $Source(Secure)$interface.h
        - file: $Output(Secure)$_CMSE_Lib.o
```

### `layer:`

The `layer:` node is the start of a `*.clayer.yml` file and defines a [Software Layer](./build-overview.md#software-layers). It can contain the following nodes:

`layer:`                                                     |            | Content
:------------------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; [`type:`](#layer-type)                    |  Optional  | Layer type for combining layers; used to identify [compatible layers](ReferenceApplications.md#usage).
&nbsp;&nbsp;&nbsp; `description:`                            |  Optional  | Brief description text of the layer.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)              |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)          |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)                  |  Optional  | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                        |  Optional  | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)                  |  Optional  | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                      |  Optional  | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)              |  Optional  | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)                  |  Optional  | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)                  |  Optional  | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)                  |  Optional  | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                          |  Optional  | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`device:`](#device)                      |  Optional  | Specify processor core.
&nbsp;&nbsp;&nbsp; [`generators:`](#generators)              |  Optional  | Control the directory structure for generator output.
&nbsp;&nbsp;&nbsp; [`packs:`](#packs)                        |  Optional  | Defines packs that are required for this layer.
&nbsp;&nbsp;&nbsp; [`for-device:`](#device-name-conventions) |  Optional  | Device information, used for consistency check (device selection is in `*.csolution.yml`).
&nbsp;&nbsp;&nbsp; [`for-board:`](#board-name-conventions)   |  Optional  | Board information, used for consistency check (board selection is in `*.csolution.yml`).
&nbsp;&nbsp;&nbsp; [`connections:`](#connections)            |  Optional  | List of consumed and provided resources.
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)                |  Optional  | Processor specific settings.
&nbsp;&nbsp;&nbsp; [`linker:`](#linker)                      |  Optional  | Instructions for the linker.
&nbsp;&nbsp;&nbsp; [`groups:`](#groups)                      |  Optional  | List of source file groups along with source files.
&nbsp;&nbsp;&nbsp; [`components:`](#components)              |  Optional  | List of software components used.

**Example:**

```yml
layer:
  type: Board
  description: Setup with Ethernet and WiFi interface
  processor:
    trustzone: secure        # set processor to secure
  components:
    - component: Startup
    - component: CMSIS CORE
  groups:
    - group: Secure Code
      files:
        - file: main_s.c
    - group: CMSE
      files:
        - file: interface.c
        - file: interface.h
        - file: tz_context.c
```

## Directory Control

The following nodes control the application's directory structure.

### `output-dirs:`

Allows control of the directory structure for building output files and temporary files.

!!! Notes
    - This control is only possible at `csolution.yml` level.
    - CMake manages the temporary directory of all projects therefore `tmpdir:` does not support access sequences.

`output-dirs:`                     |              | Content
:----------------------------------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `outdir:`       |  Optional    | Specifies the directory for the build output files (ELF, binary, MAP files).
&nbsp;&nbsp;&nbsp; `tmpdir:`       |  Optional    | Specifies the directory for the interim temporary files.
&nbsp;&nbsp;&nbsp; `intdir:`       |  Optional    | Legacy node, applied instead of `tmpdir:` when using `cbuild` with option `--cbuildgen`.

The default setting for the `output-dirs:` are:

```yml
  tmpdir:  tmp                          # All projects use the same temporary directory
  outdir:  $SolutionDir()$/out/$TargetType$/$BuildType$
```

With the tool option `--output` an prefix top-level directory can be added. The effective `outdir:` with the command below is: `MyOut/out/$TargetType$/$BuildType$`.

```bash
cbuild <name>.csolution.yml --output MyOut
```

**Example:**

```yml
output-dirs:
  tmpdir: ./tmp2                         # relative path to csolution.yml file
  outdir: ./out/$Project$/$TargetType$   # $BuildType$ no longer part of the outdir
```

### `generators:`

Allows control of the directory structure for generator output files.

When no explicit `generators:` is specified, the **`csolution` Project Manager** uses as path:

- The `workingDir` defined in the [generators element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_generators_pg.html#element_generator) of the PDSC file.
- When no `workingDir` is defined the default directory `$ProjectDir()$/generated/<generator-id>` is used; `<generator-id>` is defined by the `id` in the generators element of the PDSC file.

The `generators:` node can be added at various levels of the `*.yml` input files. The following order is used:

1. Use `generators:` specification of the `*.clayer.yml` input file, if not exist:
2. Use `generators:` specification of the `*.cproject.yml` input file, if not exist:
3. Use `generators:` specification of the `*.csolution.yml` input file.

!!! Notes
    - Only relative paths are permitted to support the portability of projects.
    - The location of the `*.yml` file that contains the `generators:` node is the reference for relative paths.

`generators:`                  |            | Content
:------------------------------|------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `base-dir:` |  Optional  | Base directory for unspecified generators; default: `$ProjectDir()$/generated`.
&nbsp;&nbsp;&nbsp; `options:`  |  Optional  | Specific generator options; allows explicit directory configuration for a generator.

!!! Note
    The base directory is extended for each generator with `/<generator-id>`; `<generator-id>` is defined by the `id` in the generator element of the PDSC file.

#### `generators:` `options:`

`options:`                     |            | Content
:------------------------------|------------|:------------------------------------
`- generator:`                 |  Optional  | Identifier of the generator tool, specified with `id` in the [generators element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_generators_pg.html#element_generator) of the PDSC file.
&nbsp;&nbsp;&nbsp; `path:`     |  Optional  | Specifies the directory for generated files. Relative paths used the location of the `*.cproject.yml` or `*.clayer.yml` file as the base directory.
&nbsp;&nbsp;&nbsp; `name:`     |  Optional  | Specifies the base name of the [generator import file](YML-CBuild-Format.md#generator-import-file) (added in CMSIS-Toolbox 2.4.0); typically used for a board layer.
&nbsp;&nbsp;&nbsp; `map:`      |  Optional  | Mapping of the *csolution project* to a generator-specific run-time context name (added in CMSIS-Toolbox 2.4.0).

**Example:**

```yml
generators:
  base-dir: $SolutionDir()$/MyGenerators      # Path for all generators extended by '/<generator-id>'

  options:
  - generator: CubeMX                         # for the generator id `CubeMX` use this path
    path:  ./CubeFiles                        # relative path to generated files and the generator import file
    name: MyConf                              # results in generator import file ./CubeFiles/MyConf.cgen.yml
    map: Boot                                 # Map this project part to the CubeMX run-time context Boot
```

### `rte:`

Allows to control the directory structure for [RTE (run-time environment)](build-overview.md#rte-directory-structure) files.

!!! Notes
    - This control is only possible at `*.cproject.yml` level.
    - Only relative paths are permitted to support the portability of projects.
    - The location of the `*.cproject.yml` file is the reference for relative paths.

`rte:`                         |            | Content
:------------------------------|------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `base-dir:` |  Optional  | Base directory for unspecified generators; default: `$ProjectDir()$/RTE`.

```yml
rte:
  base-dir: $TargetType$/RTE      # Path extended with target-type, results in `$ProjectDir()$/$TargetType$/RTE`
```

## Toolchain Options

Toolchain options may be used at various places, such as:

- [`solution:`](#solution) level to specify options for a collection of related projects.
- [`project:`](#projects) level to specify options for a project.

### `select-compiler:`

Lists the compilers that this *csolution project* is tested with. This information is used by the [`cbuild setup` command](build-operation.md#details-of-the-setup-mode) to determine possible compiler choices. The actual compiler to be used is selected with the [`compiler:`](#compiler) node.

!!! Notes
    - [`select-compiler:`](#select-compiler) is only supported in the [`*.csolution.yml`](#solution) project file.
    - This control is new in CMSIS-Toolbox 2.5.0

`select-compiler:`                                          |            | Content
:-----------------------------------------------------------|:-----------|:-------------------------------------------
`- compiler:`                                               |**Required**| Specifies a supported compiler.

**Example:**

```yml
solution:
  created-for: cmsis-toolbox@2.5  # minimum CMSIS-Toolbox version required for project build
  select-compiler:                # list tested compilers that can be selected
    - compiler: GCC               # GCC is supported
    - compiler: AC6@6.22          # AC6 is supported, version number is a hint on what was tested
```

### `compiler:`

Selects the compiler toolchain used for code generation. It can be applied in `*.csolution.yml` files.
Optionally the compiler can have a version number specification.

Compiler Name                                         | Supported Compiler
:-----------------------------------------------------|:------------------------------------
`AC6`                                                 | Arm Compiler version 6
`GCC`                                                 | GCC Compiler
`IAR`                                                 | IAR Compiler
`CLANG`                                               | CLANG Compiler based on LLVM technology

**Example:**

```yml
compiler: GCC              # Select GCC Compiler
```

```yml
compiler: AC6@6.18.0       # Select Arm Compiler version 6.18.0
```

### `linker:`

The `linker:` node specifies an explicit Linker Script and/or memory regions header file.  It can be applied in `*.cproject.yml` and `*.clayer.yml` files.
Refer to [Linker Script Management](build-overview.md#linker-script-management) for detailed information.

`linker:`                                                   |            | Content
:-----------------------------------------------------------|:-----------|:--------------------------------
`- regions:`                                                |  Optional  | Path and file name of `<regions_file>.h`, used to generate a Linker Script.
&nbsp;&nbsp;&nbsp;`script:`                                 |  Optional  | Explicit file name of the Linker Script, overrules files provided with [`file:`](#files) or components.
&nbsp;&nbsp;&nbsp;`auto:`                                   |  Optional  | Request [automatic Linker Script generation](build-overview.md#automatic-linker-script-generation).
&nbsp;&nbsp;&nbsp;[`define:`](#define)                      |  Optional  | Define symbol settings for the linker script file preprocessor.
&nbsp;&nbsp;&nbsp;[`for-compiler:`](#for-compiler)          |  Optional  | Include Linker Script for the specified toolchain.
&nbsp;&nbsp;&nbsp;[`for-context:`](#for-context)            |  Optional  | Include Linker Script for a list of *build* and *target* type names.
&nbsp;&nbsp;&nbsp;[`not-for-context:`](#not-for-context)    |  Optional  | Exclude Linker Script for a list of *build* and *target* type names.

!!! Notes
    - The `linker:` node must have at least `regions:`, `script:`, `auto:`, or `define:`.
    - If no `script:` file is specified, compiler-specific [Linker Script template files](build-overview.md#linker-script-templates) are used.
    - A Linker Script file is preprocessed when `regions:` or a `define:` is or the file extension is `*.src`.
    - If both `auto:` and `script:` is specified, a warning is issued, and [automatic Linker Script generation](build-overview.md#automatic-linker-script-generation) is performed, and the specified `script:` is ignored.

**Examples:**

```yml
linker:
  - script:   MyLinker.scf.src   # linker script file
    regions:  MyRegions.h        # pre-processed using header file
```

```yml
linker:
  - regions:  MyRegions.h        # Default linker script is used and pre-processed using header file
```

```yml
linker:
  - script:   MyLinker.scf.src   # linker script file, not pre-processed
    for-compiler: AC6            # for Arm Compiler 6

  - script:   MyLinker.ld        # linker script file, not pre-processed
    for-compiler: CLANG          # for CLANG LLVM-based compiler
```

```yml
linker:
  - script:   MyLinker.scf.src   # linker script file
    for-compiler: AC6            # for Arm Compiler 6
    regions:  MyRegions.h        # pre-processed using header file

  - script:   MyLinker.ld.src    # linker script file
    for-compiler: CLANG          # for CLANG LLVM-based compiler
    regions:  MyRegions.h        # pre-processed using header file
    define:                      # with define setting
      - Setup: 1                 # define with value
```

### `output:`

Configure the generated output files.

`output:`                              |            | Content
:--------------------------------------|:-----------|:--------------------------------
&nbsp;&nbsp;&nbsp; `base-name:`        |  Optional  | Specify a common base name for all output files.
&nbsp;&nbsp;&nbsp; `type:`             |  Optional  | A list of output types for code generation (see list below).

`type:`           | Description
:-----------------|:-------------
`- lib`           | Library or archive. Note: GCC uses the prefix `lib` in the base name for archive files.
`- elf`           | Executable in ELF format. The file extension is toolchain-specific.
`- hex`           | Intel HEX file in HEX-386 format.
`- bin`           | Binary image.
`- map`           | Linker MAP file.

The **default** setting for `output:` is:

```yml
output:
  base-name: $Project$   # used the base name of the `cproject.yml` file.
  type: elf              # Generate executable file.
```

**Example:**

```yml
output:
  type:
  - elf                  # Generate executable file.
  - map                  # Generate Linker MAP file.
```

```yml
output:                  # configure output files.
  base-name: MyProject   # used for all output files, including linker map file.
  type:
  - elf                  # Generate executable file.
  - hex                  # generate a HEX file.
  - bin                  # generate a BIN file.
```

Generate a **library**:

```yml
output:                  # configure output files.
  type: lib              # Generate library file.
```

## Translation Control

The following translation control options may be used at various places such as:

- [`solution:`](#solution) level to specify options for a collection of related projects
- [`project:`](#projects) level to specify options for a project
- [`groups:`](#groups) level to specify options for a specify source file group
- [`files:`](#files) level to specify options for a specify source file

!!! Note
    - The keys `define:`, `define-asm:`, `add-path:`, `add-path-asm:`, `del-path:`, and `misc:` are additive.
    - All other keys can only be defined once at the level of `solution:`, `project:`, `setup:`, `layer:`and `build-types:`. or `target-types:`. However, it is possible to overwrite these keys at the level of `group:`, `file:`, or `component:`; for example it is possible to translate a file group with a different optimize level.

### `language-C:`

Set the language standard for C source file compilation.

Value                                                 | Select C Language Standard
:-----------------------------------------------------|:------------------------------------
`c90`                                                 | compile C source files as defined in C90 standard (ISO/IEC 9899:1990).
`gnu90`                                               | same as `c90` but with additional GNU extensions.
`c99` (default)                                       | compile C source files as defined in C99 standard (ISO/IEC 9899:1999).
`gnu99`                                               | same as `c99` but with additional GNU extensions.
`c11`                                                 | compile C source files as defined in C11 standard (ISO/IEC 9899:2011).
`gnu11`                                               | same as `c11` but with additional GNU extensions.
`c17`                                                 | compile C source files as defined in C17 standard (ISO/IEC 9899:2017). Experimental compiler feature new in CMSIS-Toolbox 2.6.0.
`c23`                                                 | compile C source files as defined in C23 standard (ISO/IEC 9899:2023). Experimental compiler feature new in CMSIS-Toolbox 2.6.0.

### `language-CPP:`

Set the language standard for C++ source file compilation.

Value                                                 | Select C++ Language Standard
:-----------------------------------------------------|:------------------------------------
`c++98`                                               | compile C++ source files as defined in C++98 standard (ISO/IEC 14882:1998).
`gnu++98`                                             | same as `c++98` but with additional GNU extensions.
`c++03`                                               | compile C++ source files as defined in C++03 standard (ISO/IEC 14882:2003).
`gnu++03`                                             | same as `c++03` but with additional GNU extensions.
`c++11`                                               | compile C++ source files as defined in C++11 standard (ISO/IEC 14882:2011).
`gnu++11`                                             | same as `c++11` but with additional GNU extensions.
`c++14` (default)                                     | compile C++ source files as defined in C++14 standard (ISO/IEC 14882:2014).
`gnu++14`                                             | same as `c++14` but with additional GNU extensions.
`c++17`                                               | compile C++ source files as defined in C++17 standard (ISO/IEC 14882:2014).
`gnu++17`                                             | same as `c++17` but with additional GNU extensions.
`c++20`                                               | compile C++ source files as defined in C++20 standard (ISO/IEC 14882:2020).
`gnu++20`                                             | same as `c++20` but with additional GNU extensions.
`c++23`                                               | compile C++ source files as defined in C++23 standard (ISO/IEC 14882:2023).
`gnu++23`                                             | same as `c++23` but with additional GNU extensions.

### `optimize:`

Generic optimize levels for code generation.

Value                                                 | Code Generation
:-----------------------------------------------------|:------------------------------------
`balanced`                                            | Balanced optimization
`size`                                                | Optimize for code size
`speed`                                               | Optimize for execution speed
`debug`                                               | Optimize for debug experience
`none`                                                | No optimization

!!! Note
    When `optimize:` is not specified, the default optimize setting of the compiler is used.

**Example:**

```yml
groups:
  - group:  "Main File Group"
    optimize: none          # optimize this file group for debug illusion
    files:
      - file: file1a.c
      - file: file1b.c
```

### `link-time-optimize:`

When applied, the link-time optimization is enabled. It enables global optimizations across multiple translation units at the linker stage which typically further improves performance and reduces code size.

**Example:**

```yml
groups:
  - group:  "Main File Group"
    optimize: speed                  # optimize for execution speed
    link-time-optimize:              # enable link-time optimization for this file group
    files:
      - file: file1a.c
      - file: file1b.c
```

!!! Note
    This feature is not available with the IAR compiler.

### `debug:`

Control the generation of debug information.

Value                                                 | Code Generation
:-----------------------------------------------------|:------------------------------------
`on`                                                  | Generate debug information (default)
`off`                                                 | Generate no debug information

**Example:**

```yml
 build-types:
    - type: Release
      optimize: size        # optimize for size
      debug: off            # generate no debug information for the release build
```

### `warnings:`

Control warning level for compiler diagnostics.

Value                                                 | Control diagnostic messages (warnings)
:-----------------------------------------------------|:------------------------------------
`on`                                                  | Generate warning messages
`all`                                                 | Enable all compiler warning messages (compiler option -Wall)
`off`                                                 | No warning messages generated

### `define:`

Contains a list of symbol #define statements that are passed via the command line to the development tools for C, C++ source files, or the [linker](#linker) script file preprocessor.

`define:`                                                   | Content
:-----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <symbol-name>`                        | #define symbol passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: <value>`               | #define symbol with value passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: \"<string>\"`          | #define symbol with string value passed via command line

!!! Note
    This control only applies to C and C++ source files (or to the [linker](#linker) script preprocessor).  For assembler source files use the `define-asm:` node.

**Example:**

```yml
define:                    # Start a list of define statements
  - TestValue: 12          # add symbol 'TestValue' with value 12
  - TestMode               # add symbol 'TestMode'
```

### `define-asm:`

Contains a list of symbol #define statements that are passed via the command line to the development tools for Assembler  source files.

`define-asm:`                                               | Content
:-----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <symbol-name>`                        | #define symbol passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: <value>`               | #define symbol with value passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: \"<string>\"`          | #define symbol with string value passed via command line

**Example:**

```yml
define-asm:                # Start a list of define statements for Assembler source code
  - AsmValue: 12           # add symbol 'AsmValue' with value 12
```

### `undefine:`

Remove symbol #define statements from the command line of the development tools.

`undefine:`                                          | Content
:----------------------------------------------------|:------------------------------------
&nbsp;&nbsp; `- <symbol-name>`                       | Remove #define symbol

**Examples:**

```yml
groups:
  - group:  "Main File Group"
    undefine:
      - TestValue           # remove define symbol `TestValue` for this file group
    files:
      - file: file1a.c
        undefine:
         - TestMode         # remove define symbol `TestMode` for this file
      - file: file1b.c
```

### `add-path:`

Add include paths to the command line of the development tools for C and C++ source files.

`add-path:`                                                | Content
:----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <path-name>`                         | Named path to be added

!!! Note
    This control only applies to C and C++ source files.  For assembler source files, use the `add-path-asm:` node.

**Example:**

```yml
project:
  misc:
    - for-compiler: AC6
      C: [-fshort-enums, -fshort-wchar]
    - for-compiler: GCC
      C: [-fshort-enums, -fshort-wchar]

  add-path:
    - $OutDir(Secure)$                   # add path to secure the project's output directory
```

### `add-path-asm:`

Add include paths to the command line of the development tools for assembly source files.

`add-path-asm:`                                            | Content
:----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <path-name>`                         | Named path to be added

!!! Note
    This control only applies to assembler source files.  For C and C++ source files use the `add-path:` node.

**Example:**

```yml
project:
  add-path-asm:
    - .\MyAsmIncludes                    # add path to assembler include files secure project's output directory
```

### `del-path:`

Remove include paths (that are defined at the cproject level) from the command line of the development tools.

`del-paths:`                                               | Content
:----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <path-name>`                         | Named path to be removed; `*` for all

**Example:**

```yml
  target-types:
    - type: CM3
      device: ARMCM3
      del-paths:
        - /path/solution/to-be-removed
```

### `misc:`

Add miscellaneous literal tool-specific controls that are directly passed to the individual tools depending on the file type.

`misc:`                                    |              | Content
:------------------------------------------|--------------|:------------------------------------
[`- for-compiler:`](#for-compiler)         |   Optional   | Name of the toolchain that the literal control string applies to.
&nbsp;&nbsp;&nbsp; `C-CPP:`                |   Optional   | Applies to `*.c` and `*.cpp` files (added before `C` and `CPP:`).
&nbsp;&nbsp;&nbsp; `C:`                    |   Optional   | Applies to `*.c` files only.
&nbsp;&nbsp;&nbsp; `CPP:`                  |   Optional   | Applies to `*.cpp` files only.
&nbsp;&nbsp;&nbsp; `ASM:`                  |   Optional   | Applies to assembler source files only.
&nbsp;&nbsp;&nbsp; `Link:`                 |   Optional   | Applies to the linker (added before `Link-C:` or `Link-CPP:`).
&nbsp;&nbsp;&nbsp; `Link-C:`               |   Optional   | Applies to the linker; added when no C++ files are part of the project.
&nbsp;&nbsp;&nbsp; `Link-CPP:`             |   Optional   | Applies to the linker; added when C++ files are part of the project.
&nbsp;&nbsp;&nbsp; `Library:`              |   Optional   | Set libraries to the correct position in the linker command line (for GCC).

**Example:**

```yml
  build-types:
    - type: Debug
      misc:
        - for-compiler: AC6
          C-CPP:
            - -O1
            - -g
        - for-compiler: GCC
          C-CPP:
            - -Og

    - type: Release
      compiler: AC6
      misc:
        - C:
          - -O3

    - type: GCC-LibDebug
      compiler: GCC
      misc:
        - Library:
          - -lm
          - -lc
          - -lgcc
          - -lnosys
```

## Project Setups

The `setups:` node can be used to create setups specific to a compiler, target type, and/or built type.

### `setups:`

The `setups:` node collects a list of `setup:` notes.  Only one setup will be selected for each context.

The result is a `setup:` that collects various toolchain options, and that is valid for all files and components in the
project. It is, however, possible to change that `setup:` settings on a [`group:`](#groups) or [`file:`](#files) level.

`setups:`                                            |              | Content
:----------------------------------------------------|:-------------|:------------------------------------
`- setup:`                                           | **Required** | Description of the setup
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)          |   Optional   | Include group for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)  |   Optional   | Exclude group for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)  |   Optional   | Include group for a list of compilers.
&nbsp;&nbsp;&nbsp; [`output:`](#output)              |   Optional   | Configure the generated output files.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)      |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)  |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)          |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)          |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)              |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)      |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)          |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)          |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)  |   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)          |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`linker:`](#linker)              |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                  |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)        |   Optional   | Processor configuration.

```yml
project:
  setups:
    - setup: Arm Compiler 6 project setup
      for-compiler: AC6
      linker:
        - script: my-project.sct
      define:
        - test: 12

   - setup: GCC project setup
     for-compiler: GCC
     linker:
       - script: my-project.inc
     define:
       - test: 11
```

## Pack Selection

The `packs:` node can be specified in the `*.csolution.yml` file allows you to:

- Reduce the scope of software packs that are available for projects.
- Add specific software packs that are optional with version specifications.
- Provide a path to a local installation of a software pack that is, for example, project-specific or under development.

The  [Pack Name Conventions](#pack-name-conventions) specify the names of the software packs.
The `pack:` definition may be specific to a [`context`](#context) that specifies `target-types:` and/or `build-types:` or provides a local path to a development repository of a software pack.

!!! Notes
    - By default, the **`csolution` Project Manager** only loads the latest version of the installed software packs. It is, however, possible to request specific versions using the `- pack:` node.
    - An attempt to add two different versions of the same software pack results in an error.

### `packs:`

The `packs:` node is the start of a pack selection.

`packs:`                                              | Content
:-----------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; [`- pack:`](#pack)                 | Explicit pack specification (additive)

### `pack:`

The `pack:` list allows to add [specific software packs](#pack-name-conventions), optional with a version specification.

`pack:`                                                     | Content
:-----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `path:`                                  | Explicit path name that stores the software pack. This can be a relative path to your project workspace.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)           | Include pack for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)   | Exclude pack for a list of *build* and *target* types.

!!! Note
    When an explicit `path:` to the pack is specified, an explicit pack version cannot be specified as the path directly specifies the pack to include.

**Example:**

```yml
packs:                                  # start section that specifics software packs
  - pack: AWS                           # use packs from AWS
  - pack: NXP::*K32L*                   # use packs from NXP relating to K32L series (would match K32L3A60_DFP + FRDM-K32L3A6_BSP)
  - pack: ARM                           # use packs from Arm

  - pack: Keil::Arm_Compiler            # add latest version of Keil::Arm_Compiler pack
  - pack: Keil::MDK-Middleware@7.13.0   # add Keil::MDK-Middleware pack at version 7.13.0
  - pack: ARM::CMSIS-FreeRTOS@~10.4.0   # add CMSIS-FreeRTOS with version 10.4.x or higher but lower than 10.5.0
  - pack: ARM::CMSIS-FreeRTOS@^10.4.0   # add CMSIS-FreeRTOS with version 10.4.x or higher but lower than 11.0.0

  - pack: NXP::K32L3A60_DFP             # add pack for NXP device
ftar    path: ./local/NXP/K32L3A60_DFP      # with path to the pack (local copy, repo, etc.)

  - pack: AWS::coreHTTP                 # add pack
    path: ./development/AWS/coreHTTP    # with path to development source directory
    for-context: +DevTest               # pack is only used for target-type "DevTest"
```

## Target Selection

### `board:`

Specifies a [unique board name](#board-name-conventions), optionally with vendor that must be defined in software packs.
This information is used to define the `device:` along with basic toolchain settings.

### `device:`

Specifies a [unique device name](#device-name-conventions), optionally with the vendor that must be defined in software
packs. This information is used to define the `device:` along with basic toolchain settings.

A `device:` is derived from the `board:` setting, but an explicit `device:` setting overrules the `board:` device.

If `device:` specifies a device with a multi-core processor, and no explicit `pname` for the processor core selection is specified, the default `pname` of the device is used.

At the level of a `cproject.yml` file, only the `pname` can be specified as the device itself is selected at the level of a `csolution.yml` file.

**Example:**

The following assumes that the csolution is based on NXP's `K32L3A60VPJ1A` which has two `pnames`: `cm4` and `cm0plus`. Here are the corresponding entries in the `*.cproject.yml` files:

*CM4.cproject.yml:*

```yml
project:
  device: :cm4
```

*CM0Plus.cproject.yml:*

```yml
project:
  device: :cm0plus
```

## Processor Attributes

### `processor:`

The `processor:` keyword specifies the processor features used in this project.

`processor:`                            | Content
:---------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `fpu:`               | Select usage of FPU instructions: `dp` (double precision) \| `sp` (single precision) \| `off` (disabled).
&nbsp;&nbsp;&nbsp; `dsp:`               | Select usage of SIMD instructions: `on` (enabled) \| `off` (disabled).
&nbsp;&nbsp;&nbsp; `mve:`               | Select usage of M-Profile vector extension: `fp` (floating point and integer instructions) \| `int` (integer instructions) \| `off` (disabled).
&nbsp;&nbsp;&nbsp; `trustzone:`         | Select TrustZone mode: `secure` \| `secure-only` \| `non-secure` \| `off`.
&nbsp;&nbsp;&nbsp; `branch-protection:` | Select Branch Protection mode: `bti` (branch target identification) \| `bti-signret` (branch target identification and pointer authentication) \| `off` (disabled).

The default setting enables the available features of the device. For example `fpu: dp` is selected for devices that offer double precision floating point hardware.

For `trustzone:` the possible settings are:

`trustzone:`  | Description
:-------------|:----------------
`off`         | TrustZone disabled, classic Cortex-M programmers model. Default for devices with configurable TrustZone feature.
`non-secure`  | Non-secure mode. Default for devices with enabled TrustZone feature.
`secure`      | Secure mode with veneers for non-secure calls. Related options to generate `cmse` library are enabled.
`secure-only` | Secure mode without veneers for non-secure calls. No `cmse` library generated (new in CMSIS-Toolbox 2.6.0).

**Example:**

```yml
project:
  processor:
    trustzone: secure
    fpu: off             # do not use FPU instructions
    mve: off             # do not use vector instructions.
```

## Context

A [`context`](#context-name-conventions) is an environment setup for a project that is composed of:

- `project-name` that is the base name of the `*.cproject.yml` file.
- `.build-type` that defines typically build-specific settings such as for debug, release, or test.
- `+target-type` that defines typically target-specific settings such as device, board, or usage of processor features.

!!! Note
    - The [`context`](#context-name-conventions) name is used throughout the build process and is reflected in directory names. Even when there is not a fixed limit, keep identifiers short. Recommended is less than 32 characters for the [`context`](#context-name-conventions) name.
    - Blank characters (' ') in the context name are not permitted by CMake.

The section ["Configure Related Projects"](build-overview.md#configure-related-projects)
explains the overall concept of  `target-types` and `build-types`. These `target-types` and `build-types` are defined in the `*.csolution.yml` that defines the overall application for a system.

The settings of the `target-types:` are processed first, followed by the settings of the `build-types:`, which potentially overwrite the `target-types:` settings.

### `target-types:`

The `target-types:` node may include [toolchain options](#toolchain-options), [target selection](#target-selection), and [processor attributes](#processor-attributes):

`target-types:`                                    |              | Content
:--------------------------------------------------|--------------|:------------------------------------
`- type:`                                          | **Required** | The target-type identifier that is used to create the [context](#context-name-conventions) name.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)        |   Optional   | Toolchain selection.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)    |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)|   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)        |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)              |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)        |   Optional   | Control Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)            |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)    |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)        |   Optional   | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)        |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)|   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)        |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`board:`](#board)              | **see Note** | Board specification.
&nbsp;&nbsp;&nbsp; [`device:`](#device)            | **see Note** | Device specification.
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)      |   Optional   | Processor specific settings.
&nbsp;&nbsp;&nbsp; [`context-map:`](#context-map)  |   Optional   | Use different `target-types:` for specific projects.
&nbsp;&nbsp;&nbsp; [`variables:`](#variables)      |   Optional   | Variables that can be used to define project components.
&nbsp;&nbsp;&nbsp; [`memory:`](#memory)            |   Optional   | Add additional off-chip memory available in target hardware.
&nbsp;&nbsp;&nbsp; [`target-set:`](#target-set)    |   Optional   | One or more target-set configurations for projects, images, and debugger.
&nbsp;&nbsp;&nbsp; [`west-defs:`](#west-defs)      |   Optional   | Defines in `CMake` format for the [west build](#west-build) system.

!!! Note
    Either `device:` or `board:` is required.

### `build-types:`

The `build-types:` node may include [toolchain options](#toolchain-options):

`build-types:`                                     |              | Content
:--------------------------------------------------|--------------|:------------------------------------
`- type:`                                          | **Required** | The build-type identifier that is used to create the [context](#context-name-conventions) name.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)        |   Optional   | Toolchain selection.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)    |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)|   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)        |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)              |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)            |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)    |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)        |   Optional   | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)        |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)|   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)        |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`context-map:`](#context-map)  |   Optional   | Use different `build-types:` for specific projects.
&nbsp;&nbsp;&nbsp; [`variables:`](#variables)      |   Optional   | Variables that can be used to define project components.
&nbsp;&nbsp;&nbsp; [`west-defs:`](#west-defs)      |   Optional   | Defines in `CMake` format for the [west build](#west-build) system.

**Example:**

```yml
target-types:
  - type: Board                  # target-type name, used in context with: +Board
    board: NUCLEO-L552ZE-Q       # board specifies indirectly also the device

  - type: Production-HW          # target-type name, used in context with: +Production-HW
    device: STM32L552RC          # specifies device

build-types:
  - type: Debug                  # build-type name, used in context with: .Debug
    optimize: none               # specifies code optimization level
    debug: debug                 # generates debug information

  - type: Test                   # build-type name, used in context with: .Test
    optimize: size
    debug: on
```

The `board:`, `device:`, and `processor:` settings are used to configure the code translation for the toolchain. These
settings are processed in the following order:

1. `board:` relates to a BSP software pack that defines board parameters, including the
   [mounted device](https://arm-software.github.io/CMSIS_5/Pack/html/pdsc_boards_pg.html#element_board_mountedDevice).
   If `board:` is not specified, a `device:` must be specified.
2. `device:` defines the target device. If `board:` is specified, the `device:` setting can be used to overwrite the
   device or specify the processor core used.
3. `processor:` overwrites default settings for code generation, such as endianness, TrustZone mode, or disabling Floating
   Point code generation.

**Examples:**

```yml
target-types:
  - type: Production-HW
    board: NUCLEO-L552ZE-Q    # hardware is similar to a board (to use related software layers)
    device: STM32L552RC       # but uses a slightly different device
    processor:
      trustzone: off          # TrustZone disabled for this project
```

```yml
target-types:
  - type: Production-HW
    board: FRDM-K32L3A6       # NXP board with K32L3A6 device
    device: :cm0plus          # use the Cortex-M0+ processor
```

### `target-set:`

The `target-set:` specifies for a `target-type:` the projects and images to include along with the configuration settings for a debug adapter. It is possible to specify one or more `set` configurations per `target-type`.
Refer to the section ["Configure Related Projects"](build-overview.md#configure-related-projects) that describes how to combine multiple projects into an application.

`target-set:`                                         |              | Content
:-----------------------------------------------------|--------------|:------------------------------------
`- set:`                                              | **Required** | Start of a configuration, optional with name. The default set is unnamed.
&nbsp;&nbsp;&nbsp; `info:`                            |   Optional   | Brief description of the configuration.
&nbsp;&nbsp;&nbsp; [`images:`](#images)               |   Optional   | List of images that belong to this set.
&nbsp;&nbsp;&nbsp; [`debugger:`](#debugger)           |   Optional   | Debugger configuration for this set.

#### `images:`

The `images:` node under `target-set:` specifies the projects with build-type and optional additional [images](#images) that belong to this configuration of the target set.

`images:`                                             |              | Content
:-----------------------------------------------------|--------------|:------------------------------------
`- project-context:`                                  |   Optional   | Project output or with optional build-type to use. Format: `<project_name>[.buid_type]`
&nbsp;&nbsp;&nbsp; `image:`                           |   Optional   | Additional image file to load.
&nbsp;&nbsp;&nbsp; [`load:`](#load)                   |   Optional   | Load mode of the image file for programmers and debug tools.
&nbsp;&nbsp;&nbsp; `info:`                            |   Optional   | Brief description of the image file.
&nbsp;&nbsp;&nbsp; [`type:`](#type)                   |   Optional   | Specifies an explicit file of the image type.
&nbsp;&nbsp;&nbsp; `load-offset:`                     |   Optional   | Offset applied when loading a image file with `type: bin` (pyOCD only).
&nbsp;&nbsp;&nbsp; [`device:`](#device)               |   Optional   | For image files a pname can be specified to denote the processor that runs the image.

!!! Notes
    - Each list node must contain either `image:` or `project-context:` (but not both).
    - The `type:` specification is only accepted for an `image:` file.
    - The `project-context:` can also refer to a [west](#west) `project-id:` with build type.

#### `load:`

Specifies the load mode for an image file. This information is used by programmers and debug tools.

`load:`                              | Description
:------------------------------------|:-------------
&nbsp;&nbsp;&nbsp; `image+symbols`   | Load both the binary image and the debug symbol information (default for `project-context` and `image` with file type elf).
&nbsp;&nbsp;&nbsp; `symbols`         | Load only the debug symbol information.
&nbsp;&nbsp;&nbsp; `image`           | Load only the binary image (default `image` for other file types).
&nbsp;&nbsp;&nbsp; `none`            | No content is loaded for this image, however it is part of the build process.

#### `type:`

With `type:` an explicit file type can be specified which is required for unknown file extensions. The explicit file type overwrites the auto-detection of file types based on the file extension.

`type:`           | Auto-detected Extension | Description
:-----------------|:------------------------|:-------------
`- lib`           | `.lib`, `.a`            | Library or archive.
`- elf`           | `.axf`, `.elf`          | Executable in ELF format.
`- hex`           | `.h386`, `.hex`         | Intel HEX file in HEX-386 format.
`- bin`           | `.bin`                  | Binary image.

**Example:**

```yml
solution:
    :

  target-types:
    - type: MCXN947
      board: FRDM-MCXN947
      device: NXP::MCXN947VDF
      target-set:
        - set:                             # without id, <default> set
          debugger:
            name: ST-Link
          images:
          - project-context: core1.Debug
          - project-context: core0.Release
        - set: production                  # id for this target set
          images:
          - project-context: core1.Release
            device: :core1                 # specify the pname that runs the image
          - project-context: core0.Release
            device: :core0                 # specify the pname that runs the image

    - type: Custom-HW
      device: NXP::MCXN947VDF
      target-set:
        - set:                             # without id, <default> set
          debugger:
            name: ULINKplus
            protocol: swd
          images:
          - project-context: core1.Debug
          - project-context: core0.Release
          - image: Zephry.elf
            load: image

  build-types:
    - type: Debug
      debug: on
      optimize: debug

    - type: Release
      debug: off
      optimize: balanced

  projects:
    - project: ./cm33_core1/core1.cproject.yml
    - project: ./cm33_core0/core0.cproject.yml
```

### `variables:`

The `variables:` node defines *key/value* pairs in the `*.csolution.yml` file. Using `$<key>$` in `*.cproject.yml` and `*.clayer.yml` files expands to the *value* of the variable. The variable `$<key>$` can be used in the following nodes: [`layers:`](#layers), [`define:`](#define), [`define-asm:`](#define-asm), [`add-path:`](#add-path), [`add-path-asm:`](#add-path-asm), [`misc:`](#misc), [`files:`](#files), and [`executes:`](#executes). The `<key>:` name format `<type>-Layer` is a convention that references [layer-type](#layer-type). In this case the `copied-from:` can be used to describe the orginal source of a layer (typically a path in a software pack).

`variables:`                         | Description
:------------------------------------|:-------------
&nbsp;&nbsp;&nbsp; `<key>:`          | `<key>:` specifies a variable name with value.
&nbsp;&nbsp;&nbsp; `copied-from:`    | Descriptive text that documents the source of a layer. 

**Example:**

With variables that are defined in the `*.csolution.yml` file, a `*.cproject.yml` file requires no modifications when new `target-types:` are introduced.  The required `layers:` could be instead specified in the `*.csolution.yml` file using a new node `variables:`.

*Example.csolution.yml*

```yml
solution:
  target-types:
    - type: NXP Board
      board: IMXRT1050-EVKB
      variables:
        - Socket-Layer: $SolutionDir()$/Socket/FreeRTOS+TCP/Socket.clayer.yml
        - Board-Layer:  $SolutionDir()$/Board/IMXRT1050-EVKB/Board.clayer.yml

    - type: ST Board
      board: B-U585I-IOT02A
      variables:
        - Socket-Layer: $SolutionDir()$/Socket/WiFi/Socket.clayer.yml
        - Board-Layer: $SolutionDir()$/Board/B-U585I-IOT02A/Board.clayer.yml
          copied-from: ${CMSIS_PACK_ROOT}/Keil/B-U585I-IOT02A_BSP/2.0.0/CMSIS/Board/
```

*Example.cproject.yml*

```yml
  layers:
    - layer: $Socket-Layer$
      type: Socket

    - layer: $Board-Layer$      # no `*.clayer.yml` specified. Compatible layers are listed
      type: Board               # layer of type `Board` is expected
```

#### Variable `west-board` 

[West Build](#west-build) uses a different schema for the [board name](#board-name-conventions). However several board names can be mapped to `west` tool. By default, the variable `$west-board$` holds the `board_name` (converted to lower-case, `-` replaced by `_`) of the current active target type as default for the [west:](#west) node. However, as some CMSIS boards names do not map, the variable `$west-board$` can be defined as shown below.

*Example.csolution.yml*

```yml
solution:
  target-types:
    - type: Alif Board
      board: Alif Semiconductor::DevKit-E7
      variables:
        - west-board: alif_e7_dk_rtss_he              # explicit west board name

    - type: ST Board
      board: STMicroelectronics::STM32H7B3I-DK        # $west-board$ set to `stm32h7b3i_dk`
```

### `context-map:`

The `context-map:` node allows for a specific `project-name` the remapping of `target-types:` and/or `build-types:` to a different `context:` which enables:

- Integrating an existing `*.cproject.yml` file in a different `*.csolution.yml` file that uses different `build-types:` and/or `target-types:` for the overall application.
- Defines how different `*.cproject.yml` files of a `*.csolution.yml` are to the binary image of the final target (needs reflection in cbuild-idx.yml).

The `context-map:` node lists a remapping of the [`context-name`](#context-name-conventions) for a `project-name` and specific `target-types:` and `build-types:`.

`context-map:`                                     |              | Content
:--------------------------------------------------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <context-name>`              | **Required** | Specify an alternative [`context-name`](#context-name-conventions) for a project.

For the `context-map:` it is required to specify the `<project-name>` as part of the [`context-name`](#context-name-conventions). This project will use a different `.build-type` and/or `+target-type` as applied in the [`context-name`](#context-name-conventions). This remapping of the context applies for the specific type in the `build-types:` or `target-types:` list.

**Example 1:**

This application combines two projects for a multi-processor device, but the project `HelloCM7` requires a different setting for the build-type name `Release` as this enables different settings within the `*.cproject.yml` file.

```yml
  target-types:
    - type: DualCore
      device: MyDualCoreDevice

  build-types:
    - type: Release                        # When applying build-type name 'release':
      context-map:
        - HelloCM7.flex_release            # project HelloCM7 uses build-type name "flex_release" instead of "release"

  projects:
    - project: ./CM7/HelloCM7.cproject.yml
    - project: ./CM4/HelloCM4.cproject.yml
```

**Example 2:**

The following example uses three projects: `Demo`, `TFM`, and `Boot`. The project `TFM` should always be built using the context `TFM.Release+LibMode`. For the target-type name `Board`, the Boot project requires the `+Flash` target, but any build type could be used.

```yml
  target-types:
    - type: Board                          # When applying target-type: 'Board':
      context-map:
        - TFM.Release+LibMode              # for project TFM use build-type: Release, target-type: LibMode
        - Boot+Flash                       # for project Boot use target-type: Flash
      board: B-U585I-IOT02A
    - type: AVH                            # When applying target-type: 'AVH':
      context-map:
        - context: TFM.Release+LibMode     # for project TFM use build-type: Release, target-type: LibMode
      device: ARM::SSE-300-MPS3

  projects:
    - project: ./App/Demo.cproject.yml
    - project: ./Security/TFM.cproject.yml
    - project: ./Loader/Boot.cproject.yml
```

## Conditional Build

It is possible to include or exclude *items* of a [*list node*](#order-of-list-nodes) in the build process.

- [`for-compiler:`](#for-compiler) includes *items* only for a compiler toolchain.
- [`for-context:`](#for-context) includes *items* only for a [*context*](#context-name-conventions) list.
- [`not-for-context:`](#not-for-context) excludes *items* for a [*context*](#context-name-conventions) list.

!!! Note
    `for-context:` and `not-for-context:` are mutually exclusive, only one occurrence can be specified for a *list node*.

### `for-compiler:`

Depending on a [compiler](#compiler) toolchain it is possible to include *list nodes* in the build process.

**Examples:**

```yml
for-compiler: AC6@6.16               # add item for Arm Compiler version 6.16 only

for-compiler: GCC                    # for GCC Compiler (any version)
```

### `for-context:`

A [*context*](#context-name-conventions) list that adds a list-node for specific `target-type` and/or `build-type` names.

### `not-for-context:`

A [*context*](#context-name-conventions) list that removes a list-node for specific `target-types:` and/or `build-types:`.

### Context List

It is also possible to provide a [`context`](#context-name-conventions) list with:

```yml
  - [.build-type][+target-type]
  - [.build-type][+target-type]
```

**Examples:**

```yml
for-context:
  - .Test                            # add item for build-type: Test (any target-type)

for-context:                         # add item
  - .Debug                           # for build-type: Debug and
  - .Release+Production-HW           # build-type: Release / target-type: Production-HW

not-for-context:  +Virtual           # remove item for target-type: Virtual (any build-type)
not-for-context:  .Release+Virtual   # remove item for build-type: Release with target-type: Virtual
```

### Usage

The keyword `for-context:` and `not-for-context:` can be used for the following *list nodes*:

List Node                                  | Description
:------------------------------------------|:------------------------------------
[`- project:`](#projects)                  | At `projects:` level it is possible to control inclusion of project.
[`- layer:`](#layers)                      | At `layers:` level, it is possible to control the inclusion of a software layer.

The keyword `for-context:`, `not-for-context:`, and `for-compiler:` can be applied to the following *list nodes*:

List Node                                  | Description
:------------------------------------------|:------------------------------------
[`- component:`](#components)              | At `components:` level, control the inclusion of a software component.
[`- group:`](#groups)                      | At `groups:` level, control the inclusion of a file group.
[`- setup:`](#setups)                      | At `setups:` level, define toolchain-specific options that apply to the whole project.
[`- file:`](#files)                        | At `files:` level, control the inclusion of a file.

The inclusion of a *list node* is processed with this hierarchy from top to bottom:

`project` --> `layer` --> `component`/`group` --> `file`

In other words, the restrictions specified by `for-context:` or `not-for-context` for a *list node* are applied to it child nodes. Child *list nodes* inherit the restrictions from their parent.

!!! Note
    With `for-context:` and `not-for-context:` the `project-name` of a [context](#context-name-conventions) cannot be applied. The `context` name must, therefore, start with `.` to refer to the `build-type:` or `+` to refer to the `target-type:`.

#### Regular Expressions

With `for-context:` and `not-for-context:` a [regular expression](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_03) can be used to refer to multiple context names. When a context name starts with the character `\` the [regular expression](https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html#tag_09_03) expansion is enabled. The character `\` itself is not part of the sequence.

**Example:**

The following project is only included when the `build-type:` of a context contains `Test`.

```yml
  build-types:
    - Debug-Test:         # Debug build with Test functionality
       :
    - Test-Release:       # Release build with Test functionality
       :
    - Debug:
       :
    - Release:
       :

  project: Test.cproject.yml
    - for-context: \.*Test*`
```

## Multiple Projects

The section ["Configure Related Projects"](build-overview.md#configure-related-projects) describes the
organization of multiple projects. The file `*.csolution.yml` describes the relationship of these projects and may also re-map
`target-types:` and `build-types:` for projects using [`context-map:`](#context-map).

### `projects:`

The YAML structure of the section `projects:` is:

`projects:`                                               |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
[`- project:`](#project)                                  |   Optional   | Path to the project file.
&nbsp;&nbsp;&nbsp; [`west:`](#west)                       |   Optional   | Enable West "build orchestration wrapper" for Zephyr projects.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include project for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude project for a list of *build* and *target* types.

!!! Notes: `project` and `west` nodes are mutually exclusive (ToDo)

**Examples:**

This example uses two projects that are built in parallel using the same `build-type:` and `target-type:`.  Such a setup is typical for multi-processor systems.

```yml
  projects:
    - project: ./CM0/CM0.cproject.yml      # include project for Cortex-M0 processor
    - project: ./CM4/CM4.cproject.yml      # include project for Cortex-M4 processor
```

This example uses multiple projects but with additional controls.

```yml
  projects:
    - project: ./CM0/CM0.cproject.yml      # specify cproject.yml file
      for-context: +CM0-Addon              # build only when 'target-type: CM0-Addon' is selected

    - project: ./CM0/CM0.cproject.yml      # specify cproject.yml file
      for-context: +CM0-Addon              # specify use case

    - project: ./Debug/Debug.cproject.yml  # specify cproject.yml file
      not-for-context: .Release            # generated for any 'build-type:' except 'Release'

    - west:                                # enable west build orchestration wrapper
        app-path: ./blinky                 # specify a zephyr application path
```

## Source File Management

Keyword          | Used in files                    | Description
:----------------|:---------------------------------|:------------------------------------
`groups:`        | `*.cproject.yml`, `*.clayer.yml` | Start of a list that adds [source groups and files](#source-file-management) to a project or layer.
`layers:`        | `*.cproject.yml`                 | Start of a list that adds software layers to a project.
`components:`    | `*.cproject.yml`, `*.clayer.yml` | Start of a list that adds software components to a project or layer.

### `groups:`

The `groups:` keyword specifies a list that adds [source groups and files](#source-file-management) to a project or layer:

`groups:`                                                 |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
`- group:`                                                | **Required** | Name of the group.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include group for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude group for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)       |   Optional   | Include group for a list of compilers.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)           |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)       |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)               |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)           |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)       |   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)               |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                       |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`groups:`](#groups)                   |   Optional   | Start a nested list of groups.
&nbsp;&nbsp;&nbsp; [`files:`](#files)                     |   Optional   | Start a list of files.

**Example:**

See [`files:`](#files) section.

### `files:`

Add source files to a project.

`files:`                                                  |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
`- file:`                                                 | **Required** | Name of the file.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include file for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude file for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)       |   Optional   | Include file for a list of compilers.
&nbsp;&nbsp;&nbsp; [`category:`](#filename-extensions)    |   Optional   | Explicit file category to overwrite [filename extension](#filename-extensions) assignment.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)           |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)       |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)               |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)           |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)       |   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)               |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                       |   Optional   | Literal tool-specific controls.

!!! Note
    It is also possible to specify a [Linker Script](build-overview.md#linker-script-management). Files with the extension `.sct`, `.scf`, `.ld`, and `.icf` are recognized as Linker Script files.

**Example:**

Add source files to a project or a software layer. Used in `*.cproject.yml` and `*.clayer.yml` files.

```yml
groups:
  - group:  "Main File Group"
    not-for-context:                     # includes this group not for the following:
      - .Release+Virtual                 # build-type 'Release' and target-type 'Virtual'
      - .Test-DSP+Virtual                # build-type 'Test-DSP' and target-type 'Virtual'
      - +Board                           # target-type 'Board'
    files:
      - file: file1a.c
      - file: file1b.c
        define:
          - a: 1
        undefine:
          - b
        optimize: size

  - group: "Other File Group"
    files:
      - file: file2a.c
        for-context: +Virtual               # include this file only for target-type 'Virtual'
        define:
          - test: 2
      - file: file2a.c
        not-for-context: +Virtual           # include this file not for target-type 'Virtual'
      - file: file2b.c

  - group: "Nested Group"
    groups:
      - group: Subgroup1
        files:
          - file: file-sub1-1.c
          - file: file-sub1-2.c
      - group: Subgroup2
        files:
          - file: file-sub2-1.c
          - file: file-sub2-2.c
```

It is also possible to include a file group for a specific compiler using [`for-compiler:`](#for-compiler) or a specific
target-type and/or build-type using [`for-context:`](#for-context) or [`not-for-context:`](#not-for-context).

```yml
groups:
  - group:  "Main File Group"
    for-compiler: AC6                    # includes this group only for Arm Compiler 6
    files:
      - file: file1a.c
      - file: file2a.c

  - group:  "Main File Group"
    for-compiler: GCC                    # includes this group only for GCC Compiler
    files:
      - file: file1b.c
      - file: file2b.c
```

Using `category:` allows to specify pre-include files that are project-wide or related only to the `group:`.

- A global pre-include file is added to the compiler command line for all modules of the whole project (globally).

```yml
 - group:  "Main File Group"
   files:
     - file: SystemDefinitions.h
       category: preIncludeGlobal
```

- A local pre-include file is added to the compiler command line for all modules of a group (locally).

```yml
 - group:  "Group 2"
   files:
     - file: MyDefinitions.h
       category: preIncludeLocal
```

### `layers:`

Add a software layer to a project. Used in `*.cproject.yml` files.

`layers:`                                                 |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
[`- layer:`](#layer)                                      |   Optional   | Path to the `*.clayer.yml` file that defines the layer.
&nbsp;&nbsp;&nbsp; [`type:`](#layer-type)                 |   Optional   | Refers to an expected layer type.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include layer for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude layer for a list of *build* and *target* types.

**Example:**

```yml
  layers:
    # Socket
    - layer: ./Socket/FreeRTOS+TCP/Socket.clayer.yml
      for-context:
        - +IP-Stack
    - layer: ./Socket/WiFi/Socket.clayer.yml
      for-context:
        - +WiFi
    - layer: ./Socket/VSocket/Socket.clayer.yml
      for-context:
        - +AVH

    # Board
    - layer: ./Board/IMXRT1050-EVKB/Board.clayer.yml
      for-context:
        - +IP-Stack
        # - +WiFi
    - layer: ./Board/B-U585I-IOT02A/Board.clayer.yml
      for-context:
        - +WiFi
    - layer: ./Board/AVH_MPS3_Corstone-300/Board.clayer.yml
      for-context:
        - +AVH
```

#### `layer:` `type:`

The `layer:` - `type:` is used in combination with the meta-data of the [`connections:`](#connections) to check the list of available `*.clayer.yml` files for matching layers. Instead of an explicit `layer:` node that specifies a `*.clayer.yml` file, the `type:` is used to search for matching layers with the `csolution` command `list layers`.

**Example:**

```yml
  layers:
    - type: Socket              # search for matching layers of type `Socket`

    - type: Board               # search for matching layers of type `Board`
```

When combined with [`variables:`](#variables) it is possible to define the required `*.clayer.yml` files at the level of the `*.csolution.yml` file.  Refer to [`variables:`](#variables) for an example.

### `components:`

Add software components to a project or a software layer. Used in `*.cproject.yml` and `*.clayer.yml` files.

`components:`                                             |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
`- component:`                                            | **Required** | Name of the software component.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include component for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude component for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)           |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)       |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)               |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`link-time-optimize:`](#link-time-optimize) |   Optional   | Enable optimization at linker level.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for C/C++ code generation.
&nbsp;&nbsp;&nbsp; [`define-asm:`](#define-asm)           |   Optional   | Define symbol settings for Assembler code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths for C/C++ source files.
&nbsp;&nbsp;&nbsp; [`add-path-asm:`](#add-path-asm)       |   Optional   | Additional include file paths for assembly source files.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)               |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                       |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`instances:`](#instances)             |   Optional   | Add multiple instances of component configuration files (default: 1)

**Example:**

```yml
  components:
    - component: ARM::CMSIS:RTOS2:FreeRTOS&Cortex-M

    - component: ARM::RTOS&FreeRTOS:Config&CMSIS RTOS2
    - component: ARM::RTOS&FreeRTOS:Core&Cortex-M
    - component: ARM::RTOS&FreeRTOS:Event Groups
    - component: ARM::RTOS&FreeRTOS:Heap&Heap_5
    - component: ARM::RTOS&FreeRTOS:Stream Buffer
    - component: ARM::RTOS&FreeRTOS:Timers

    - component: ARM::Security:mbed TLS
      define:
        - MBEDTLS_CONFIG_FILE: "aws_mbedtls_config.h"
    - component: AWS::FreeRTOS:backoffAlgorithm
    - component: AWS::FreeRTOS:coreMQTT
    - component: AWS::FreeRTOS:coreMQTT Agent
    - component: AWS::FreeRTOS:corePKCS11&Custom
      define:
        - MBEDTLS_CONFIG_FILE: "aws_mbedtls_config.h"
```

!!! Note
    The name format for a software component is described under  [Name Conventions - Component Name Conventions](#component-name-conventions).

### `instances:`

Allows to add multiple instances of a component and actually applies to configuration files.
For detailed description refer to [Open-CMSIS-Pack specification - Component Instances](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#Component_Instances)

**Example:**

```yml
  components:
    - component: USB:Device
      instances: 2
```

If the user selects multiple instances of the same component, all files with the attribute `config` in the `*.PDSC` file
will be copied multiple times to the project. The name of the component (for example config_mylib.h) will get a postfix
`_n` whereby `n` is the instance number starting with 0.

- Instance 0: `config_usb_device_0.h`
- Instance 1: `config_usb_device_1.h`

The availability of instances in a project can be made public in the `RTE_Components.h` file. The existing way to extend
the `%Instance%` with the instance number `n`.

## West Build

Enable the [West build system integration](build-overview.md#west-build-system-integration) and add [Zephyr](https://www.zephyrproject.org/) application images to the *csolution project*.

### `west:`

Use the command `west build` to generate images from application source code specified in the `west:` node.  When the `west:` node is applied (even with an empty `app-path` source directory list), the [environment variables for the west build system](build-operation.md#west-integration) are created based on the [`compiler:`](#compiler) selection.

`west:`                                                   |              | Content
:---------------------------------------------------------|:-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `app-path:`                            | **Required** | Path to the application source directory.
&nbsp;&nbsp;&nbsp; `project-id:`                          |   Optional   | Project identifier (default: last sub-dir name of `app-path`).
&nbsp;&nbsp;&nbsp; `board:`                               |   Optional   | Board name used for west build invocation (default: [variable `$west-board$`](#variable-west-board)).
&nbsp;&nbsp;&nbsp; [`device:`](#device)                   |   Optional   | Specify the processor core for execution of the generated image (used in `*.cbuild-run.yml`).
&nbsp;&nbsp;&nbsp; [`west-defs:`](#west-defs)             |   Optional   | Defines in `CMake` format. The `west-defs:` from build and target-type are added.
&nbsp;&nbsp;&nbsp; `west-opt:`                            |   Optional   | Options for the `west` tool (default: empty).

### `west-defs:`

Defines for the `west build` commands are specified in CMake format. The `west-defs:` that are defined under the active target and build type are concatinated as follows:

`<west-defs> := <west:west-defs> + <target-type:west-defs> + <build-type:west-defs>`

The information provided with the `west:` and `west-def:` nodes are used to generate the command line for the `west` tool:

```bash
>west <west-opt> build --board <board> --build-dir $SolutionDir()$/out/<project-id>/$TargetType$
            --pristine {auto | always} <app-path> -- <west-defs>
```

!!! Notes
    - The generated image files in the build directory (zephyr/zephyr.elf, zephyr/zephyr.hex) are added to the [`output:`](YML-CBuild-Format.md#output) node in `*.cbuild-run.yml`.
    - The CMSIS build system configures the [environment variables for west](build-operation.md#west-integration).
    - The `--sysbuild` option is not supported as the *csolution project* manages multiple applications and images.
    - The cbuild orchestration instructs `west` calls with `--pristine auto` option. The cbuild option `--rebuild` cleans temporary files before proceeding with a new build.

**Examples:**

ToDo

## Pre/Post Build Steps

The CMSIS-Toolbox supports pre-build and post-build steps that utilize external tools or scripts. Such external commands can be used for various tasks such as:

- pre-process source files.
- add checksums to a binary file.
- combine multiple ELF files into a single image.
- add a timestamp to an image (`always:` ensures execution in every build).
- sign images for a bootloader.

### `executes:`

Execute an external command for pre or post-build steps used in the `*.csolution.yml` and `*.cproject.yml` files. The `input:` and `output:` files are used for dependency checking and scheduling the execution (as a pre-build or post-build step) during the build process of an application (option `--context` is not used).

Other CMake Build scripts may be integrated into the overall build process using the `executes:` node. Refer to [Build Operation - CMake Integration](build-operation.md#cmake-integration) for an example that utilizes a file converter for website images.

The structure of the `executes:` node is:

`executes:`                                 |              | Content
:-------------------------------------------|:-------------|:------------------------------------
`- execute:`                                | **Required** | The identifier is used as a CMake target name and must not contain spaces and special characters; recommended is less than 32 characters.
&nbsp;&nbsp;&nbsp; `run:`                   | **Required** | Command string with the name of the program or script (optionally with path) along with argument string.
&nbsp;&nbsp;&nbsp; `always:`                |  Optional    | When present, the build step always runs and bypasses check for outdated `output:` files.
&nbsp;&nbsp;&nbsp; `input:`                 |  Optional    | A list of input files (may contain [Access Sequences](#access-sequences)).
&nbsp;&nbsp;&nbsp; `output:`                |  Optional    | A list of output files (may contain [Access Sequences](#access-sequences)).
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Run command for a list of *build* and *target* types (only supported in `*.cproject.yml`).
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude run command for a list of *build* and *target* types  (only supported in `*.cproject.yml`).

The `run:` command string uses these sequences to access input files and output files:

`run:` command file access                  | Description
:-------------------------------------------|:-------------------------------------------------
`$input$`                                   | List of all input files separated by semicolon (;) character.
`$input(<n>)$`                              | Input file in the list with index `<n>`; first item is `<n>=0`.
`$output$`                                  | List of all output files separated by semicolon (;) character.
`$output(<n>)$`                             | Output file in the list with index `<n>`; first item is `<n>=0`.

The `run:` command string also accepts these [access sequences](#access-sequences): $Bname$, $Dname$, $Pname$, $BuildType$, $TargetType$, $Compiler$, $Solution$, $Project$. It does not accept [access sequences](#access-sequences) that reference directories or files as this bypasses the [project dependency check](build-overview.md#project-dependency). Instead use the `input:` list to pass files or directories.

Consider the following:

- The `execute:` node is processed by the CMake build system. The order of execution depends on `$input$` and `$output` files and is evaluated by CMake.

- The `execute:` node is processed only for an application build when no `--context` option is specified. The option `--context-set` can be used.

- CMake uses Linux-style path names with `/` characters; it does not accept the Windows-style `\` characters in the `run:` node to specify the location of an executable tool.

- [CMake provides several builtin command-line tools](https://cmake.org/cmake/help/latest/manual/cmake.1.html#run-a-command-line-tool) (copy, checksum, etc.) that run on every Host OS. Consider using these command-line tools instead of Windows or Linux-specific commands. Use `CMake -E help` to list the available commands.

- The base directory for execution is not controlled by the CMSIS-Toolbox and is typically the `tmp` directory. The commands specified by `run:` should be in the path of the Host OS or the path/tool should be passed using an `$input(<n>)$` argument.

- At the `*.csolution.yml` level `for-context:` and `not-for-context:` is not evaluated.

**Examples:**

The tool `gen_image` combines multiple input images. It is called together with the list of [elf files](#output) that are created by the various projects. It runs when `cbuild` executes a solution build (option `--context` is not used).

```yml
solution:                                     # executed as part of a complete solution build
    :
  executes:
    - execute: GenImage                       # generate final download image
      run: gen_image $input$ -o $output$ --sign    # command string
      input:
        - $elf(Application)$                  # combine these project parts
        - $elf(TFM)$
        - $elf(Bootloader)$
      output:
        - $SolutionDir()$/$Solution$.out      # output file name
```

The Windows batch file `KeyGen.bat` converts an input file `keyfile.txt` to a C source file. combines multiple input images. It is called together with the list of [elf files](#output) that are created by the various projects. It runs when `cbuild` executes a solution build (option `--context` is not used).

```yml
project:                                      # executed as part of a project build
  executes:
    - execute: GenerateEncryptionKeys
      run: $input(1)$ $input(0)$ -o $output$
      always:                                 # always generate the keyfile.c as it has a timestamp
      input:
        - $ProjectDir()$/keyfile.txt          # contains the key in text format
        - $SolutionDir()$/KeyGen.bat
      output:
        - $ProjectDir()$/keyfile.c            # output as C source file that is part of this project
```

The built-in CMake command-line tool `copy` is used to copy the `ELF` output file.

```yml
project:                       # executed as part of a project build
  executes:
    - execute: copy-elf
      run: ${CMAKE_COMMAND} -E copy $input$ $output$
      input:
        - $elf()$
      output:
        - $OutDir()$/Project.out
      for-context: .Release
```

For examples of integrating CMake scripts, refer to [Build Operation—CMake Integration](build-operation.md).

## Auto-select Layers

To find compatible layers in software packs, projects and layers can be annotated. The command `csolution list layers` lists compatible layers. This enables [reference applications](ReferenceApplications.md) that work across a range of different hardware targets where:

- The `*.cproject.yml` file of the reference application lists with the `connections:` node the required functionality with `consumes:`.

- The `*.clayer.yml` project part lists with the `connections:` node the implemented functionality with `provides:`.

Example projects that use `connections:` for layer selection:

- [MDK-Middleware examples](https://arm-software.github.io/MDK-Middleware/latest/General/working_with_examples.html) use board layers to run on different hardware boards.

- [Sensor SDK Example](https://github.com/Open-CMSIS-Pack/Sensor-SDK-Example) shows how board layers and shield layers may be used to run different sensor shields on many boards.

- [AWS_MQTT_Demo}(https://github.com/Arm-Examples/AWS_MQTT_Demo) combines the board layer and communication socket layer. Optionally a shield layer can be used to connect WiFi drivers.

### `connections:`

The `connections:` node contains meta-data that describes the compatibility of the `*.cproject.yml` and `*.clayer.yml` project parts.  The `connections:` node lists functionality (drivers, pins, and other software or hardware resources). The node `consumes:` lists required functionality; the node `provides:` is the implemented functionality of that project part.

This works across multiple levels, which means that a `*.clayer.yml` file could also require other functionality using `consumes:`.

The `connections:` node is used to identify compatible software layers. These software layers could be stored in CMSIS software packs using the following structure:

- A reference application described in a `*.cproject.yml` file could be provided in a git repository. This reference application uses software layers that are provided in CMSIS software packs.

A CMSIS Board Support Pack (BSP) contains a configured board layer described in a `*.clayer.yml` file. This software layer is pre-configured for a range of use cases and provides drivers for I2C and SPI interfaces, along with pin definitions and provisions for an Arduino shield.

- For a sensor, a CMSIS software pack contains the sensor middleware and software layer (`*.clayer.yml`) that describes the hardware of the Arduino sensor shield. This shield can be applied to many different hardware boards that provide an Arduino shield connector.

This `connections:` node enables therefore software reuse in multiple ways:

- The board layer can be used by many different reference applications, as the `provided:` functionality enables a wide range of use cases.

The sensor hardware shield and middleware can be used across many different boards that provide an Ardunio shield connector and board layer support.

The structure of the `connections:` node is:

`connections:`                          |              | Description
:------------------------------------|--------------|:------------------------------------
[- `connect:`](#connect)             | **Required** | Lists specific functionality with a brief verbal description

#### `connect:`

The `connect:` node describes one or more functionalities that belong together.

`connect:`                           |              | Description
:------------------------------------|--------------|:------------------------------------
[`set:`](#set)                       |   Optional   | Specifies a *config-id*.*select* value that identifies a configuration option
`info:`                              |   Optional   | Verbal description displayed when this connect is selected
[`provides:`](#provides)             |   Optional   | List of functionality (*key*/*value* pairs) that are provided
[`consumes:`](#consumes)             |   Optional   | List of functionality (*key*/*value* pairs) that are required

The behaviour of the `connect:` node depends on the usage in *csolution project* files.

- In a `cproject.yml` file the `connect:` node is always active.
- In a `clayer.yml` file the `connect:` node is only active if one or more `key` listed under `provides:` is listed under `consumes:` in other active `connect:` nodes. It is also active by default if the `connect:` node has no `provides:` node.

**Example:**

In the example below the `connect` for:

- `Sensor Communication Interface` is only active when the `SENSOR_I2C` is in the `consumes:` list of other active `connect` nodes.
- `Sensor Interrupt` is only active when the `SENSOR_INT` is in the `consumes:` list of other active `connect` nodes.
- `Core Functionality` is always active as it does not have a `provides:` list.

```yml
layer:
  type: Shield

  connections:
    - connect: Sensor Communication Interface
      provides:
        - SENSOR_I2C
      consumes:
        - ARDUINO_UNO_I2C
    - connect: Sensor Interrupt
      provides:
        - SENSOR_INT
      consumes:
        - ARDUINO_UNO_D2
    - connect: Core Functionality
      consumes:
        - CMSIS-RTOS2
```

#### `set:`

Some hardware boards have configuration settings (DIP switch or jumper) that configure interfaces. These settings have an impact on the functionality (for example, hardware interfaces). With `set:` *config-id*.*select*, the possible configuration options are considered when evaluating compatible `*.cproject.yml` and `*.clayer.yml` project parts. The **`csolution` Project Manager** iterates the `connect:` node with a `set:` *config-id*.*select* as described below:

- For each *config-id* only one `connect:` node with a *select* value is active at a time. Each possible *select* value is checked for a matching configuration.

- When project parts have a matching configuration, the `set:` value along with the `info:` is shown to the user. This allows the user to enable the correct hardware options.

Refer to [Example: Sensor Shield](#example-sensor-shield) for a usage example.

#### `provides:`

A user-defined *key*/*value* pair list of functionality that is implemented or provided by a `project:` or `layer:`.

The **`csolution` Project Manager** combines all the *key*/*value* pairs that are listed under `provides:` and matches them with the *key*/*value* pairs that are listed under `consumes:`. For *key*/*value* pairs listed under `provides:` the following rules exist for a match with `consumes:` *key*/*value* pair:

- It is possible to omit the *value*. It matches with an identical *key* listed in `consumes:`
- A *value* is interpreted as a number. Depending on the value prefix, this number must be:
    - when `consumes:` *value* is a plain number identical to this value.
    - when `consumes:` *value* is prefixed with `+`, higher or equal then this *value* or the sum of all *values* in multiple `consumes:` nodes.

#### `consumes:`

A user-defined *key*/*value* pair list of functionality that is required or consumed by a `project:` or `layer:`.

For *key*/*value* pairs listed under `consumed:` the following rules exist:

- When no *value* is specified, it matches with any *value* of an identical *key* listed under `provides:`.
- A *value* is interpreted as a number. This number must be identical in the `provides:` value pair.
- A *value* that is prefixed with `+` is interpreted as a number that is added together in case that the same *key* is listed multiple times under `consumes:`. The sum of this value must be lower or equal to the *value* upper limit of the `provides:` *key*.

### Example: Board

This `connections:` node of a board layer describes the available interfaces.  The WiFi interface requires a CMSIS-RTOS2 function.

```yml
  connections:                          # describes the functionality of a board layer
    - connect: WiFi interface
      provides:
        - CMSIS-Driver WiFi:
      requires:
        - CMSIS-RTOS2:

    - connect: SPI and UART interface
      provides:
        - CMSIS-Driver SPI:
        - CMSIS-Driver UART:
```

### Example: Simple Project

This shows the `connections:` node of a complete application project composed of two software layers.

*MyProject.cproject.yml*

```yml
  connections:
    - connect: all resources
      provides:
        - RTOS2:          # implements RTOS2 API interface
      consumes:
        - IoT_Socket:     # requires IoT_Socket interface
        - STDOUT:         # requires STDOUT interface
        - Heap:  +30000   # requires an additional 30000 bytes memory heap
  :
  layers:
    - layer: MySocket.clayer.yml
    - layer: MyBoard.clayer.yml
```

*MySocket.clayer.yml*

```yml
  connections:
    - connect:
      consumes:
        - RTOS2:          # requires RTOS2 API interface
        - VSocket:        # requires VSocket interface
        - Heap: +20000    # requires an additional 20000 bytes memory heap
      provides:
        - IoT_Socket:     # provides IoT_Socket interface
```

*MyBoard.clayer.yml*

```yml
  connections:
    - connect:
      consumes:
        - RTOS2:
      provides:
        - VSocket:
        - STDOUT:
        - Heap:  65536
```

### Example: Sensor Shield

This sensor shield layer provides a set of interfaces that are configurable.

```yml
  connections:
    - connect: I2C Interface 'Std'
      set:  comm.I2C-Std
      info: JP1=Off  JP2=Off
      provides:
        - Sensor_I2C:
      consumes:
        - Ardunio_Uno_I2C:

    - connect: I2C Interface 'Alt'
      set:  comm.I2C-Alt
      info: JP1=On  JP2=Off
      provides:
        - Sensor_I2C:
      consumes:
        - Ardunio_Uno_I2C-Alt:

    - connect: SPI Interface 'Alt'
      set:  comm.SPI
      info: JP2=On
      provides:
        - Sensor_SPI:
      consumes:
        - Ardunio_Uno_SPI:

    - connect: Sensor Interrupt INT0
      set:  SensorIRQ.0
      info: JP3=Off
      provides:
        - Sensor_IRQ:
      consumes:
        - Ardunio_Uno_D2:

    - connect: Sensor Interrupt INT1
      set:  SensorIRQ.1
      info: JP3=On
      provides:
        - Sensor_IRQ:
      consumes:
        - Ardunio_Uno_D3:
```

## Debugger Configuration

The `debugger:` node specified under the [`target-set:`](#target-set) in the *csolution project* configures the debugger.

!!! Notes
    - Packs may provide a default configuration for a debugger connection to a device or board. 
    - Serveral settings are optional and the default settings are specific to the selected debug adapter.
    - The complete debugger settings including default values are listed in `debugger:` node of the [`*.cbuild-run.yml` file](YML-CBuild-Format.md#run-and-debug-management).

### `debugger:`

`debugger:`                                               |             | Content
:---------------------------------------------------------|-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `name:`                                |**Required** | Identifies the debug adapter.
&nbsp;&nbsp;&nbsp; `*:`                                   |  Optional   | Other debugger specific options can be used as documented below.

The command `csolution list debuggers` outputs the `name:` of the supported debug adatpers; using the option `--verbose` extends the list with alias names that are also accepted as `name:`  There are five different debug adapter categories:

Debug Adapter `name:`           | Description
:-------------------------------|:-----------------------------------------------
[`<adapter>@pyOCD`](#pyocd)     | Debug Adapters that interface via pyOCD ([CMSIS-DAP](https://arm-software.github.io/CMSIS-DAP/latest/index.html) and ST-Link).
[`<adapter>@Arm-Debugger`](#arm-debugger) | Debug Adapters that interface via the Arm-Debugger.
[`Arm-FVP`](#arm-fvp)           | [FVP](https://arm-software.github.io/AVH/main/simulation/html/index.html) simulation models that represent processor sub-systems.
[`Keil uVision`](#keil-uvision) | [uVision Debugger](http://developer.arm.com/documentation/101407/0543/Debugging) that is integrated in the Keil uVision IDE. 
[`J-Link Server`](#j-link-server) | [Segger J-Link](https://www.segger.com/products/debug-probes/j-link/) debug probes that connect using the J-Link Server.

The [Arm CMSIS Solution](https://marketplace.visualstudio.com/items?itemName=Arm.cmsis-csolution) VS Code extension uses the `debugger:` node to create entries in the files `.vscode/tasks.json` and `.vscode/launch.json` for running and debugging using the specified debug adapter. [`pyOCD`](#pyocd) supports a command-line mode that uses the [`*.cbuild-run.yml`](YML-CBuild-Format.md#run-and-debug-management) file which is created by the CMSIS-Toolbox.

The following sections describe the options available for the different debug adapter types.

### pyOCD 

This section lists the options that are specific to pyOCD that connects to [CMSIS-DAP](https://arm-software.github.io/CMSIS-DAP/latest/index.html) and ST-Link debug adapters. CMSIS-DAP is a standardized protocol used by many different debug adapters. All CMSIS-DAP enabled debug adapters can be accessed with `name: CMSIS-DAP@pyOCD`. A specific debug adapter name such as `name: ULINKplus@pyOCD` provides tailored default settings and a custom configuration dialog in the [Arm CMSIS Solution](https://marketplace.visualstudio.com/items?itemName=Arm.cmsis-csolution) VS Code extension.

[Extended options](pyOCD-Debugger.md#extended-options) are required for rare use cases and further tailor the behaviour of pyOCD.

#### `debugger:` for pyOCD

debugger:                         |             | Description
:---------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `name:`        |**Required** | Identifies the debug adapter with `<adapter>@pyOCD`.
&nbsp;&nbsp;&nbsp; `clock:`       |  Optional   | Debug clock speed in Hz.
&nbsp;&nbsp;&nbsp; `protocol:`    |  Optional   | Debug portocol (jtag or swd).
&nbsp;&nbsp;&nbsp; `dbgconf:`     |  Optional   | Configuration file for device settings such as trace pins and option bytes.
&nbsp;&nbsp;&nbsp; `start-pname:` |  Optional   | Debugger connects at start to this processor.
&nbsp;&nbsp;&nbsp; [`telnet:`](#telnet-for-pyocd) |  Optional   | Telnet service configuration.
&nbsp;&nbsp;&nbsp; [`trace:`](pyOCD-Debugger.md#trace)     |  Optional   | Extended Option: Trace configuration.
&nbsp;&nbsp;&nbsp; [`connect:`](pyOCD-Debugger.md#connect) |  Optional   | Extended Option: Connect mode to hardware.
&nbsp;&nbsp;&nbsp; [`reset:`](pyOCD-Debugger.md#reset)           |  Optional   | Extended Option: Reset type configuration for various cores.
&nbsp;&nbsp;&nbsp; [`load-setup:`](pyOCD-Debugger.md#load-setup) |  Optional   | Extended Option: Reset type and Halt configuration for Load command.

**Examples:**

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  protocol: swd
  clock: 20000000               # 20 MHz
```

```yml
debugger:
  name: ULINKplus
  protocol: jtag
  clock: 10000000               # 10 MHz
  dbgconf: MyHardware.dbgconf
```

#### `telnet:` for pyOCD

!!! Note
    The `telnet:` feature will be implemented until Dec 2025. This section is only a preview.

pyOCD allows to configure for each processor that runs a independent application an Telnet service that connects to character I/O funtions. Character I/O is supported via Semihosting or Segger RTT channel 0.
The `telnet:` node configures:

- Telnet port for connecting remote tools, for example the [Serial Monitor VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-serial-monitor).
- Redirect the output to a `file`, `console`, `port`, or `monitor`. The setting `monitor` connects a telnet `port` to the Serial Monitor in VS Code. The default output file and location is derived from the [`cbuild-run.yml` file](YML-CBuild-Format.md#run-and-debug-management) and uses the extension `<pname>.txt`, format: `<solution-name>+<target-type>.<pname>.out`

`telnet:`                                                 |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
`- mode:`                                                 |**Required** | Redirect output: `off`, `server`, `file`, `console`, `monitor`.
&nbsp;&nbsp;&nbsp; `pname:`                               |  Optional   | Identifies the processor (not requried for single core system).
&nbsp;&nbsp;&nbsp; `port:`                                |  Optional   | Set TCP/IP port number of Telnet Server (default: 4444, 4445, ... incremented for each processor).
&nbsp;&nbsp;&nbsp; `file-in:`                             |  Optional   | Explicit path and name of the telnet input file. Default: ./out/\<solution-name\>+\<target-type\>.\<pname\>.in
&nbsp;&nbsp;&nbsp; `file-out:`                            |  Optional   | Explicit path and name of the telnet output file. Default: ./out/\<solution-name\>+\<target-type\>.\<pname\>.out

Telnet Mode   | Description
:-------------|:--------------------------------------
`server`      | Serial I/O to Telnet server port
`file`        | Serial I/O to text files. Default: `./out/\<solution-name\>+\<target-type\>.\<pname\>.{in \| out}`
`console`     | Serial output to console (Debug console in VS Code). 
`monitor`     | Serial I/O via TCP/IP port to VS Code Serial Monitor.
`off`         | Serial I/O disabled.

!!! Note
    - When no `telnet` node is applied Serial I/O to all processors is disabled.

**Examples:**

Enable Telnet service or a single core system.

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  protocol: swd
  telnet:
    mode: monitor          # Output via TCP/IP port to VS Code Serial Monitor
```

Enable Telnet service or a single core system.

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  protocol: swd
  telnet:
    mode: server
```

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  protocol: swd
  telnet:
    - pname: Core0          # enable Telnet service with default settings
      port: 4444
    - pname: Core1
      mode: console         # route Telnet input/output to console 
    - pname: Core2
      mode: file            # route Telnet input/output to files
```

### Arm Debugger

This section lists options that are specific for the Arm Debugger.

debugger:                            |             | Description
:------------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `name:`           |**Required** | Identifies the debug adapter with `<adapter>@Arm-Debugger`.
&nbsp;&nbsp;&nbsp; `clock-armdbg`    |  Optional   | Debug clock speed. Possible values: auto (default), 50MHz, 33MHz, 25MHz, 20MHz, 10MHz, 5MHz, 2MHz, 1MHz, 500kHz, 200kHz, 100kHz, 50kHz, 20kHz, 10kHz, 5kHz
&nbsp;&nbsp;&nbsp; `protocol-armdbg` |  Optional   | Debug protocol. Possible values: auto (default), JTAG, SWD

**Example:**

```yml
debugger:
  name: CMSIS-DAP@Arm-Debugger
  protocol-armdbg: SWD
  clock-armdbg: 5MHz
```

### Arm-FVP

This section lists options that are specific to the [FVP](https://arm-software.github.io/AVH/main/simulation/html/index.html) simulation models. FVPs are configureable simulation models that are designed for software validation. An FVP represents one or more Arm processors.

#### `debugger:` for Arm-FVP

debugger:                         |             | Description
:---------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `name:`        |**Required** | Identifies the debug adapter with `Arm-FVP`.
&nbsp;&nbsp;&nbsp; `model:`       |  Optional   | Filename (optionally with path) of the FVP executable. Default: `FVP_MPS2_Cortex-M3`.
&nbsp;&nbsp;&nbsp; `config-file:` |  Optional   | Path and filename of the [FVP configuration file](https://arm-software.github.io/AVH/main/simulation/html/using.html).
&nbsp;&nbsp;&nbsp; `args:`        |  Optional   | Miscellaneous [command line arguments](https://arm-software.github.io/AVH/main/simulation/html/using.html).

The following `model:` executables are installed from the [Arm Tools Artifactory](https://www.keil.arm.com/artifacts/#models/arm/avh-fvp). You should use these models in combination with a `pack:` and `device:` as listed under 
["CMSIS-based projects for AVH FVPs"](https://arm-software.github.io/AVH/main/simulation/html/avh_fvp_cmsis.html). The PATH environment variable of your system can define the path to the FVP executable (then only the `model:` name from the list below is required. Optionally an explicit path can be specified in the `model:` node.

`model:`                         | Simulation Model Represents
:--------------------------------|:---------------------------------
`FVP_Corstone 300`               | [Arm Corstone 300](https://developer.arm.com/documentation/100966/1128/Arm--Corstone-SSE-300-FVP) Reference Platform with Cortex-M55
`FVP_Corstone_SSE-300_Ethos-U55` | [Arm Corstone 300](https://developer.arm.com/documentation/100966/1128/Arm--Corstone-SSE-300-FVP) Reference Platform with Cortex-M55 and Ethos-U55
`FVP_Corstone_SSE-300_Ethos-U65` | [Arm Corstone 300](https://developer.arm.com/documentation/100966/1128/Arm--Corstone-SSE-300-FVP) Reference Platform with Cortex-M55 and Ethos-U65
`FVP_Corstone 310`               | [Arm Corstone 310](https://developer.arm.com/documentation/102778) Reference Platform with Cortex-M85 and Ethos-U55.
`FVP_Corstone_SSE-310_Ethos-U65` | [Arm Corstone 310](https://developer.arm.com/documentation/102778) Reference Platform with Cortex-M85 and Ethos-U65.
`FVP_Corstone 315`               | [Arm Corstone 315](https://developer.arm.com/documentation/109395) Reference Platform with Cortex-M85, Ethos-U65, and Mali-C55.
`FVP_Corstone 320`               | [Arm Corstone 320](https://developer.arm.com/documentation/109760) Reference Platform with Cortex-M85, Ethos-U85, and Mali-C55.
`FVP_MPS2_Cortex-M0`             | [Arm Microcontroller Prototyping System with Cortex-M0](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M0)
`FVP_MPS2_Cortex-M0plus`         | [Arm Microcontroller Prototyping System with Cortex-M0+](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M0plus)
`FVP_MPS2_Cortex-M3`             | [Arm Microcontroller Prototyping System with Cortex-M3](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M3)
`FVP_MPS2_Cortex-M4`             | [Arm Microcontroller Prototyping System with Cortex-M4](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M4)
`FVP_MPS2_Cortex-M7`             | [Arm Microcontroller Prototyping System with Cortex-M7](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M7)
`FVP_MPS2_Cortex-M23`            | [Arm Microcontroller Prototyping System with Cortex-M23](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M23)
`FVP_MPS2_Cortex-M33`            | [Arm Microcontroller Prototyping System with Cortex-M33](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M33)
`FVP_MPS2_Cortex-M35P`           | [Arm Microcontroller Prototyping System with Cortex-M35P](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M35P)
`FVP_MPS2_Cortex-M52`            | [Arm Microcontroller Prototyping System with Cortex-M52](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M52)
`FVP_MPS2_Cortex-M55`            | [Arm Microcontroller Prototyping System with Cortex-M55](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M55)
`FVP_MPS2_Cortex-M85`            | [Arm Microcontroller Prototyping System with Cortex-M85](https://developer.arm.com/documentation/100966/latest/MPS2-Platform-FVPs/FVP-MPS2-Cortex-M85)

**Example:**

```yml
debugger:
  name: CMSIS-DAP@Arm-Debugger
  model:  FVP_Corstone_SSE-320
  config-file: ./FVP_Config.txt
  args: --simlimit 600            # stop simulation after 600 seconds
```

### Keil uVision

This section lists options that are specific for the uVision Debugger.

#### `debugger:` for Keil uVision

debugger:                         |             | Description
:---------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `name:`        |**Required** | Identifies the debug adapter with `Keil uVision`.
&nbsp;&nbsp;&nbsp; `uv4:`         |  Optional   | Path to the uVision executable; default: `C:/Keil_v5/UV4/UV4.exe`.

```yml
debugger:
  name: Keil uVision
```

### J-Link Server

This section lists options that are specific for the [Segger J-Link](https://www.segger.com/products/debug-probes/j-link/) debug probes.

[Extended options](JLink-Debugger.md#extended-options) are required for rare use cases and further tailor the behaviour of J-Link Server.

#### `debugger:` for J-Link Server

debugger:                         |             | Description
:---------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `name:`        |**Required** | Identifies the debug adapter with `<adapter>@pyOCD`.
&nbsp;&nbsp;&nbsp; `clock:`       |  Optional   | Debug clock speed in Hz.
&nbsp;&nbsp;&nbsp; `protocol:`    |  Optional   | Debug portocol (jtag or swd).
&nbsp;&nbsp;&nbsp; [`telnet:`](#telnet-for-j-link-server) |  Optional   | Telnet service configuration.
&nbsp;&nbsp;&nbsp; [`trace:`](#trace-for-j-link-server)   |  Optional   | Trace configuration.
&nbsp;&nbsp;&nbsp; [`connect:`](JLink-Debugger.md#connect) |  Optional   | Extended Option: Connect mode to hardware.
&nbsp;&nbsp;&nbsp; [`reset:`](JLink-Debugger.md#reset)           |  Optional   | Extended Option: Reset type configuration for various cores.

**Examples:**

```yml
debugger:
  name: J-Link Server
  clock: 4000000                  # 4000 kHz
  protocol: swd
```

#### `telnet:` for J-Link Server

!!! Note
    The `telnet:` feature will be implemented until Dec 2025. This section is only a preview.

J-Link supports a Telnet service that connects to character I/O funtions. Character I/O is supported via Semihosting (or Segger RTT channel 0). Currently only semihosting is configured for the primary core.

`telnet:`                                                 |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
`- mode:`                                                 |**Required** | Redirect output: `server`, `console`, `monitor`, `off` (default).
&nbsp;&nbsp;&nbsp; `pname:`                               |  Optional   | Identifies the processor (not requried for single core system).
&nbsp;&nbsp;&nbsp; `port:`                                |  Optional   | Set TCP/IP port number of Telnet Server (default: 4444, 4445, ... incremented for each processor).

Telnet Mode   | Description
:-------------|:--------------------------------------
`server`      | Serial I/O to Telnet server port
`console`     | Serial output to console (Debug console in VS Code). 
`monitor`     | Serial I/O via TCP/IP port to VS Code Serial Monitor.
`off`         | Serial I/O disabled.

!!! Note
    - The Telnet service is always enabled for the J-Link GDB Server. The mode `off` turns off the data source (semihosting, Segger RTT).
    - When no `telnet` node is added then Serial I/O to all processors is set to mode `off`.

#### `trace:` for J-Link Server

!!! Note
    The `trace:` feature is Work-In-Progress and will be completed in Q1'26.
  
J-Link supports SWO Trace.

`trace:`                                                  |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `clock:`                               |**Required** | Trace clock frequency in Hz.
&nbsp;&nbsp;&nbsp; `mode:`                                |  Optional   | Set Trace Port transport mode. Currently only `SWO-UART` is accepted.
&nbsp;&nbsp;&nbsp; `port:`                                |  Optional   | Set TCP/IP port number of Trace output (default: 4444).

## Add Memory

Hardware targets may have additional off-chip memory. The `memory:` node that can be added as additional information to a target type.
This information is used for the [Run and Debug Management](YML-CBuild-Format.md#run-and-debug-management) and the [Automatic Linker Script generation](build-overview.md#automatic-linker-script-generation).

### `memory:`

`memory:`                                                 |             | Content
:---------------------------------------------------------|-------------|:------------------------------------
`- name:`                                                 |**Required** | Identifier of the memory.
&nbsp;&nbsp;&nbsp; `access:`                              |**Required** | Access attribute string for the memory (see table below).
&nbsp;&nbsp;&nbsp; `start:`                               |**Required** | Base address of the memory.
&nbsp;&nbsp;&nbsp; `size:`                                |**Required** | Size of the memory.
&nbsp;&nbsp;&nbsp; `pname:`                               |  Optional   | Only accessible by the specified processor.
&nbsp;&nbsp;&nbsp; `algorithm:`                           |  Optional   | Programming algorithm for download.

The table lists the letters and their meaning for use in the access attribute string.

`access:` | Description
:--------:|:------------------
r | Readable
w | Writable
x | eXecutable
s | Secure attribute
n | Non-secure attribute
c | non-secure Callable attribute

**Example:**

```yml
solution:
  :
  target-types:
    - type: MyHardware
      device: STMicroelectronics::STM32F746NGHx
      memory:                                  # Additional memory available in MyHardware
        - name: Ext-Flash                      # Identifier
          access: rx                           # access permission
          start: 0x40000000
          size: 0x200000
          algorithm: Flash/Ext-Flash.flm       # Programming algorithm
```
