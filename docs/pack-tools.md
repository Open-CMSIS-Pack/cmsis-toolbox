# Pack Creation

[**CMSIS-Toolbox**](README.md) **&raquo; Pack Creation**

This chapter describes how to create software packs and explains the tools `packchk` (software pack verification) and `svdconv` (SVD file converter).

**Chapter Contents:**

- [Pack Creation](#pack-creation)
  - [Pack Creation Tools](#pack-creation-tools)
  - [Scripts](#scripts)
  - [Hands-on Tutorials](#hands-on-tutorials)
  - [Hints for Pack Creation](#hints-for-pack-creation)
  - [Project Examples](#project-examples)
    - [Support Multiple Compilers](#support-multiple-compilers)
    - [Related Examples](#related-examples)
    - [Template Projects](#template-projects)
    - [Examples](#examples)
    - [Reference Applications](#reference-applications)
  - [Layers](#layers)
  - [Code Templates](#code-templates)
  - [Pack Examples](#pack-examples)

## Pack Creation Tools

The following tools support the creation of Software Packs in [CMSIS-Pack format](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html):

Tool           | Description
:--------------|:-------------
**packchk**    | **Pack Validation:** installs and manages software packs in the local development environment.
**svdconv**    | **SVD Check / Convert:** validate and/or convert System View Description (SVD) files.

## Scripts

Several [tools and scripts](https://github.com/Open-CMSIS-Pack#ready-to-use-tools) help to automate the pack creation.

## Hands-on Tutorials

These scripts are in several hands-on tutorials.

Hands-on Tutorial         | Description
:-------------------------|:-------------
[**DFP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/DFP-Pack-HandsOn)   | Explains the structure and creation of a Device Family Pack (DFP).
[**BSP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/BSP-Pack-HandsOn)   | Explains the structure and creation of a Board Support Pack (BSP).  
[**SW-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/SW-Pack-HandsOn)    | Explains the steps to create a simple software pack using the Open-CMSIS-Pack technology.
[**Create-Scaleable-SW**](https://github.com/Open-CMSIS-Pack/Create-Scalable-SW) | Explains how to structure complex middleware stacks.

## Hints for Pack Creation

- Use [C startup files](https://arm-software.github.io/CMSIS_6/latest/Core/cmsis_core_files.html) that allows to use a DFP with any toolchain.
- For elements use a brief description text with less than 128 characters to explain the purpose. When possible link to documentation with detailed information.
  - Example: A component `Device:HAL:ENET` should not have description `ENET HAL Driver`, use `Ethernet HAL driver` instead.
- Consider adding [project templates](https://github.com/Open-CMSIS-Pack/STM32U5xx_DFP/tree/main/Templates) to help get started with more complex projects.
  - This is useful when devices are are configured using generators or provide multiple linker scripts (i.e. RAM/ROM execution).
- To distribute [toolchain agnostic examples](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/build-overview.md#toolchain-agnostic-project) as part of packs:
  - Consider to use [`select-compiler`](YML-Input-Format.md#select-compiler) to make projects toolchain independent.
  - To avoid that examples need updates with every pack release, specify the [minium pack version required](https://github.com/Open-CMSIS-Pack/csolution-examples/blob/main/DualCore/HelloWorld.csolution.yml#L9).
  - Use [CI workflows](https://github.com/Open-CMSIS-Pack/STM32H743I-EVAL_BSP/tree/main/.github/workflows) to validate that projects compile correctly.
- Add an [overview.md file](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/element_package_description.html) that describes the overall usage of the software pack. These files are displayed on [www.keil.arm.com/packs](https://www.keil.arm.com/packs) and index by Web search engines.

## Project Examples

Project examples help to get started with new devices, boards, and middleware software components. The CMSIS-Pack format supports therefore different types of project examples:

- [*Template Projects*](#template-projects) are [stub projects](https://github.com/Open-CMSIS-Pack/csolution-examples/tree/main/Templates) that help to get started. Some software packs may contain device specific templates.
- [*Examples*](#examples) are created for a specific hardware or evaluation board. These are typically complete projects that directly interface with board and device peripherals.
- [*Reference Applications*](#reference-applications) are hardware agnostic project examples that required [layers](#layers) to add the hardware abstraction of a target (typically a board).

In addition packs may contain:

- [*Layers*](#layers) are  pre-configured software components or source code that can be shared across multiple projects.
- [*Code Templates*](#code-templates) are stub source files for middleware components that can be incorporated into user code.

The picture below shows the different packs that are used to publish project examples. These examples are available for software developers on web pages and can be directly accessed from IDEs that are for example enabled with the [VS Code Arm CMSIS Solution](https://marketplace.visualstudio.com/items?itemName=Arm.cmsis-csolution) extension.

![Project Examples in Packs](./images/ExamplesInPacks.png "Project Examples in Packs")

The following section explains how the different types of project examples are structured and registered within a CMSIS-Pack.

### Support Multiple Compilers

To make project examples independent of a specific compiler toolchain, the `*.csolution.yml` file should include the `select-compiler:` node with a list of tested compilers. When a user or IDE starts such an example, the `compiler:` node that selects the compiler gets added.

**Example:**

```yml
solution:
  description: <brief description of the project example>
  created-for: CMSIS-Toolbox@2.6.0
  cdefault:

  select-compiler:  # list of tested compilers that can be selected
    - compiler: AC6
    - compiler: GCC
    - compiler: IAR
    - compiler: CLANG
      :
```

### Related Examples

The `*.csolution.yml` file may contain several related projects that share the same [`target-types:`](YML-Input-Format.md#target-types) and [`build-types:`](YML-Input-Format.md#build-types).

**Example:**

```yml
solution:
      :
  projects:
    - project: BSD_Server/BSD_Server.cproject.yml
    - project: FTP_Server/FTP_Server.cproject.yml
    - project: HTTP_Server/HTTP_Server.cproject.yml
```

### Template Projects

A *template project* does not define a [`device:`](YML-Input-Format.md#device) or [`board:`](YML-Input-Format.md#board) in the `*.csolution.yml` file. When a IDE starts such an *template* the `device:` and/or `board:` information along with `pack:` information is added depending on user selection. The [`target-types:`](YML-Input-Format.md#target-types) contains a  `Name` that may be replaced by a descriptive target name.

> **Note:**
>
> A *template project* should not specify the DFP or BSP with a `pack:` node as this gets added by the IDE during project start.

**Simple Template:**

A simple *template* only defines one target.

```yml
solution:
      :
  target-types:
    - type: Name
#     board:            # added during creation of solution
#     device:           # added during creation of solution
      :
```

**Multi-Target Template:**

A multi-target *template* may contain different configurations for the same target, for example a configuration that executes from ROM and another that executes from RAM. The example below shows how this could be achieved using [`variables:`](YML-Input-Format.md#variables).

```yml
solution:
      :
  target-types:
    - type: Name-ROM
#     board:           # added during creation of solution
#     device:          # added during creation of solution
      variables:
        - regions_header: path/region_ROM.h 

    - type: Name-RAM
#     board:           # added during creation of solution
#     device:          # added during creation of solution
      variables:
        - regions_header: path/region_RAM.h 
      :
```

In the example above, projects can use the [`linker:`](YML-Input-Format.md#linker) node in the `*.cproject.yml` file to reference the regions header file of the selected target.

```yml
project:

  linker:
    - regions:  $regions_header$
```

> **Note:**
>
> *Templates* should compile when the above information is added to the `*.csolution.yml` file. The exception is when *templates* require parts of the code provided by a generator.

**Register Template in PDSC File:**

*Templates* are published using the [`<csolution>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_csolution_pg.html) in the PDSC file. Device-specific *Templates* should be part of the DFP. Board-specific *templates* should be part of the BSP.

```xml
  <csolution> 
    <template name="Simple Device project" path="/device/Simple" file="Simple.csolution.yml" condition="Device_Spec">
      <description>Single-core project with empty main function configured for device</description>
    </template>
    <template name="Simple Board project" path="/board/Simple" file="Simple.csolution.yml" condition="Board_Spec">
      <description>Single-core project with empty main function configured for board</description>
    </template>
  </csolution>
```

### Examples

*Examples* are complete projects that typically run on a board. They should therefore specify a `target-type` with [`board:`](YML-Input-Format.md#board) and list the [`packs:`](YML-Input-Format.md#packs) that are used, specifically the DFP and BSP.

To minimize maintenance of *Examples* that are part of a pack, consider these rules:

- **IMPORTANT:** Store all files that are part of the [`./RTE` directory](build-overview.md#rte-directory-structure). These files store configuration and are important for [PLM](build-overview.md#plm-of-configuration-files).
- Use [`select-compiler:`](YML-Input-Format.md#select-compiler) when the *Example* works with several toolchains.  Do not specify `compiler:`.
- Specify [minimum pack version](YML-Input-Format.md#pack-name-conventions). Do not store `*.cbuild-pack.yml`.
- The tool selects first `target-type` and first `build-type` when `cbuild-set.yml` is missing. For simple projects do not store `*.cbuild-set.yml`.
- For simple projects, rely on the `cdefault.yml` file that is provided with CMSIS-Toolbox.

*Examples* that work with several compiler toolchains should use [`select-compiler:`](YML-Input-Format.md#select-compiler) and not define `compiler:` explicit. The `compiler:` node of the available toolchain is added when the *Example* is loaded into the IDE.

When [minimum pack versions](YML-Input-Format.md#pack-name-conventions) are specified, the semantic versioning of packs should ensure that newer pack versions work also. As the `*.cbuild-pack.yml` file fixes pack versions, this file should be not stored in the pack.

*Examples* may contain in the `*.csolution.yml` file multiple related projects that for example cover different aspects of a peripheral or middleware. For such *Examples* it is not required to store the `*.cbuild-set.yml` file as the tools select the first `target-type` and `build-type` of the `*.csolution.yml` file.

*Examples* that do not require special compiler controls may rely on the [`cdefault.yml` file](build-overview.md#cdefaultyml) that is provided with CMSIS-Toolbox as this file contains reasonable default settings. For more complex *Examples*, provide a local copy of the `cdefault.yml` file in the same directory as the `*.csolution.yml` file.

Refer to [Toolchain Agnostic Project](build-overview.md#toolchain-agnostic-project) for further information.

**`csolution.yml` file of an *Example*:**

```yml
solution:
# Optional: Add a brief description line (recommendation less than 128 characters)
  description: Example that shows the usage of Fault component on an Cortex-M33 with TrustZone

  created-for: CMSIS-Toolbox@2.6.0          # minimum CMSIS-Toolbox version, newer versions will work also
  cdefault:

  select-compiler:
    - compiler: GCC               # GCC is supported
    - compiler: AC6               # AC6 is supported
    - compiler: IAR               # IAR is supported

  packs:
    - pack: Keil::STM32U5xx_DFP@^2.1.0      # minimum compatible pack version
    - pack: Keil::B-U585I-IOT02A_BSP@^1.0.0

  target-types:
    - type: B-U585I-IOT02A
      board: STMicroelectronics::B-U585I-IOT02A
      device: STMicroelectronics::STM32U585AIIx

  build-types:
    - type: Debug
      debug: on
      optimize: debug

    - type: Release
      debug: off
      optimize: balanced

  projects:
    - project: ./Secure/Fault_S.cproject.yml
    - project: ./NonSecure/Fault_NS.cproject.yml
```

**Register *Examples* in PDSC File:**

*Examples* can be part of any pack and are published using the [`<examples>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_examples_pg.html) in the PDSC file. Note that it is possible to register multiple project formats to support different tool environments.

```xml
  <examples>
    <example name="Fault example" folder="Examples/Fault/B-U585I-IOT02A" doc="README.md">
      <description>Example that shows the usage of Fault component on an Cortex-M33 with TrustZone</description>
      <board name="B-U585I-IOT02A" vendor="STMicroelectronics"/>
      <project>
        <environment name="csolution" load="Fault.csolution.yml"/>
        <environment name="uv" load="Fault.uvmpw"/>
      </project>
    </example>
  </examples>
```

### Reference Applications

[*Reference applications*](ReferenceApplications.md) can run on many different target hardware boards. Similar to [*template projects*](#template-projects) the `device:` and `board:` along with the required DFP and BSP `pack:` is not specified in the `*.csolution.yml` file.

```yml
solution:
  description: IPv4/IPv6 Network examples
  created-for: CMSIS-Toolbox@2.6.0
  cdefault:

  select-compiler:  # list of tested compilers that can be selected
    - compiler: AC6
    - compiler: GCC
    - compiler: IAR
    - compiler: CLANG
 
  target-types:
    - type: Name
#     board:           # added during creation of solution
#     variables:
#       - Board-Layer: <board_layer>.clayer.yml
```

> **Note:**
>
> The [MDK-Middleware](https://github.com/ARM-software/MDK-Middleware/tree/main/Examples) contains several *reference applications* that exemplify the overall structure.

**Register *Reference Applications* in PDSC File:**

*Reference Applications* are typically part of a middleware software pack and publish using the [`<examples>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_examples_pg.html) in the PDSC file. The difference to [*examples*](#examples) is that no `<board> element` is used as the *reference application* is hardware agnostic.

```xml
  <examples>
    </example>
    <example name="Network" doc="README.md" folder="Examples/Network">
      <description>MDK-Middleware: IPv4/IPv6 Client and Server applications via Ethernet</description>
      <project>
        <environment name="csolution" load="Network.csolution.yml"/>
      </project>
    </example>
```

## Layers

[*Layers*](build-overview.md#software-layers) with [*connections*](ReferenceApplications.md#connections) are used to by [*Reference Applications*](#reference-applications) to target hardware. These layers are added when a *reference application* is configured for a `board:`, typically in the IDE.

**Register *Layers* in PDSC File:**

[*Layers*](build-overview.md#software-layers) are part of a BSP and published using the [`<csolution>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_csolution_pg.html) in the PDSC file.

```xml
  <csolution>
    <clayer type="Board" path="Layers/Default" file="Board.clayer.yml" copy-to="Board/MyBoard" condition="Board-Spec"/>
  </csolution>
```

> **Note:**
>
> Several [STM32 Board Support Packs (BSP)](https://github.com/Open-CMSIS-Pack#stm32-packs-with-generator-support)  contain *layers* that are pre-configured for certain applications. For example, the *layer* in the [ST_NUCLEO-F756ZG_BSP](https://github.com/Open-CMSIS-Pack/ST_NUCLEO-F756ZG_BSP/tree/main/Layers/Default) supports applications that require Ethernet, USB Device, UART, or I2C interfaces.

## Code Templates

*Code templates* are part of the [components files](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html#Component_Files) in the PDSC file and can be manually added by the user to a software project. *Code templates* show how a software component is used and the source code can be directly adapted to the requirements of the application program.

**Register *Code Templates* in PDSC File:**

[*Code Templates*](build-overview.md#software-layers) are part of a software component and published using the [`<components>` element](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_components_pg.html) using `attr="template"` in the PDSC file.

```xml
  <component Cgroup="Socket" Csub="UDP" condition="Network Interface">
    :
    <files>
      <file category="doc"    name="Documentation/html/Network/group__netUDP__Func.html"/>
      <file category="header" name="Components/Network/Config/Net_Config_UDP.h" attr="config" version="5.1.1"/>
      <file category="source" name="Components/Network/Template/UDP_Socket.c" attr="template" select="UDP Socket"/>
      <!-- Library source files -->
      <file category="source" name="Components/Network/Source/net_udp.c"/>
    </files>
```

> **Note:**
>
> The [CMSIS-RTX](https://github.com/ARM-software/CMSIS-RTX) and [MDK-Middleware](https://github.com/ARM-software/MDK-Middleware) pack contains several *code templates* that exemplify the overall structure.

## Pack Examples

Several [pack examples](https://github.com/Open-CMSIS-Pack#cmsis-software-pack-examples) available on [github.com/Open-CMSIS-Pack](https://github.com/Open-CMSIS-Pack) exemplify how to create software packs. Other packs that are a good reference are the various [Arm CMSIS packs](https://www.keil.arm.com/packs/cmsis-arm) or the [MDK Middleware pack](https://www.keil.arm.com/packs/mdk-middleware-keil).  The source of these packs is available on [Github/Arm-software](https://github.com/ARM-software).
