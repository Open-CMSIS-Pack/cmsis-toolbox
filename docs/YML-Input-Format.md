# YAML Input Format

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

The following chapter explains the YAML format that is used to describe the `*.yml` input files for the **CSolution**
Project Manager.

**Table of Contents**

- [YAML Input Format](#yaml-input-format)
  - [Name Conventions](#name-conventions)
    - [Filename Extensions](#filename-extensions)
    - [`pack:` Name Conventions](#pack-name-conventions)
    - [`component:` Name Conventions](#component-name-conventions)
    - [`device:` Name Conventions](#device-name-conventions)
    - [`board:` Name Conventions](#board-name-conventions)
    - [`context:` Name Conventions](#context-name-conventions)
  - [Access Sequences](#access-sequences)
  - [Variables](#variables)
  - [Order of List Nodes](#order-of-list-nodes)
  - [Project File Structure](#project-file-structure)
    - [`default:`](#default)
    - [`solution:`](#solution)
    - [`project:`](#project)
    - [`layer:`](#layer)
  - [Directory Control](#directory-control)
    - [`output-dirs:`](#output-dirs)
    - [`generators:`](#generators)
      - [`generators: - options:`](#generators---options)
    - [`rte:`](#rte)
  - [Toolchain Options](#toolchain-options)
    - [`compiler:`](#compiler)
    - [`linker:`](#linker)
    - [`output:`](#output)
  - [Translation Control](#translation-control)
    - [`language-C:`](#language-c)
    - [`language-CPP:`](#language-cpp)
    - [`optimize:`](#optimize)
    - [`debug:`](#debug)
    - [`warnings:`](#warnings)
    - [`define:`](#define)
    - [`undefine:`](#undefine)
    - [`add-path:`](#add-path)
    - [`del-path:`](#del-path)
    - [`misc:`](#misc)
  - [Project Setups](#project-setups)
    - [`setups:`](#setups)
  - [Pack Selection](#pack-selection)
    - [`packs:`](#packs)
    - [`pack:`](#pack)
  - [Target Selection](#target-selection)
    - [`board:`](#board)
    - [`device:`](#device)
  - [Processor Attributes](#processor-attributes)
    - [`processor:`](#processor)
  - [Context](#context)
    - [`target-types:`](#target-types)
    - [`build-types:`](#build-types)
    - [`context-map:`](#context-map)
  - [Conditional Build](#conditional-build)
    - [`for-compiler:`](#for-compiler)
    - [`for-context:`](#for-context)
    - [`not-for-context:`](#not-for-context)
    - [Context List](#context-list)
    - [Usage](#usage)
  - [Multiple Projects](#multiple-projects)
    - [`projects:`](#projects)
  - [Source File Management](#source-file-management)
    - [`groups:`](#groups)
    - [`files:`](#files)
    - [`layers:`](#layers)
      - [`layer:` - `type:`](#layer---type)
    - [`components:`](#components)
    - [`instances:`](#instances)
  - [Pre/Post build steps](#prepost-build-steps)
    - [`execute:`](#execute)
  - [`connections:`](#connections)
    - [`connect:`](#connect)
    - [`set:`](#set)
    - [`provides:`](#provides)
    - [`consumes:`](#consumes)
    - [Example: Board](#example-board)
    - [Example: Simple Project](#example-simple-project)
    - [Example: Sensor Shield](#example-sensor-shield)
  - [Generator (Proposal)](#generator-proposal)
    - [Workflow assumptions](#workflow-assumptions)
    - [Steps for component selection and configuration](#steps-for-component-selection-and-configuration)
    - [Enhance Usability](#enhance-usability)
    - [Workflow](#workflow)
      - [Example Content of `*.cgen.json` (in this case `STM32CubeMX.cgen.json`)](#example-content-of-cgenjson-in-this-case-stm32cubemxcgenjson)
    - [Changes to the \*.GPDSC file](#changes-to-the-gpdsc-file)
    - [Changes to the \*.PDSC file](#changes-to-the-pdsc-file)

## Name Conventions

### Filename Extensions

The **csolution - CMSIS Project Manager** recognizes the [categories](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#FileCategoryEnum) of [files](#files) based on the filename extension in the YAML input files as shown in the table below.

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

### `pack:` Name Conventions

The **csolution - CMSIS Project Manager** uses the following syntax to specify the `pack:` names in the `*.yml` files.

```yml
vendor [:: pack-name [@[~ | >=] version] ]
```

Element      |              | Description
:------------|--------------|:---------------------
`vendor`     | **Required** | Vendor name of the software pack.
`pack-name`  | Optional     | Name of the software pack; wildcards (\*, ?) can be used.
`version`    | Optional     | Version number of the software pack, with `@1.2.3` that must exactly match, `@~1.2`/`@~1` that matches with semantic versioning, or `@>=1.2.3` that allows any version higher or equal.

> **Note:**
>
> When no version is specified, the **csolution - CMSIS Project Manager** only loads the latests version of a software pack. This also applies when wildcards are used in the `pack-name`.

**Examples:**

```yml
- pack:   ARM::CMSIS@5.5.0                  # 'CMSIS' Pack (with version 5.5.0)
- pack:   Keil::MDK-Middleware@>=7.13.0     # 'MDK-Middleware' Software Pack from vendor Keil (with version 7.13.0 or higher, latest available to the tool)
- pack:   Keil::TFM                         # 'TFM' Software Pack from vendor Keil (with latest version available to the tool)
- pack:   AWS                               # All latest versions of Software Packs from vendor 'AWS'
- pack:   Keil::STM*                        # All latest versions of Software Packs that start with 'STM' from vendor 'Keil'
```

### `component:` Name Conventions

The **csolution - CMSIS Project Manager** uses the following syntax to specify the `component:` names in the `*.yml` files.

```yml
[Cvendor::] Cclass [&Cbundle] :Cgroup [:Csub] [&Cvariant] [@[~ | >=]Cversion]
```

Components are defined using the [Open-CMSIS-Pack - `<component>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#element_component). Several parts of a `component` are optional.  For example it is possible to just define a component using `Cclass` and `Cgroup` name. All elements of a component name are summarized in the following table.

Element    |              | Description
:----------|--------------|:---------------------
`Cvendor`  | Optional     | Name of the component vendor as defined in `<components>` element or by the package vendor of the software pack.
`Cclass`   | **Required** | Component class name as defined in `<components>` element of the software pack.
`Cbundle`  | Optional     | Bundle name of the component class as defined in `<bundle>` element of the software pack.
`Cgroup`   | **Required** | Component group name as defined in `<components>` element of the software pack.
`Csub`     | Optional     | Component sub-group name as defined in `<components>` element of the software pack.
`Cvariant` | Optional     | Component sub-group name as defined in `<components>` element of the software pack.
`Cversion` | Optional     | Version number of the component, with `@1.2.3` that must exactly match, `@~1.2`/`@~1` that matches with semantic versioning, or `@>=1.2.3` that allows any version higher or equal.

**Partly defined components**

A component can be partly defined in `csolution` input files (`*.cproject.yml`, `*.clayer.yml`, `*.genlayer.yml`) by omitting `Cvendor`, `Cvariant`, and `Cversion`, even when this are part of the `components` element of the software pack. The component select algorithm resolves this to a fully defined component by:

- when a partly specified component resolves to several possible choices, the tool selects:
  - (a) the default `Cvariant` of the component as defined in the PDSC file. 
  - (b) the component with the higher `Cversion` value.
  - (c) and error message is issued when two identical components are defined by multiple vendors and `Cvendor` is not specified.
- the partly specified component is extended by:
  - version information from the software pack.
  - default variant definition from the software pack.

The fully resolved component name is shown in the [`*.cbuild.yml`](YML-CBuild-Format.md) output file.

**Multiple component definitions are rejected**

- If a component is added more then once in the `csolution` input files and an *error* is issued.
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

The device specifies multiple attributes about the target that ranges from the processor architecture to Flash
algorithms used for device programming. The following syntax is used to specify a `device:` value in the `*.yml` files.

```yml
[ [ Dvendor:: ] Dname] [:Pname]
```

Element       |          | Description
:-------------|----------|:---------------------
`Dvendor`     | Optional | Name (without enum field) of the device vendor defined in `<devices><family>` element of the software pack.
`Dname`       | Optional | Device name (Dname attribute) or when used the variant name (Dvariant attribute) as defined in the \<devices\> element.
`Pname`       | Optional | Processor identifier (Pname attribute) as defined in the `<devices>` element.

> **Note:**
>
> - All elements of a device name are optional which allows to supply additional information, such as the `:Pname` at
>   different stages of the project. However the `Dname` itself is a mandatory element and must be specified in
>   context of the various project files.
> - `Dvendor::` must be used in combination with the `Dname`.

**Examples:**

```yml
device: NXP::LPC1768                       # The LPC1788 device from NXP
device: LPC1788                            # The LPC1788 device (vendor is evaluated from DFP)
device: LPC55S69JEV98                      # Device name (exact name as defined in the DFP)
device: LPC55S69JEV98:cm33_core0           # Device name (exact name as defined in the DFP) with Pname specified
device: :cm33_core0                        # Pname added to a previously defined device name (or a device derived from a board)
```

### `board:` Name Conventions

Evaluation Boards define indirectly a device via the related BSP. The following syntax is used to specify a `board:`
value in the `*.yml` files.

```yml
[vendor::] board_name [:revision] 
```

Element      |              | Description
:------------|--------------|:---------------------
`vendor`     | Optional     | Name of the board vendor defined in `<boards><board>` element of the board support pack (BSP).
`Bname`      | **Required** | Board name (name attribute) as defined in the \<board\> element of the BSP.
`revision`   | Optional     | Board revision (revision attribute) as defined in the \<board\> element of the BSP.

> **Note:**
>
> When a `board:` is specified, the `device:` specification can be omitted, however it is possible to overwrite the device setting in the BSP with an explicit `device:` setting.

**Examples:**

```yml
board: Keil::MCB54110                             # The Keil MCB54110 board (with device NXP::LPC54114J256BD64) 
board: LPCXpresso55S28                            # The LPCXpresso55S28 board
board: STMicroelectronics::NUCLEO-L476RG:Rev.C    # A board with revision specification
```

### `context:` Name Conventions

A `context:` name combines `project-name`, `built-type`, and `target-type` and is used on various places in the CMSIS-Toolbox.  The following syntax is used to specify a `context:` name.

```yml
[project-name][.build-type][+target-type]
```

Element             |              | Description
:-------------------|--------------|:---------------------
`project-name`      |   Optional   | Project name of a project (base name of the *.cproject.yml file).
`.build-type`       |   Optional   | The [`build-type`](#build-types) name that is currently processed (specified with `-type: name`).
`+target-type`      |   Optional   | The [`target-type`](#target-types) name that is currently processed (specified with `-type: name`).

- When `project-name` is omitted, the `project-name` is the base name of the `*.cproject.yml` file.
- When `.build-type` is omitted, it matches with any possible `.build-type`.
- When `+target-type` is omitted, it matches with any possible `+target-type`.

By default the specified `-type: name` of [`build-types:`](#build-types) and [`target-types:`](#target-types) nodes in the `*.csolution.yml` file are directly mapped to the `context` name. 

Using the [`context-map:`](#context-map) node it is possible to assign a different `.build-type` and/or `+target-type` mapping for a specific `project-name`.

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

The `context` name is also used in [`for-context:`](#for-context) and [`not-for-context:`](#not-for-context) nodes that allow to include or exclude items depending on the `context`. In many cases the `project-name` can be omitted as the `context` name is within a specific `*.cproject.yml` file or applied to a specific `*.cproject.yml` file.

## Access Sequences

The following **access sequences** allow to use arguments from the CMSIS Project Manager as arguments of the various
`*.yml` files in the key values for `define:`, `add-path:`, `misc:`, `files:`, and `execute:`. The **access sequences**
can refer in a different project and provide therefore a method to describe project dependencies.

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
`$Solution$`                              | Solution name (base name of the *.csolution.yml file).
`$SolutionDir()$`                         | Path to the directory of the current processed `csolution.yml` file.
`$Project$`                                    | Project name of the current processed `cproject.yml` file.
`$ProjectDir(context)$`                   | Path to the directory of a related `cproject.yml` file.
**Output**                                     | **Access to Output Directories and Files**
`$OutDir(context)$`                            | Path to the output directory of a related project that is defined in the `*.csolution.yml` file.
`$bin(context)$`                          | Path and filename of the binary output file generated by the related context.
`$cmse-lib(context)$`                     | Path and filename of the object file with secure gateways of a TrustZone application generated by the related context.
`$elf(context)$`                          | Path and filename of the ELF/DWARF output file generated by the related context.
`$hex(context)$`                          | Path and filename of the HEX output file generated by the related context.
`$lib(context)$`                          | Path and filename of the library file of the related context.

For a [`context`](#context-name-conventions) the `project-name`, `.build-type`, and `+target-type` are optional; when omitted the current processed context is used. Example: `$ProjectDir()$` is the directory of the current processed `cproject.yml` file.

> **Note:**
> 
> The access sequences below are not completed yet, as they require a change to CMSIS-Build.

Access Sequence                                | Description
:----------------------------------------------|:--------------------------------------
`$Bpack$`                                      | Path to the pack that defines the selected board (BSP).
`$Dpack$`                                      | Path to the pack that defines the selected device (DFP).
`$PackRoot$`                                   | Path to the CMSIS Pack Root directory.
`$Pack(vendor.name)$`                          | Path to specific pack [with latest version ToDo: revise wording]. Example: `$Pack(NXP.K32L3A60_DFP)$`.

**Example:**

For the example below we assume the following `build-type`, `target-type`, and `projects` definitions.

```yml
solution:
  target-types:
    - type: Board               # target-type: Board
      board: NUCLEO-L552ZE-Q    # specifies board

    - type: Production-HW       # target-type: Production-HW
      device: STM32U5X          # specifies device
      
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

The `project: /application/MQTT_AWS.cproject.yml` can now use **Access Sequences** to reference files or directories in
other projects that belong to a solution. For example, these references are possible in the file `MQTT_AWS.cproject.yml`.

The example below uses the `build-type` and `target-type` of the current processed context. In practice this means that
the same `build-type` and `target-type` is used as for the `MQTT_AWS.cproject.yml` project.

```yml
    files:
    - file: $cmse-lib(TFM)$                              # use the symbol output file of the TFM Project
```

The example below uses from the TFM project always `build-type: Debug` and the `target-type: Production-HW`.

```yml
    files:
    - file: `$cmse-lib(TFM.Release+Production-HW)$`      # use the symbol output file of the TFM Project
```

The example below uses the `build-type: Debug`. The `target-type` of the current processed context is used.

> **Note:** 
> 
> `-execute` is scheduled for implementation in CMSIS-Toolbox 2.1 (Q3'23)

```yml
  - execute: Generate Image
    os: Windows                           # on Windows run from
    run: $DPack$/bin/gen_image.exe        # DFP the get_image tool
    arg: -input $elf(TFM.Debug)$ -output $OutDir(TFM.Debug)$
```

The example below creates a `define` that uses the device name.

```yml
groups:
  - group:  "Main File Group"
    define:
      - $Dname$                           # Generate a #define 'device-name' for this file group
```

## Variables

The `variables:` node defines are *key/value* pairs that can be used to refer to `*.clayer.yml` files.  The *key* is the name of the *variable* and can be used  in the following nodes: [`layers:`](#layers), [`define:`](#define), [`add-path:`](#add-path), [`misc:`](#misc), [`files:`](#files), and [`execute:`](#execute)

Using variables that are defined in the `*.csolution.yml` file, a `*.cproject.yml` file requires no modifications when new `target-types:` are introduced.  The required `layers:` could be instead specified in the `*.csolution.yml` file using a new node `variables:`.

**Example:**
   
*Example.csolution.yml*
   
```yml
solution:
  target-types:
    - type: NXP Board
      board: IMXRT1050-EVKB
      variables:
        - Socket-Layer: ./Socket/FreeRTOS+TCP/Socket.clayer.yml
        - Board-Layer:  ./Board/IMXRT1050-EVKB/Board.clayer.yml
  
    - type: ST Board
      board: B-U585I-IOT02A
      variables:
        - Socket-Layer: ./Socket/WiFi/Socket.clayer.yml
        - Board-Layer:  ./Board/B-U585I-IOT02A/Board.clayer.yml
```
   
*Example.cproject.yml*
   
```yml
  layers:
    - layer: $Socket-Layer$
      type: Socket
   
    - layer: $Board-Layer$      # no `*.clayer.yml` specified. Compatible layers are listed
      type: Board               # layer of type `Board` is expected
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
[`default:`](#default)           | Start of `cdefault.yml` file that is used to setup the compiler along with some compiler-specific controls.
[`solution:`](#solution)         | Start of `*.csolution.yml` file that [collects related projects](Overview.md#solution-collection-of-related-projects) along with `build-types:` and `target-types:`.
[`project:`](#project)           | Start of `*.cproject.yml` file that defines files, components, and layers which can be independently translated to a binary image or library.
[`layer:`](#layer)               | Start of `*.clayer.yml` file that contains pre-configured software components along with source files.

### `default:`

When [`cdefault:`](#solution) is specified in the `*.csolution.yml` file, the **csolution - CMSIS Project Manager** uses a file with the name `cdefault.yml` or `cdefault.yaml` to setup 
the compiler along with some specific default controls. The search order for this file is:

- A `cdefault.yml` or `cdefault.yaml` file in the same directory as the `<solution-name>.csolution.yml` file. 
- A `cdefault.yml` or `cdefault.yaml` file in the directory specified by the environment variable [`CMSIS_COMPILER_ROOT`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/installation.md#environment-variables).
- A `cdefault.yml` or `cdefault.yaml` file in the directory [`<cmsis-toolbox-installation-dir>/etc`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/installation.md##etccmake).

The `default:` node is the start of a `cdefault.yml` or `cdefault.yaml` file and contains the following.

`default:`                                            | Content
:-----------------------------------------------------|:------------------------------------
&nbsp;&nbsp; [`compiler:`](#compiler)                 | Toolchain selection.
&nbsp;&nbsp; [`misc:`](#misc)                         | Literal tool-specific controls.

**Example:**

```yml
default:
  compiler: AC6
  misc:
    - ASM:
      - -masm=auto

    - Link:
      - --info sizes --info totals --info unused --info veneers --info summarysizes
      - --map
```

### `solution:`

The `solution:` node is the start of a `*.csolution.yml` file that collects related projects as described in the section
["Project setup for related projects"](Overview.md#project-setup-for-related-projects).

`solution:`                                          |            | Content
:----------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; `created-by:`                     |  Optional  | Identifies the tool that created this csolution project.
&nbsp;&nbsp;&nbsp; `created-for:`                    |  Optional  | Specifies the tool for building this csolution project, i.e. **ctools@1.5.0**
&nbsp;&nbsp;&nbsp; `description:`                    |  Optional  | Brief description text of the solution.
&nbsp;&nbsp;&nbsp; `cdefault:`                       |  Optional  | When specified, the [`cdefault.yml`](#default) file is used to setup compiler specific controls. 
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)          |  Optional  | Overall toolchain selection for the solution.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)      |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)  |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`output-dirs:`](#output-dirs)    |  Optional  | Control the output directories for the build output.
&nbsp;&nbsp;&nbsp; [`generators:`](#generators)      |  Optional  | Control the directory structure for generator output.
&nbsp;&nbsp;&nbsp; [`packs:`](#packs)                |  Optional  | Defines local packs and/or scope of packs that are used.
&nbsp;&nbsp;&nbsp; [`target-types:`](#target-types)  |**Required**| List of target-types that define the target system (device or board).
&nbsp;&nbsp;&nbsp; [`build-types:`](#build-types)    |  Optional  | List of build-types (i.e. Release, Debug, Test).
&nbsp;&nbsp;&nbsp; [`projects:`](#projects)          |**Required**| List of projects that belong to the solution.

**Example:**

```yml
solution:
  created-for: cmsis-toolbox@2.0  # minimum CMSIS-Toolbox version required for project build
  cdefault:                       # use default setup of toolchain specific controls.
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
&nbsp;&nbsp;&nbsp; `description:`                   |  Optional  | Brief description text of the project.
&nbsp;&nbsp;&nbsp; [`output:`](#output)             |  Optional  | Configure the generated output files.
&nbsp;&nbsp;&nbsp; [`generators:`](#generators)     |  Optional  | Control the directory structure for generator output.
&nbsp;&nbsp;&nbsp; [`rte:`](#rte)                   |  Optional  | Control the directory structure for [RTE (run-time environment)](Overview.md#rte-directory-structure) files.
&nbsp;&nbsp;&nbsp; [`packs:`](#packs)               |  Optional  | Defines packs that are required for this project.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)     |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp) |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)         |  Optional  | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`linker:`](#linker)             |  Optional  | Instructions for the linker.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)               |  Optional  | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)             |  Optional  | Preprocessor (#define) symbols for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)         |  Optional  | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)         |  Optional  | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)         |  Optional  | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                 |  Optional  | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`device:`](#device)             |  Optional  | Device setting (specify processor core).
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)       |  Optional  | Processor specific settings.
&nbsp;&nbsp;&nbsp; [`groups:`](#groups)             |**Required**| List of source file groups along with source files.
&nbsp;&nbsp;&nbsp; [`components:`](#components)     |  Optional  | List of software components used.
&nbsp;&nbsp;&nbsp; [`layers:`](#layers)             |  Optional  | List of software layers that belong to the project.
&nbsp;&nbsp;&nbsp; [`connections:`](#connections)   |  Optional  | List of consumed and provided resources.

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

The `layer:` node is the start of a `*.clayer.yml` file and defines a [Software Layer](./Overview.md#software-layers). It can contain the following nodes:

`layer:`                                                     |            | Content
:------------------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; [`type:`](#layer---type)                  |  Optional  | Layer type for combining layers; used to identify [compatible layers](Overview.md#list-compatible-layers).
&nbsp;&nbsp;&nbsp; `description:`                            |  Optional  | Brief description text of the layer.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)              |  Optional  | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)          |  Optional  | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)                  |  Optional  | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                        |  Optional  | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)                  |  Optional  | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                      |  Optional  | Define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)                  |  Optional  | Remove define symbol settings for code generation.     
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)                  |  Optional  | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)                  |  Optional  | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                          |  Optional  | Literal tool-specific controls.
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

The following nodes control the directory structure for **CSolution** based projects.

### `output-dirs:`

Allows to control the directory structure for build output files.  

>**Note:**
> 
> This control is only possible at `csolution.yml` level.  
>
> Only relative paths to the base directory of the `csolution.yml` file are permitted. Use command line options of the `cbuild` tool to redirect the absolute path for this working directory.

`output-dirs:`                     |              | Content
:----------------------------------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `intdir:`       |  Optional    | Specifies the directory for the interim files (temporary or object files).
&nbsp;&nbsp;&nbsp; `outdir:`       |  Optional    | Specifies the directory for the build output files (ELF, binary, MAP files).

The default setting for the `output-dirs:` are:

```yml
  intdir:  $SolutionDir()$/tmp/$Project$/$TargetType$/$BuildType$
  outdir:  $SolutionDir()$/out/$TargetType$
```

**Example:**

```yml
output-dirs:
  intdir: ./tmp2                         # relative path to csolution.yml file
  outdir: ./out/$Project$/$TargetType$   # $BuildType$ no longer part of the outdir    
```

### `generators:`

Allows to control the directory structure for generator output files.  

When no explicit `generators:` is specified, the **CSolution** Project Manager uses as path:

- The `workingDir` defined in the [generators element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_generators_pg.html#element_generator) of the PDSC file.
- When no `workingDir` is defined the default directory `$ProjectDir()$/generated/<generator-id>` is used; `<generator-id>` is defined by the `id` in the generators element of the PDSC file.

The `generators:` node can be added at various levels of the `*.yml` input files. The following order is used:

1. Use `generators:` specification of the `*.clayer.yml` input file, if not exist:
2. Use `generators:` specification of the `*.cproject.yml` input file, if not exist:
3. Use `generators:` specification of the `*.csolution.yml` input file.

>**Notes:**
> 
> - Only relative paths are permitted to support portablity of projects.
> - The location of the `*.yml` file that contains the `generators:` node is the reference for relative paths.

`generators:`                  |            | Content
:------------------------------|------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `base-dir:` |  Optional  | Base directory for unspecified generators; default: `$ProjectDir()$/generated`.
&nbsp;&nbsp;&nbsp; `options:`  |  Optional  | Specific generator options; allows explicit directory configuration for a generator.

> **Note:**
>
> The base directory is extended for each generator with `/<generator-id>`; `<generator-id>` is defined by the `id` in the generators element of the PDSC file.

#### `generators: - options:`

`options:`                     |            | Content
:------------------------------|------------|:------------------------------------
`- generator:`                 |  Optional  | Identifier of the generator tool, specified with `id` in the [generators element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_generators_pg.html#element_generator) of the PDSC file.
&nbsp;&nbsp;&nbsp; `path:`     |  Optional  | Specifies the directory for generated files. Relative paths used the location of the `yml` file as base directory.

**Example:**

```yml
generators:
  base-dir: $SolutionDir()$/MyGenerators      # Path for all generators extended by '/<generator-id>'

  options:
  - generator: Cube                           # for the generator `Cube` use this path
    path:  ./CubeFiles                        # relative path to the *.yml file that contains this setting
```

### `rte:`

Allows to control the directory structure for [RTE (run-time environment)](Overview.md#rte-directory-structure) files.  

>**Notes:**
> 
> - This control is only possible at `*.cproject.yml` level.  
> - Only relative paths are permitted to support portablity of projects.
> - The location of the `*.cproject.yml` file is the reference for relative paths.

`rte:`                         |            | Content
:------------------------------|------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `base-dir:` |  Optional  | Base directory for unspecified generators; default: `$ProjectDir()$/RTE`.

```yml
rte:
  base-dir: $TargetType$/RTE      # Path extended with target-type, results in `$ProjectDir()$/$TargetType$/RTE`
```

## Toolchain Options

The following code translation options may be used at various places such as:

- [`solution:`](#solution) level to specify options for a collection of related projects
- [`project:`](#projects) level to specify options for a project

### `compiler:`

Selects the compiler toolchain used for code generation.
Optionally the compiler can have a version number specification.

Compiler Name                                         | Supported Compiler
:-----------------------------------------------------|:------------------------------------
`AC6`                                                 | Arm Compiler version 6
`GCC`                                                 | GCC Compiler
`IAR`                                                 | IAR Compiler
`CLANG`                                               | CLANG Compiler based on LLVM technlogy (experimental)

**Example:**

```yml
compiler: GCC              # Select GCC Compiler
```

```yml
compiler: AC6@6.18.0       # Select Arm Compiler version 6
```

### `linker:`

The `linker:` node specifies an explicit Linker Script and/or memory regions header file.  It can be applied in `*.cproject.yml` and `*.clayer.yml` files.  If multiple `linker:` nodes are specified an error is issued.

`linker:`                                                   |            |  Content
:-----------------------------------------------------------|:-----------|:--------------------------------
**`- regions:`**                                            |**Optional**|**Path and file name of `regions_<device_or_board>.h`, used to generate a Linker Script.**
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)         |  Optional  |  Include Linker Script for the specified toolchain.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)           |  Optional  |  Include Linker Script for a list of *build* and *target* type names.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)   |  Optional  |  Exclude Linker Script for a list of *build* and *target* type names.
**`- script:`**                                             |**Optional**|**Explicit file name of the Linker Script, overrules files provided with [`file:`](#files) or components.**
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)         |  Optional  |  Include Linker Script for the specified toolchain.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)           |  Optional  |  Include Linker Script for a list of *build* and *target* type names.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)   |  Optional  |  Exclude Linker Script for a list of *build* and *target* type names.
**[`- define:`](#define)**                                  |**Optional**|**Define symbol settings for the linker script file preprocessor.**
&nbsp;&nbsp;&nbsp; [`for-compiler:`](#for-compiler)         |  Optional  |  Apply define settings for the specified toolchain.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)           |  Optional  |  Include define settings for a list of *build* and *target* type names.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)   |  Optional  |  Exclude define settings for a list of *build* and *target* type names.

> **Note:** 
>
> If no `script:` file is specified, compiler specific [linker script template files](Linker-Script-Management.md#linker-script-templates) are used.

### `output:`

Configure the generated output files.

`output:`                              |            | Content
:--------------------------------------|:-----------|:--------------------------------
&nbsp;&nbsp;&nbsp; `base-name:`        |  Optional  | Specify a base name for all output files.
&nbsp;&nbsp;&nbsp; `type:`             |  Optional  | A list of output types for code generation (see list below).

`type:`           | Description
:-----------------|:-------------
`- lib`           | Library or archive. Note: GCC uses the prefix `lib` in the base name for archive files.
`- elf`           | Executable in ELF format. The file extension is toolchain specific.
`- hex`           | Intel HEX file in HEX-386 format.
`- bin`           | Binary image.

The **default** setting for `output:` is:

```yml
output:
  base-name: $Project$   # used the base name of the `cproject.yml` file.
  type: elf              # Generate executeable file.
```

**Example:**

```yml
output:                  # configure output files
  base-name: MyProject   # used for all output files, including linker map file.
  type:
  - elf                  # Generate executeable file.
  - hex                  # generate a HEX file 
  - bin                  # generate a BIN file 
```

Gnerate a **library**:

```yml
output:                  # configure output files
  type: lib              # Generate executeable file.
```

## Translation Control

The following translation control options may be used at various places such as:

- [`solution:`](#solution) level to specify options for a collection of related projects
- [`project:`](#projects) level to specify options for a project
- [`groups:`](#groups) level to specify options for a specify source file group
- [`files:`](#files) level to specify options for a specify source file

> **Note:**
> 
> `define:`, `add-path:`, `del-path:`  and `misc:` are additive. All other keywords overwrite previous settings.

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

### `optimize:`

Generic optimize levels for code generation.

Value                                                 | Code Generation
:-----------------------------------------------------|:------------------------------------
`balanced`                                            | Balanced optimization (default)
`size`                                                | Optimized for code size
`speed`                                               | Optimized for execution speed
`none`                                                | No optimization (provides better debug illusion)

**Example:**

```yml
groups:
  - group:  "Main File Group"
    optimize: none          # optimize this file group for debug illusion
    files:
      - file: file1a.c
      - file: file1b.c
```

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
`off`                                                 | No warning messages generated

### `define:`

Contains a list of symbol #define statements that are passed via the command line to the development tools for C, C++ source files, or the [linker](#linker) script file preprocessor.

`define:`                                                   | Content
:-----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <symbol-name>`                        | #define symbol passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: <value>`               | #define symbol with value passed via command line
&nbsp;&nbsp;&nbsp; `- <symbol-name>: \"<string>\"`          | #define symbol with string value passed via command line

>**Note:**
>
> This control only applies to C and C++ source files (or to the [linker](#linker) script preprocessor).  For assembler source files use the `misc:` node.

**Example:**

```yml
define:                    # Start a list of define statements
  - TestValue: 12          # add symbol 'TestValue' with value 12
  - TestMode               # add symbol 'TestMode'
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

>**Note:**
>
> This control only applies to C and C++ source files.  For assembler source files use the `misc:` node.

**Example:**

```yml
project:
  misc:
    - for-compiler: AC6
      C: [-fshort-enums, -fshort-wchar]
    - for-compiler: GCC
      C: [-fshort-enums, -fshort-wchar]

  add-path:
    - $OutDir(Secure)$                   # add path to secure project's output directory
```

### `del-path:`

Remove include paths (that are defined at the cproject level) from the command line of the development tools.

`del-paths:`                                               | Content
:----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- <path-name>`                         | Named path to be removed; `*` for all

**Examle:**

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
&nbsp;&nbsp;&nbsp; `Library:`              |   Optional   | Applies to the library manager or archiver.

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

The `setups:` node can be used to create setups that are specific to a compiler, target-type, and/or built-type.

### `setups:`

The `setups:` node collects a list of `setup:` notes.  For each context, only one setup will be selected.

The result is a `setup:` that collects various toolchain options and that is valid for all files and components in the
project. It is however possible to change that `setup:` settings on a [`group:`](#groups) or [`file:`](#files) level.

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
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)          |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)              |   Optional   | Define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)          |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)          |   Optional   | Additional include file paths.
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
- Add specific software packs optional with a version specification.
- Provide a path to a local installation of a software pack that is for example project specific or under development.

The  [Pack Name Conventions](#pack-name-conventions) are used to specify the name of the software packs.
The `pack:` definition may be specific to a [`context`](#context) that specifies `target-types:` and/or `build-types:` or provide a local path to a development repository of a software pack.

>**Notes:** 
>
> - By default, the **csolution - CMSIS Project Manager** only loads the latest version of the installed software packs. It is however possible to request specific versions using the `- pack:` node.
>
> - An attempt to add two different versions of the same software pack results in an error.

### `packs:`

The `packs:` node is the start of a pack selection.

`packs:`                                              | Content
:-----------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; [`- pack:`](#pack)                 | Explicit pack specification (additive)

### `pack:`

The `pack:` list allows to add specific software packs, optional with a version specification. The version number can
have also the format `@~1.2`/`@~1` that matches with semantic versioning.

`pack:`                                                     | Content
:-----------------------------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `path:`                                  | Explicit path name that stores the software pack
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)           | Include pack for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context)   | Exclude pack for a list of *build* and *target* types.

**Example:**

```yml
packs:                                  # start section that specifics software packs
  - pack: AWS                           # use packs from AWS
  - pack: NXP::*K32L*                   # use packs from NXP relating to K32L series (would match K32L3A60_DFP + FRDM-K32L3A6_BSP)
  - pack: ARM                           # use packs from Arm

  - pack: Keil::Arm_Compiler            # add latest version of Keil::Arm_Compiler pack
  - pack: Keil::MDK-Middleware@7.13.0   # add Keil::MDK-Middleware pack at version 7.13.0
  - pack: ARM::CMSIS-FreeRTOS@~10.4     # add CMSIS-FreeRTOS with version 10.4.x

  - pack: NXP::K32L3A60_DFP             # add pack for NXP device 
    path: ./local/NXP/K32L3A60_DFP      # with path to the pack (local copy, repo, etc.)

  - pack: AWS::coreHTTP                 # add pack
    path: ./development/AWS/coreHTTP    # with path to development source directory
    for-context: +DevTest               # pack is only used for target-type "DevTest"
```

## Target Selection

### `board:`

Specifies a [unique board name](#board-name-conventions), optionally with vendor that must be defined in software packs.
This information is used to define the `device:` along with basic toolchain settings.

### `device:`

Specifies a [unique device name](#device-name-conventions), optionally with vendor that must be defined in software
packs. This information is used to define the `device:` along with basic toolchain settings.

A `device:` is derived from the `board:` setting, but an explicit `device:` setting overrules the `board:` device.

If `device:` specifies a device with a multi-core processor, and no explicit `pname` for the processor core selection is specified, the default `pname` of the device is used.

At the level of a `cproject.yml` file, only the `pname` can be specified as the device itself is selected at the level of a `csolution.yml` file.

## Processor Attributes

### `processor:`

The `processor:` keyword specifies the TrustZone configuration for this project.

`processor:`                         | Content
:------------------------------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `trustzone:`      | TrustZone mode: `secure` \| `non-secure` \| `off`.

The default setting for `trustzone:` is:

- `off` for devices that support this option, but TrustZone is configurable.
- `non-secure` for devices that have TrustZone enabled.

**Example:**

```yml
project:
  processor:
    trustzone: secure
```

## Context

A [`context`](#context-name-conventions) is an enviroment setup for a project that is composed of: 

- `project-name` that is the base name of the `*.cproject.yml` file.
- `.build-type` that defines typically build specific settings such as for debug, release, or test.
- `+target-type` that defines typically target specific settings such as device, board, or usage of processor features.

The section
[Project setup for multiple targets and test builds](Overview.md#project-setup-for-multiple-targets-and-builds)
explains the overall concept of  `target-types` and `build-types`. These `target-types` and `build-types` are defined in the `*.csolution.yml` that defines the overall application for a system.

The settings of the `target-types:` are processed first; then the settings of the `build-types:` that potentially overwrite the `target-types:` settings.

### `target-types:`

The `target-types:` node may include [toolchain options](#toolchain-options), [target selection](#target-selection), and [processor attributes](#processor-attributes):

`target-types:`                                    |              | Content
:--------------------------------------------------|--------------|:------------------------------------
`- type:`                                          | **Required** | The target-type name that is used to create the [context](#context-name-conventions) name.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)        |   Optional   | Toolchain selection.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)    |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)|   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)        |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)              |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)        |   Optional   | Control Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)            |   Optional   | Preprocessor (#define) symbols for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)        |   Optional   | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)        |   Optional   | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)        |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`board:`](#board)              | **see Note** | Board specification.
&nbsp;&nbsp;&nbsp; [`device:`](#device)            | **see Note** | Device specification.
&nbsp;&nbsp;&nbsp; [`processor:`](#processor)      |   Optional   | Processor specific settings.
&nbsp;&nbsp;&nbsp; [`context-map:`](#context-map)  |   Optional   | Use different `target-types:` for specific projects.
&nbsp;&nbsp;&nbsp; [`variables:`](#variables)      |   Optional   | Variables that can be used to define project components.

> **Note::**
>
> Either `device:` or `board:` is required.

### `build-types:`

The `build-types:` node may include [toolchain options](#toolchain-options):

`build-types:`                                     |              | Content
:--------------------------------------------------|--------------|:------------------------------------
`- type:`                                          | **Required** | The build-type name that is used to create the [context](#context-name-conventions) name.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)        |   Optional   | Toolchain selection.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)    |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)|   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)        |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)              |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`define:`](#define)            |   Optional   | Preprocessor (#define) symbols for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)        |   Optional   | Remove preprocessor (#define) symbols.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)        |   Optional   | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)        |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                |   Optional   | Literal tool-specific controls.
&nbsp;&nbsp;&nbsp; [`context-map:`](#context-map)  |   Optional   | Use different `build-types:` for specific projects.
&nbsp;&nbsp;&nbsp; [`variables:`](#variables)      |   Optional   | Variables that can be used to define project components.

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
    debug: on                    # generates debug information

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
3. `processor:` overwrites default settings for code generation, such as endianess, TrustZone mode, or disable Floating
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

### `context-map:`

>**Scheduled for CMSIS-Toolbox 2.0 - Q2**

The `context-map:` node allows for a specific `project-name` the remapping of `target-types:` and/or `build-types:` to a different `context:` which enables: 

- Integrating an existing `*.cproject.yml` file in a different `*.csolution.yml` file that uses different `build-types:` and/or `target-types:` for the overall application.
- Defines how different `*.cproject.yml` files of a `*.csolution.yml` are to the binary image of the final target (needs reflection in cbuild-idx.yml).

The `context-map:` node lists the remapping the [`context:`](#context-name-conventions) of a `project-name` for specific `target-types:` and `build-types:`.

`context-map:`                                     |              | Content
:--------------------------------------------------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `- context:`                    | **Required** | Specify a next context for a project

For the `context-map:` it is required to specify the `project-name` in the `context:` list. This project will use a different `.build-type` and/or `+target-type` as applied in the `context:`. This remapping of the context applies for the specific type in the `build-types:` or `target-types:` list.

**Example 1:**

This application combines two projects for a multi-processor device, but the project `HelloCM7` requires a different setting for the build-type name `Release` as this enables different settings within the `*.cproject.yml` file.
 
```yml
  target-types:
    - type: DualCore
      device: MyDualCoreDevice

  build-types:
    - type: Release                        # When applying build-type name 'release':
      context-map:
        - context: HelloCM7.flex_release   # project HelloCM7 uses build-type name "flex_release" instead of "release"
     
  projects:
    - project: ./CM7/HelloCM7.cproject.yml
    - project: ./CM4/HelloCM4.cproject.yml
```

**Example 2:**

The following example uses three projects `Demo`, `TFM` and `Boot`. The project `TFM` should be always build using the context `TFM.Release+LibMode`.  For the target-type name `Board`, the Boot project requires the `+Flash` target, but any build-type could be used.

```yml
  target-types:
    - type: Board                          # When applying target-type: 'Board':
      context-map:
        - context: TFM.Release+LibMode     # for project TFM use build-type: Release, target-type: LibMode
        - context: Boot+Flash              # for project Boot use target-type: Flash
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

It is possible to include or exclude *items* of a [*list node*] in the build process.

- [`for-compiler:`](#for-compiler) includes *items* only for a compiler toolchain.
- [`for-context:`](#for-context) includes *items* only for a [*context*](#context-name-conventions) list.
- [`not-for-context:`](#not-for-context) excludes *items* for a [*context*](#context-name-conventions) list.

> **Note:**
> 
> `for-context` and `not-for-context` are mutually exclusive, only one occurrence can be specified for a
  *list node*.

### `for-compiler:`

Depending on a [compiler](#compiler) toolchain it is possible to include *list nodes* in the build process.

**Examples:**

```yml
for-compiler: AC6@6.16               # add item for Arm Compiler version 6.16 only      

for-compiler:                        # add item
  - AC6                              # for Arm Compiler (any version)
  - GCC                              # for GCC Compiler
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

The keyword `for-context:` and `not-for-context:` can be applied to the following *list nodes*:

List Node                                  | Description
:------------------------------------------|:------------------------------------
[`- project:`](#projects)                  | At `projects:` level it is possible to control inclusion of project.
[`- layer:`](#layers)                      | At `layers:` level it is possible to control inclusion of a software layer.

The keyword `for-context:`, `not-for-context:`, and `for-compiler:` can be applied to the following *list nodes*:

List Node                                  | Description
:------------------------------------------|:------------------------------------
[`- component:`](#components)              | At `components:` level it is possible to control inclusion of a software component.
[`- group:`](#groups)                      | At `groups:` level it is possible to control inclusion of a file group.
[`- setup:`](#setups)                      | At `setups:` level it is define toolchain specific options that apply to the whole project.
[`- file:`](#files)                        | At `files:` level it is possible to control inclusion of a file.

The inclusion of a *list node* is processed for a given project [*context*](#context-name-conventions) respecting its hierarchy from top to bottom:

`project` --> `layer` --> `component`/`group` --> `file`

In other words, the restrictions specified by `for-context:` or `not-for-context` for a *list node* are automatically applied to its children nodes. Children *list nodes* inherit the restrictions from their parent.

## Multiple Projects

The section [Project setup for related projects](Overview.md#project-setup-for-related-projects) describes the
organization of multiple projects. The file `*.csolution.yml` describes the relationship of this projects and may also re-map
`target-types:` and `build-types:` for this projects using [`context-map:`](#context-map).

### `projects:`

The YAML structure of the section `projects:` is:

`projects:`                                               |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
[`- project:`](#project)                                  | **Required** | Path to the project file.
&nbsp;&nbsp;&nbsp; [`for-context:`](#for-context)         |   Optional   | Include project for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`not-for-context:`](#not-for-context) |   Optional   | Exclude project for a list of *build* and *target* types.
&nbsp;&nbsp;&nbsp; [`compiler:`](#compiler)               |   Optional   | Specify a specific compiler.
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)           |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)       |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)               |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)               |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                       |   Optional   | Literal tool-specific controls.

**Examples:**

This example uses two projects that are build in parallel using the same `build-type:` and `target-type:`.  Such a setup is typical for multi-processor systems.

```yml
  projects:
    - project: ./CM0/CM0.cproject.yml      # include project for Cortex-M0 processor
    - project: ./CM4/CM4.cproject.yml      # include project for Cortex-M4 processor
```

This example uses multiple projects, but with additional controls.

```yml
  projects:
    - project: ./CM0/CM0.cproject.yml      # specify cproject.yml file
      for-context: +CM0-Addon                 # build only when 'target-type: CM0-Addon' is selected
      for-compiler: GCC                    # build only when 'compiler: GCC'  is selected
      define:                              # add additional defines during build process
        - test: 12

    - project: ./CM0/CM0.cproject.yml      # specify cproject.yml file
      for-context: +CM0-Addon                 # specify use case
      for-compiler: AC6                    # build only when 'compiler: AC6'  is selected
      define:                              # add additional defines during build process
        - test: 9

    - project: ./Debug/Debug.cproject.yml  # specify cproject.yml file
      not-for-context: .Release               # generated for any 'build-type:' except 'Release'
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
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths.
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
&nbsp;&nbsp;&nbsp; [`language-C:`](#language-c)           |   Optional   | Set the language standard for C source file compilation.
&nbsp;&nbsp;&nbsp; [`language-CPP:`](#language-cpp)       |   Optional   | Set the language standard for C++ source file compilation.
&nbsp;&nbsp;&nbsp; [`optimize:`](#optimize)               |   Optional   | Optimize level for code generation.
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.     
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for code generation.     
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.     
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths.
&nbsp;&nbsp;&nbsp; [`del-path:`](#del-path)               |   Optional   | Remove specific include file paths.
&nbsp;&nbsp;&nbsp; [`misc:`](#misc)                       |   Optional   | Literal tool-specific controls.

> **Note:** 
> 
> It is also possible to specify a [Linker Script](Linker-Script-Management.md). Files with the extension `.sct`, `.scf`, `.ld`, and `.icf` are recognized as Linker Script files.

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

### `layers:`

Add a software layer to a project. Used in `*.cproject.yml` files.

`layers:`                                                 |              | Content
:---------------------------------------------------------|--------------|:------------------------------------
[`- layer:`](#layer)                                      |   Optional   | Path to the `*.clayer.yml` file that defines the layer.
&nbsp;&nbsp;&nbsp; [`type:`](#layer---type)               |   Optional   | Refers to an expected layer type.
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

#### `layer:` - `type:`

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
&nbsp;&nbsp;&nbsp; [`debug:`](#debug)                     |   Optional   | Generation of debug information.
&nbsp;&nbsp;&nbsp; [`warnings:`](#warnings)               |   Optional   | Control generation of compiler diagnostics.
&nbsp;&nbsp;&nbsp; [`define:`](#define)                   |   Optional   | Define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`undefine:`](#undefine)               |   Optional   | Remove define symbol settings for code generation.
&nbsp;&nbsp;&nbsp; [`add-path:`](#add-path)               |   Optional   | Additional include file paths.
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

> **Note:** 
>
> The name format for a software component is described under  [Name Conventions - Component Name Conventions](#component-name-conventions).

### `instances:`

Allows to add multiple instances of a component and actually applies to configuration files.
Detailed description is [here](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#Component_Instances)

**Example:**

```yml
components:
  - component: USB:Device
    instances: 2
```

If the user selects multiple instances of the same component, all files with  attribute `config` in the `*.PDSC` file
will be copied multiple times to the project. The name of the component (for example config_mylib.h) will get a postfix
`_n` whereby `n` is the instance number starting with 0.

Instance 0: config_usb_device_0.h  
Instance 1: config_usb_device_1.h

The availability of instances in a project can be made public in the `RTE_Components.h` file. The existing way to extend
the `%Instance%` with the instance number `n`.

## Pre/Post build steps

>**Scheduled for CMSIS-Toolbox 2.1 - Q3'23**
Tbd: potentially map to CMake add_custom_command.

### `execute:`

Execute and external command for pre- or post-build steps (such as code signing).

`- execute:`                      |               | Content
:---------------------------------|:--------------|:------------------------------------
`- execute:` description          |  **Required** | Execute an external command with description
&nbsp;&nbsp;&nbsp; `os:` name     |   Optional    | Executable on named operating systems (if omitted it is OS independent).
&nbsp;&nbsp;&nbsp; `run:` name    |   Optional    | Executable name, optionally with path to the tool.
&nbsp;&nbsp;&nbsp; `args:` name   |   Optional    | Executable arguments.
&nbsp;&nbsp;&nbsp; `stop:` name   |   Optional    | Stop on exit code.

Potential usage before/after build:

```yml
solution:
  :
  :
  projects:
    - execute: Generate Keys for TF-M
      os: Linux
      run: KeyGen.exe
    - project: /security/TFM.cproject.yml
    - project: /application/MQTT_AWS.cproject.yml
    - execute: Copy output files
      run: cp *.out ./output
```

Potential usage during build steps:

```yml
project:
  :
  :
  groups:
    - group:  "Main File Group"
      files: 
        - execute: Generate file1a.c
          run: xyz.exe
          ....
        - file: file1a.c
```

## `connections:`

The `connections:` node contains meta-data that describes the compatiblity of `*.cproject.yml` and `*.clayer.yml` project parts.  The `connections:` node lists functionality (drivers, pins, and other software or hardware resources). The node `consumes:` lists required functionality; the node `provides:` is the implemented functionality of that project part.

This enables, for example, reference applications that work across a range of different hardware targets where:

- The `*.cproject.yml` file of the reference application lists with the `connections:` node the required functionality with `consumes:`.

- The `*.clayer.yml` project part lists with the `connections:` node the implemented functionality with `provides:`.
 
This works across multiple levels, which means that a `*.clayer.yml` file could also require other functionality using `consumes:`.
  
The `connections:` node is used to identify compatible software layers. These software layers could be stored in CMSIS software packs using the following structure:

- A reference application described in a `*.cproject.yml` file could be provided in a git repository. This reference application uses software layers that are provided in CMSIS software packs.

- A CMSIS Board Support Pack (BSP) contains a configured board layer desribed in a `*.clayer.yml` file. This software layer is pre-configured for a range of use-cases and provides drivers for I2C and SPI interfaces along with pin definitions and provisions for an Ardunio shield.

- For a sensor, a CMSIS software pack contains the sensor middleware and software layer (`*.clayer.yml`) that describes the hardware of the Ardunio sensor shield. This shield can be applied to many different hardware boards that provide an Ardunio shield connector.

This `connections:` node enables therefore software reuse in multiple ways:

- The board layer can be used by many different reference applications, as the `provided:` functionlity enables a wide range of use cases.
  
- The sensor hardware shield along with the middleware can be used across many different boards that provide an Ardunio shield connector along with board layer support.

The structure of the `connections:` node is:

`connections:`                          |              | Description
:------------------------------------|--------------|:------------------------------------
[- `connect:`](#connect)             | **Required** | Lists specific functionality with a brief verbal description

### `connect:`

The `connect:` node describes one or more functionalities that belong together.

`connect:`                           |              | Description
:------------------------------------|--------------|:------------------------------------
[`set:`](#set)                       |   Optional   | Specifies a *config-id*.*select* value that identifies a configuration option
`info:`                              |   Optional   | Verbal desription displayed when this connect is selected
[`provides:`](#provides)             |   Optional   | List of functionality (*key*/*value* pairs) that are provided
[`consumes:`](#consumes)             |   Optional   | List of functionality (*key*/*value* pairs) that are required 

### `set:`

Some hardware boards have configuration settings (DIP switch or jumper) that configure interfaces. These settings have impact to the functionality (for example hardware interfaces). With `set:` *config-id*.*select* the possible configration options are considered when evaluating compatible `*.cproject.yml` and `*.clayer.yml` project parts. The **csolution - CMSIS Project Manager** iterates the `connect:` node with a `set:` *config-id*.*select* as described below:

- For each *config-id* only one `connect:` node with a *select* value is active at a time. Each possible *select* value is checked for a matching configuration.

- When project parts have a matching configuration, the `set:` value along with the `info:` is shown to the user. This allows the user to enable the correct hardware options.

Refer to [Example: Sensor Shield](#example-sensor-shield) for a usage example.

### `provides:`

A user-defined *key*/*value* pair list of functionality that is implemented or provided by a `project:` or `layer:`. 

The **csolution - CMSIS Project Manager** combines all the *key*/*value* pairs that listed under `provides:` and matches it with the *key*/*value* pairs that are listed under `consumes:`. For *key*/*value* pairs listed under `provides:` the following rules exist for a match with `consumes:` *key*/*value* pair:

- It is possible to omit the *value*. It matches with an identical *key* listed in `consumes:`
- A *value* is interpreted as number. Depending on the value prefix, this number must be:
  - when `consumes:` *value* is a plain number, identical with this value.
  - when `consumes:` *value* is prefixed with `+`, higher or equal then this *value* or the sum of all *values* in multiple `consumes:` nodes.

### `consumes:`

A user-defined *key*/*value* pair list of functionality that is requried or consumed by a `project:` or `layer:`. 

For *key*/*value* pairs listed under `consumed:` the following rules exist:

- When no *value* is specified, it matches with any *value* of an identical *key* listed under `provides:`.
- A *value* is interpreted as number. This number must be identical in the `provides:` value pair.
- A *value* that is prefixed with `+` is interpreted as a number that is added together in case that the same *key* is listed multiple times under `consumes:`. The sum of this value must be lower or equal to the *value* upper limit of the `provides:` *key*.
 
### Example: Board

This `connections:` node of a board layer describes the available interfaces.  The WiFi interface requires a CMSIS-RTOS2 function.

```yml
  connections:                          # describes functionality of a board layer
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

This shows a the `connections:` node of a complete application project that is composed of two software layers.

*MyProject.cproject.yml*

```yml
  connections:
    - connect: all resources
      provides:
        - RTOS2:          # implements RTOS2 API interface
      consumes:
        - IoT_Socket:     # requires IoT_Socket interface
        - STDOUT:         # requires STDOUT interface
        - Heap:  +30000   # requires additional 30000 bytes memory heap
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
        - Heap: +20000    # requires additional 20000 bytes memory heap
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

## Generator (Proposal)

>Note: Superseeded by [Generator%20(Proposal).md](Generator%20(Proposal).md)

--> Requires Review

### Workflow assumptions

The composition of a solution of a solution should have the following steps:

- Create `*.cproject.yml` files and the `*.csolution.yml` container that refers the projects.
- Select `device:` or `board:` (optionally by using `target-types:`)
- Add `components:` or `layers:` to the `*.cproject.yml` file
- For components that have configuration, run the generator in configuration mode
  - change pinout, clock, resources, etc.
  - reflect configuration in *.gpdsc file (and related settings files)

> **Note:**
>
> Components can have multiple [instances](#instances).

### Steps for component selection and configuration

The following explains the generator workflow of CSolution / CBuild for configuration of components:

1. User selects components in `*.cproject.yml` under `components:`
   - When these components require generation, user is notified to run a generator.
   - "CSolution Run GenID” is invoked for a list of components.
   - CSolution generates `*.cgen.json` file that provides project context and a list of user-selected components.
  
2. Running the Generator (for Component Configuration, i.e. pin selection)
   - Generator reads `*.cgen.json` file
   - User performs the configuration is done.
     - Interactive mode (where a settings file is generated)
     - Remote mode (where a settings file is an input) **IS THIS REALLY REQUIRED**
   - Generator creates a `*.gpdsc` file that informs the CSolution tool about
     - (a) the fact that a component is configured and has generated code,
     - (b) additional components that are the result of some user configuration.

   Discussions:
   - is a component list or a dependency list
   - Generator might be VS Code plugin or web based

3. User creates CBuild output with CSolution Convert command
   - Both `*.cproject.yml` and `*.gpdsc` are read by Csolution and create the complete list of selected components.
   - If `*.gpdsc` does not contain component information about a component that has `genId` and selected in
     `*.cproject.yml` the generator configuration is incomplete. This can happen when a component is added at a later
     step.
   - Likewise the Generator can detect with the `<component User="1">` attribute that a component is longer required.
     In this case the user is notified to run a generator.

### Enhance Usability

Add Run Generator buttons to Cclass descriptions.

![Add Run Generator buttons to Cclass](./images/gen.png "Add Run Generator buttons to Cclass")

### Workflow

1. For `*.cproject.yml` files that contain selected `<components>` with a `generator` or `genid` attribute the
   `csolution` manager checks if a file with the name `./<project>/RTE+<target>/<genid>.cgen.json` exists.
   - When this file is missing, it is required to use the command `csolution run genid` to start the generator.
   - When this file exists, the `csolution` manager checks if the list of components with `genid` has changed. If this
     is the case it is required to use the command `csolution run genid` to reconfigure generated components.
2. The command `csolution run genid` creates the file `./<project>/RTE+<target>/<genid>.cgen.json` and starts the
   generator. The generator creates a `*.GDPSC` file along with other source files that are required
   [as specified](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_generators_pg.html#element_generators).

#### Example Content of `*.cgen.json` (in this case `STM32CubeMX.cgen.json`)

The `*.cgen.json` file is passed to generator as argument.

> **Note:**
>
> Shown is still a `*.yml` file, but the equivalent data would be formatted in `*.json` format.

```yml
cgenerator:
  device: STM32F407IGHx
  board: NucleoF407
  solution: C:/tmp/MySolution/MySolution.csolution.yml 
  project: C:/tmp//MySolution/Blinky/Blinky.cproject.yml 
  context: .Debug+Nucelo    # build-type and target-type of the current generated context
  destination: C:/tmp/MySolution/Blinky/RTE+Nucelo/

  packs:                     # packs that are used for the project
    - pack: Keil::STM32F4xx_DFP@2.16.1
      path: C:/CMSIS-PACKS/Keil/STM32F4xx_DFP/2.16.1/
    - pack: Keil::STM32F4xx_BSP@2.1.1
      path: C:/CMSIS-PACKS/Keil/STM32F4xx_BSP/2.1.1/

  components:               # components that have a genid and are specified in *.cproject.yml
    - component: Device:STM32Cube HAL:Common
    - component: Board:LED
    - component: Device:HAL:UART
      instances:
        - WiFi: 0
          setup: wifi-config.json
          baudrate: 19200 
        - Debug: 2
          baudrate: 57600
```

### Changes to the *.GPDSC file

To indicate that a component was generated due to a user selection in `*.cproject.yml`, the `component` element is
extended with `User` attribute. When set to `1` it indicates that a component is included due to the selection in
`*.cproject.yml`.

When a user removes this component in the `*.cproject.yml`, the CSolution could detect that a Run command should be
executed.

### Changes to the *.PDSC file

- Add `<key>` to `<generator>` element. The `key` is used to invoke the generator and pass the `<genid>.cgen.json` file.
  - on Windows to a registry key to invoke the generator tool
  - on Linux and MacOS to an environment variable that specifies how to invoke the generator tool
  - todo: Web based tools?
- Add `genId` to `component` element. Indicates that a component is managed by the `<generator>`.
- Add `inherent` to `component` element. Indicates that a component is managed by the `<generator>`
  Components with inherent attribute are not selectable by the user (and could be managed by the `<generator>`).
  Components with `inherent` attribute have the following behavior:
  - Are selected when a condition requires this component.
  - Are de-selected when a no condition requires this component.
  - IDE's may choose to hide such components in the RTE selection (default might be to show it).
- Add new file category:
  - `genParms` template parameters
  - `genInput` source templates for the generator and other related input files for the generator

**Example:**

```xml
 <generators>
    <!-- This generator is launched if any component referencing this generator by 'id' is selected and the specified <gpdsc> file does not exist -->
    <generator id="STM32CubeMX">
      <description>ST Microelectronics: STCubeMX Environment</description>
      <key>STCubeMX_CGENFILE</key>          <!-- for windows registry key that opens a *.cgenerator.yml file -->
                                            <!-- for Linux / MacOS the key is an environment variable that can start the tool -->
      <web>url</web>                        <!-- for web based tools the url is used and appended by &Cgen=file -->
      <workingDir>$PRTE/Device</workingDir> <!-- path is specified either absolute or relative to gpdsc file -->
      <gpdsc name ="myGen.gpdsc"/>  <!-- PDSC or GPDSC file. If not specified it is the project directory configured by the environment -->
      <files>   <!-- does this make sense? -->
        <file category="genHelper" name="Drivers/STM32F4xx_HAL_Driver/Src/common-file-for-gen.xyz"/>
      </files>
    </generator>
  </generators>

  <taxonomy>
    <description Cclass="Device" generator="STM32CubeMX" doc="Documentation/DM00105879.pdf" >STM32F4xx Hardware Abstraction Layer (HAL) and Drivers</description>
    <description Cclass="Board" generator="STM32CubeMX" doc="Documentation/DM00105879.pdf" >STM32F412 Board Abstraction Layer (HAL) and Drivers</description>
  </taxonomy>


    <component Cclass="Device" Cgroup="STM32Cube HAL" Csub="Common"    Cversion="1.7.9" condition="STM32F4 HAL Common"  genid="STM32CubeMX" >
      <description>Common HAL driver</description>
      <RTE_Components_h>
        #define RTE_DEVICE_HAL_COMMON
      </RTE_Components_h>
      <files>
        <file category="include" name="Drivers/STM32F4xx_HAL_Driver/Inc/"/>
        <file category="header"  name="Drivers/STM32F4xx_HAL_Driver/Inc/stm32f4xx_hal.h"/>
        <file category="source"  name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c"/>
        <file category="genParams" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.json"/>
        <file category="genHeader" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.h.template"/>
        <file category="genSource" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c.template"/>
      </files>
    </component>
    <component Cclass="Device" Cgroup="STM32Cube HAL" Csub="ADC"       Cversion="1.7.9" condition="STM32F4 HAL DMA"  genid="STM32CubeMX">
      <description>Analog-to-digital converter (ADC) HAL driver</description>
      <RTE_Components_h>
        #define RTE_DEVICE_HAL_ADC
      </RTE_Components_h>
      <files>
        <file category="source" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_adc.c"/>
        <file category="source" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_adc_ex.c"/>
        <file category="genParameter" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_adc.json"/>
        <file category="genHeader" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_adc.h.template"/>
        <file category="genSource" name="Drivers/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_adc.c.template"/>
      </files>
    </component>
      :
    <bundle Cbundle="STM32F4-Discovery" Cclass="Board Support" Cversion="2.0.0">
      <description>STMicroelectronics STM32F4 Discovery Kit</description>
      <doc>http://www.st.com/st-web-ui/static/active/en/resource/technical/document/data_brief/DM00037955.pdf</doc>
      <component Cgroup="LED" Capiversion="1.0.0" condition="STM32F4 HAL GPIO" genid="STM32CubeMX">
        <description>LED Interface for STMicroelectronics STM32F4-Discovery Kit</description>
        <files>
          <file category="source"  name="MDK/Boards/ST/STM32F4-Discovery/Common/LED_F4Discovery.c"/>
          <file category="genParams" name="MDK/Boards/ST/STM32F4-Discovery/Common/LED_F4Discovery.json"/>
          <file category="genHeader" name="MDK/Boards/ST/STM32F4-Discovery/Common/LED_F4Discovery.h.template"/>
          <file category="genSource" name="MDK/Boards/ST/STM32F4-Discovery/Common/LED_F4Discovery.c.template"/>
        </files>
      </component>
```

**Example *.gpdsc file**

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- ******************************************************************************
 * File Name   : FrameworkCubeMX.gpdsc
 * Date        : 23/09/2021 14:18:05
 * Description : Generator PDSC File generated by STM32CubeMX (DO NOT EDIT!)
 ****************************************************************************** -->
<package xmlns:xs="http://www.w3.org/2001/XMLSchema-instance" schemaVersion="1.0" xs:noNamespaceSchemaLocation="PACK.xsd">
  <vendor>Keil</vendor>
  <name>FrameworkCubeMX</name>
  <description>STM32CubeMX generated pack description</description>
  <url>project-path</url>
  <releases>
    <release version="1.0.0">
     - Generated: 23/09/2021 14:18:05
    </release>
  </releases>
  <generators>
    <generator id="STM32CubeMX" Gvendor="STMicroelectronics" Gtool="STM32CubeMX" Gversion="4.10.0">
      <description>STM32CubeMX Environment</description>
      <select Dname="STM32G474RETx" Dvendor="STMicroelectronics:13"/>
      <command>$SMDK/CubeMX/STM32CubeMXLauncher</command>
      <workingDir>$PRTE/Device/STM32G474RETx</workingDir>
      <project_files>
        <file category="include" name="STCubeGenerated/Inc/"/>
        <file category="source" name="STCubeGenerated/Src/main.c" />
        <file category="header" name="STCubeGenerated/Inc/stm32g4xx_it.h"/>
        <file category="source" name="STCubeGenerated/Src/stm32g4xx_it.c"/>
      </project_files>
    </generator>
  </generators>
  <taxonomy>
    <description Cclass="Device" Cgroup="STM32Cube Framework" generator="STM32CubeMX">STM32Cube Framework</description>
  </taxonomy>
  <conditions>
    <condition id="STCubeMX">
      <description>Condition to include CMSIS core, Device Startup and HAL Drivers components</description>
      <require Dvendor="STMicroelectronics:13" Dname="STM32G4*"/>
      <require Cclass="CMSIS"  Cgroup="CORE"/>
      <require Cclass="Device" Cgroup="Startup"/>
      <require Cclass="Device" Cgroup="STM32Cube HAL"/>
    </condition>
  </conditions>
  <components>
    <bundle Cbundle="STM32CubeMX" Cclass="Device" Cversion="1.4.0">
      <component generator="STM32CubeMX" Cvendor="Keil" Cgroup="STM32Cube Framework" Csub="STM32CubeMX" condition="STCubeMX">
        <description>Configuration via STM32CubeMX</description>
        <RTE_Components_h>
          #define RTE_DEVICE_FRAMEWORK_CUBE_MX
        </RTE_Components_h>
        <files>
          <file category="header" name="MX_Device.h"/>
          <file category="header" name="STCubeGenerated/Inc/stm32g4xx_hal_conf.h"/>
          <file category="source" name="STCubeGenerated/Src/stm32g4xx_hal_msp.c"/>
        </files>
      </component>
      <component  Cgroup="Startup" User="1">  <!-- user selected component in *.cproject.yml -->
        <description>System Startup for STMicroelectronics</description>
        <files>
          <file category="source" name="STCubeGenerated/MDK-ARM/startup_stm32g474xx.s" />
          <file category="source" name="STCubeGenerated/Src/system_stm32g4xx.c" />
        </files>
      </component>
    </bundle>
  </components>
</package>
```
