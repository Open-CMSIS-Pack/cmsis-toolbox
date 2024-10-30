# Pack Creation

[**CMSIS-Toolbox**](README.md) **> Pack Creation**

This chapter describes how to create software packs and explains the tools `packchk` (software pack verification) and `svdconv` (SVD file converter).

**Chapter Contents:**

- [Pack Creation](#pack-creation)
  - [Pack Creation Tools](#pack-creation-tools)
  - [Scripts](#scripts)
  - [Hands-on Tutorials](#hands-on-tutorials)
  - [Hints for Pack Creation](#hints-for-pack-creation)
  - [Examples](#examples)

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

## Examples

Several [packs](https://github.com/Open-CMSIS-Pack#cmsis-software-pack-examples) available on [github.com/Open-CMSIS-Pack](https://github.com/Open-CMSIS-Pack) exemplify how to create software packs. Other packs that are a good reference are the various [Arm CMSIS packs](https://www.keil.arm.com/packs/cmsis-arm) or the [MDK Middleware pack](https://www.keil.arm.com/packs/mdk-middleware-keil).  The source of these packs is available on [Github/Arm-software](https://github.com/ARM-software).
