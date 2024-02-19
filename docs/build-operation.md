# Build Operation

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **> Build Operation**

This chapter explains the overall build process that of the CMSIS-Toolbox and how to add a new compiler toolchain.

**Chapter Contents:**

- [Build Operation](#build-operation)
  - [Build Process Overview](#build-process-overview)
    - [`cbuild` Build Invocation](#cbuild-build-invocation)
    - [`csolution` Project Manager](#csolution-project-manager)
  - [Add Toolchain to CMSIS-Toolbox](#add-toolchain-to-cmsis-toolbox)
    - [Steps](#steps)
    - [CMake Variables](#cmake-variables)
      - [`BRANCHPROT` Values](#branchprot-values)
  - [Generator Integration](#generator-integration)
    - [Generator Start via `component`](#generator-start-via-component)
    - [Global Generator Registry File](#global-generator-registry-file)

## Build Process Overview

The section below describes the overall process to add a new compiler toolchain to the CMSIS-Toolbox. 

### `cbuild` Build Invocation

The **`cbuild` Build Invocation** utility controls the overall build process.

- Calls the **`csolution` Project Manager** (with option `--no-update-rte`) to process *csolution project files*.
- When option `--packs` is used, it downloads missing *software packs* using the **`cpackget` Pack Manager**.
- Generates a `CMakeList.txt` files that include a `compiler_name.<version>.cmake` file for toolchain specific configuration.
- These `CMakeList.txt` files are then processed by the `CMake` tool to generate the `build.ninja` file with the actual build commands.
- This `build.ninja` file is then used by the `Ninja` tool to generate the binary image or a library file with the selected toolchain.

The picture below outlines these operations.

![Operation of `csolution` tool](./images/cbuild-operation.png "Operation of `csolution` tool")

> **Note:**
>
> By default, the `cbuild` invocation does not update the [**RTE Directory**](build-overview.md#rte-directory-structure). Use the option `--update-rte` if this is required.

### `csolution` Project Manager

The [**`csolution` Project Manager**](build-overview.md) processes [*csolution project files* (in YAML format)](YML-Input-Format.md) and the `*.pdsc` metadata files of *software packs* and performs the following operations:

- Generate build information in the [**Project Area**](build-overview.md#project-area) with the following files: [`*.cbuild-idx.yml`, `*.cbuild.yml`](YML-CBuild-Format.md), and `*.cprj` files for the **cbuild** tool.
- Generate header files in the [**RTE Directory**](build-overview.md#rte-directory-structure) for each [context](YML-Input-Format.md#context) with the following files: [RTE_components.h](build-overview.md#rte_componentsh) and pre-include files from the `*.pdsc` metadata.
- [Copy the configuration files](build-overview.md#plm-of-configuration-files) from selected software components to the [**RTE Directory**](build-overview.md#rte-directory-structure).

The picture below outlines these operations.

![Operation of `csolution` tool](./images/csolution-operation.png "Operation of `csolution` tool")

## Add Toolchain to CMSIS-Toolbox

The following section explains how to add a compiler toolchain to the CMSIS-Toolbox.

### Steps

The section below describes the steps to add a new compiler toolchain to the CMSIS-Toolbox. 

1. Define a `compiler_name` for the new compiler toolchain, i.e. `CLang`.
2. Add this `compiler_name` to the `"CompilerType":` in the schema file [`./tools/projmgr/schemas/common.schema.json`](https://github.com/Open-CMSIS-Pack/devtools/blob/main/tools/projmgr/schemas/common.schema.json).
3. Create a new CMake file in [`./tools/buildmgr/cbuildgen/config`](https://github.com/Open-CMSIS-Pack/devtools/tree/main/tools/buildmgr/cbuildgen/config) with the naming convention `compiler_name.<version>.cmake`.
4. Map with the file `compiler_name.<version>.cmake`. the **CMake** input variables to the **CMake** toolchain variables.
   - Use an existing `*.cmake` file, i.e. `GCC.<version>.cmake` as reference.
 
### CMake Variables

The `CMakeLists.txt` file sets the following **CMake** input variables that should be processed by `compiler_name.<version>.cmake`.

CMake Variable                                   | Possible Values           | Description
:------------------------------------------------|:--------------------------|:-----------------------
`BYTE_ORDER`                                     | Little-endian, Big-endian | [Endian processor configuration](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#Dendian)
`CPU`                                            | [DCoreEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DcoreEnum)      | Processor core selection
`FPU`                                            | [DfpuEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DfpuEnum)        | Floating point unit support
`DSP`                                            | [DdspEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DdspEnum)        | DSP instruction set support
`TZ`                                             | [DtzEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DtzEnum)          | TrustZone support
`SECURE`                                         | [DsecureEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DsecureEnum)  | Software model selection
`MVE`                                            | [DmveEnum](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#DmveEnum)        | MVE instruction set support
`BRANCHPROT`                                     | [`BRANCHPROT` values](#branchprot-values)  | [Branch protection
`OPTIMIZE`                                       | [Optimize values](YML-Input-Format.md#optimize)  | Generic optimize levels for code generation
`WARNINGS`                                       | [Warnings values](YML-Input-Format.md#warnings)  | Control warning level for compiler diagnostic
`DEBUG`                                          | [Debug values](YML-Input-Format.md#debug)        | Control the generation of debug information
`DEFINES`                                        | [Define symbols](YML-Input-Format.md#define)     | List of symbol #define statements

#### `BRANCHPROT` Values

The following table lists the possible values for the CMake variable `BRANCHPROT`.

Values        | Description
--------------|------------------------------
NO_BRANCHPROT | Branch protection not used
BTI           | Using BTI (Branch Target ID)
BTI_SIGNRET   | Using BTI + Sign Return

The `compiler_name.<version>.cmake` sets the following **CMake** variables to specify the toolchain and select toolchain options.

CMake Variable                                   | Description
:------------------------------------------------|:-----------------------
`ASM_CPU`, `CC_CPU`, `CXX_CPU`                   | Device selection set according to the combination of device attributes (`CPU`, `FPU`, `DSP`, `MVE`, etc.)
`AS_LEG_CPU`, `AS_ARM_CPU`, `AS_GNU_CPU`         | Similar to the previous item but for assembly dialect variants (if applicable)
`ASM_FLAGS`, `CC_FLAGS`, `CXX_FLAGS`, `LD_FLAGS` | Flags applicable to all modules of the given language
`CC_SECURE`, `LD_SECURE`                         | Flags applicable only for secure projects
`_PI`                                            | Pre-include option
`_ISYS`                                          | system include option
`LIB_PREFIX`                                     | Generated library name prefix
`LIB_SUFFIX`                                     | Generated library name suffix
`EXE_SUFFIX`                                     | Generated executable name suffix
`ELF2HEX`                                        | Flags for ELF to HEX conversion
`ELF2BIN`                                        | Flags for ELF to BIN conversion
`CMAKE_C_COMPILER_ID`                            | CMake compiler identifier
`CMAKE_C_COMPILER_VERSION`                       | CMake compiler version

## Generator Integration

The diagram below shows how a generator is integrated into the CMSIS build process. The data flow is exemplified on STM32CubeMX (Generator ID for this example is `CubeMX`). The information about the project is delivered to the generator using the [Generator Information](YML-CBuild-Format.md#generator-information-files) files (`<csolution-name>.cbuild-gen-idx.yml` and `<context>.cbuild-gen.yml`). This information provides `CubeMX` with the project context, such as selected board or device, and CPU mode such as TrustZone disabled/enabled.

![Generator Integration](./images/Generator-Integration.png "Generator Integration")

The utility [`cbridge`](https://github.com/Open-CMSIS-Pack/generator-bridge) gets as parameter the `<csolution-name>.cbuild-gen-idx.yml` and calls the generator. For the `CubeMX` generator example these files are created:

- `*.ioc` CubeMX project file with current project settings
- `*.c/.h` source files, i.e. for interfacing with drivers
- `<project-name>.cgen.yml` (created by `cbridge`) provides the data for project import into the csolution build process.

> **Note:**  CubeMX itself does not have the required interfaces to the csolution project format. The utility `cbridge` converts the [build information files](YML-CBuild-Format.md) into command-line options for CubeMX. `cbridge` also generates the `<project-name>.cgen.yml` based on the information generated by CubeMX.

### Generator Start via `component`

A [`<component>`](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#element_component) element with a `generator` attribute in a `*.PDSC` file is used to start the generator. Typically this component is provided in a Device Family Pack (DFP) or a Board Support Pack (BSP).

**Example component for CubeMX in DFP:**

```xml
  <component generator="CubeMX" Cclass="Device" Cgroup="CubeMX" Cversion="0.9.0">
      <description>Configure device or board with STM32CubeMX</description>
  </component>
```

> **Note:**
>
> No `<generator>` element in the *.PDSC file is required when the [Global Generator Registry File](#global-generator-registry-file) is used. The `generator="id"` attribute of the `<component>` element in the `*.PDSC` file is the reference to the `- id:` list node in the `global.generator.yml` file.

### Global Generator Registry File

For generators that have no `<generator>` element in the *.PDSC file, the `global.generator.yml` in the CMSIS-Toolbox `./etc` directory contains is used. The `generator:` node in this YAML file registers the supported generators with the following keys:

`generator:`                                         |            | Content
:----------------------------------------------------|:-----------|:------------------------------------
`- id:`                                              |**Required**| `<generator-id>` referred in the `*.PDSC` file
&nbsp;&nbsp;&nbsp; `download-url:`                   |  Optional  | URL for downloading the generator
&nbsp;&nbsp;&nbsp; `run:`                            |**Required**| Name and location of the utility that starts the generator
&nbsp;&nbsp;&nbsp; `path:`                           |**Required**| Output directory of the generator. Contains the file `*.cgen.yml`.

```yml
generator:
  - id: CubeMX
    download-url: https://www.st.com/en/development-tools/stm32cubemx.html#st-get-software
    run: ../bin/cbridge
    path: $SolutionDir()$/STM32CubeMX/$TargetType$
```

> **Note:** 
> 
> - The only argument to the `run:` command is the path to the [Generator Information Index File](YML-CBuild-Format.md#generator-information-files). There are no configurable parameters for this utility. The invocation is:
>
>   `cbrige <csolution-name>.cbuild-gen-idx.yml`
