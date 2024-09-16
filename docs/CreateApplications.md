# Create Applications

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->
<!-- markdownlint-disable MD032 -->

[**CMSIS-Toolbox**](README.md) **> Create Applications**

The following chapter explains the structure of a software pack and how it can be used in an application.

- [Create Applications](#create-applications)
  - [Start a Project](#start-a-project)
  - [Configure Linker Scripts](#configure-linker-scripts)
    - [Regions Header File](#regions-header-file)
    - [Linker Script Template](#linker-script-template)
  - [Using Components](#using-components)
  - [Software Component](#software-component)
    - [Required Interfaces](#required-interfaces)
  - [Example: Network Stack](#example-network-stack)
  - [Update Software Packs](#update-software-packs)

## Start a Project

An application is based on a *device* and/or *board* that are supported by a Device Family Pack (DFP) or Board Support Pack (BSP). The steps to start a project are:

1. Step: **Install the DFP and BSP**
   - Use [Device search](https://www.keil.arm.com/devices/) or [Board search](https://www.keil.arm.com/boards/) available on web portals to identify the software packs required for your target.
   - Use `CMSIS Pack` to download the Device Family Pack (DFP) and optionally the Board Support Pack (BSP) with [`cpackget`](build-tools.md#install-public-packs). Note that a BSP is only required if you want to work with a specific board. For custom hardware, typically the DFP is sufficient. 
   
2. Step: **Use a Template Project and add DFP and BSP**
   - Select a suitable generic [Template Project](https://github.com/Open-CMSIS-Pack/csolution-examples/tree/main/Templates) or refer to the DFP documentation as some devices have specific template projects.
   - Copy the template project and open the `*.csolution.yml` file.  Add under [`packs:`](YML-Input-Format.md#packs) the packs identified in step (1). You may omit the version number during initial project development.

    ```yml
      :
      compiler: AC6

      # List the packs that define the device and/or board.
      packs:
        - pack: AnalogDevices::ADuCM320_DFP
      :
    ```
   
3. Step: **Use `csolution list` commands to identify device or board**
   - Use `csolution list devices <name>.csolution.yml` or `csolution list boards <name>.csolution.yml` to get the device or board names.
   - Enter the device or board name under [`target-types:`](YML-Input-Format.md#target-types). A device is typically used for custom hardware.

    ```yml
      :
      target-types:
        - type: ADuCM320-Board    # choose a brief name for your target hardware
        # device: MyDeviceName    # replace with your device or comment out to use a board
          board: Analog Devices::EVAL-ADuCM320EBZ     # you may omit version information
      :
    ```

   - Most projects require `- component: Device:Startup` or a variant. Use `csolution list components <name>.csolution.yml` to identify the name of the startup component and add it to the file `*.cproject.yml` of your project.
   - Now, the project should already compile with the command `cbuild <name>.csolution.yml --update-rte --packs --context .Debug`. Note that this step downloads missing packs and copies configuration files to the [RTE directory](build-overview.md#rte-directory-structure). 

4. Step: **Review and configure RTE files** 
   - Review the configuration files in the [RTE directory](build-overview.md#rte-directory-structure) and refer to the documentation of the software components for instructions.
   - [Configure Linker Scripts](#configure-linker-scripts) below explains how to setup physical memory.
   - For simple projects the default settings should be sufficient.
   - The [build information file](YML-CBuild-Format.md#cbuild-output-files) `<name>.cbuild.Debug+<target-name>.yml` lists configuration files of components and other useful information such as links to documentation of the component.
  
5. Step: **Add application functionality**
   - Implement the application code in C/C++ source files. Use the [`groups:`](YML-Input-Format.md#groups) section in `<name>.cproject.yml` to add new source files.
   - Use `csolution list components  <name>.csolution.yml` to identify additional software components from the selected packs. Use the [`components:`](YML-Input-Format.md#components) in `<name>.cproject.yml` to add new components and refer to related documentation for usage instructions. Note that you may omit vendor and version information for components as this is defined already by the packs that are selected.

    ```yml
      :
      groups:
        - group: Source Files
          files: 
            - file: main.c
            - file: MyFile1.c
      :
      components:
        - component: ARM::CMSIS:CORE
        - component: Device:Startup
        - component: Device:Peripheral Libraries:ADC
      :
    ```

   - Again, the project should compile with the command `cbuild <name>.csolution.yml --update-rte --packs --context .Debug`. Repeat step (4) when you added new components that require configuration.

> **Note:**
>
> - The Arm CMSIS Solution extension for VS Code guides you through these steps with the `Create New Solution` workflow. This extension is for example part of the [Arm Keil Studio Pack](https://marketplace.visualstudio.com/items?itemName=Arm.keil-studio-pack).

## Configure Linker Scripts

A *linker script file* defines the physical memory layout for a `*.cproject.yml` based. It may also allocate specific program sections (for example DMA buffers or non-volatile variables) to special memory regions. While complex devices may use a bespoke linker script to manage multi-core and multi-master bus systems, many single core devices can use the [automatic linker script generation](build-overview.md#automatic-linker-script-generation) of the **`csolution` Project Manager** which uses a generic *regions header file* in combination with a toolchain-specific *linker script template*.

The following section describes the usage of a *linker script template* and a *regions header file* which is combined by a C preprocessor into the final *linker script file*. It uses [auto-generated files](build-overview.md#automatic-linker-script-generation), but the methods also apply somewhat to bespoke linker scripts.

The overall process to configure linker scripts for independent projects is:

1. Step: Review and adjust the physical memory layout in the *regions header file*.
2. Step: Optionally add specific program sections to the *linker script template* or change the default behavior of that file. 

### Regions Header File

An initial *regions header file* is generated based on the memory information in the used software packs (DFP and BSP). This file has the name `regions_<device_or_board>.h` and is located in the directory [`./RTE/Device/<device>`](build-overview.md#rte-directory-structure).

For memory with the [*default* attribute set](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#element_memory) in DFP or BSP the following region settings are generated:

- The region \_\_ROM0 is the startup region and contains memory with the [*startup* attribute set](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#element_memory).
- The region \_\_RAM0 contains uninitialized memory, STACK and HEAP. 
  - STACK default is 0x200.
  - HEAP default is 0xC00 for devices with more than 6KB RAM (otherwise HEAP is set to 0).
- Contiguous memory with same access (rw, rwx, rx) is combined into one region.

For memory with the [*default* attribute no set](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#element_memory) in DFP or BSP the memory is listed under **resources that are not allocated to linker regions**.

The user may modify this generated *regions header file*:

- to adapt the physical memory layout of the project.
- to add **not allocated memory resources** to regions \_\_ROM*n* and \_\_RAM*n*.

**Example: `regions_B-U585-IOT02A.h` header file for a board**

```c
#ifndef REGIONS_B_U585I_IOT02A_H
#define REGIONS_B_U585I_IOT02A_H

//-------- <<< Use Configuration Wizard in Context Menu >>> --------------------
//------ With VS Code: Open Preview for Configuration Wizard -------------------

// <n> Auto-generated using information from packs
// <i> Device Family Pack (DFP):   Keil::STM32U5xx_DFP@3.0.0-dev0
// <i> Board Support Pack (BSP):   Keil::B-U585I-IOT02A_BSP@2.0.0-dev0

// <h> ROM Configuration
// =======================
// <h> __ROM0 (is rx memory: Flash from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x08000000
//   <i> Contains Startup and Vector Table
#define __ROM0_BASE 0x08000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00200000
#define __ROM0_SIZE 0x00200000
// </h>

// <h> __ROM1 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM1_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM1_SIZE 0
// </h>

// <h> __ROM2 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM2_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM2_SIZE 0
// </h>

// <h> __ROM3 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __ROM3_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __ROM3_SIZE 0
// </h>

// </h>

// <h> RAM Configuration
// =======================
// <h> __RAM0 (is rwx memory: SRAM1_2 from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x20000000
//   <i> Contains uninitialized RAM, Stack, and Heap
#define __RAM0_BASE 0x20000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region. Default: 0x00040000
#define __RAM0_SIZE 0x00040000
// </h>

// <h> __RAM1 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __RAM1_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __RAM1_SIZE 0
// </h>

// <h> __RAM2 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __RAM2_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __RAM2_SIZE 0
// </h>

// <h> __RAM3 (unused)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
#define __RAM3_BASE 0
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
#define __RAM3_SIZE 0
// </h>

// </h>

// <h> Stack / Heap Configuration
//   <o0> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
//   <o1> Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
#define __STACK_SIZE 0x00000200
#define __HEAP_SIZE 0x00000C00
// </h>

// <n> Resources that are not allocated to linker regions
// <i> rwx RAM:  SRAM3 from DFP:           BASE: 0x20040000  SIZE: 0x00080000
// <i> rwx RAM:  RAM-External from BSP:    BASE: 0x90000000  SIZE: 0x00800000
// <i> rx ROM:   Flash-External from BSP:  BASE: 0x70000000  SIZE: 0x04000000

#endif /* REGIONS_B_U585I_IOT02A_H */
```

### Linker Script Template

A [template *linker script file*](build-overview.md#linker-script-templates) is copied to the directory [`./RTE/Device/<device>`](build-overview.md#rte-directory-structure). The user may modify this file:

- to specify program sections that require dedicated physical memory regions.
- to change the allocation behavior of the linker script.

**Example: DMA section allocation in `ac6_linker_script.sct.src` linker script template**

```c
#if __RAM1_SIZE > 0
  RW_RAM1 __RAM2_BASE __RAM2_SIZE  {
    *(.RxDecripSection)               // added DMA descriptors
    *(.TxDecripSection)
    *(.driver.eth_mac0_rx_buf)
    *(.driver.eth_mac0_tx_buf)
   .ANY (+RW +ZI)
  }
#endif
```

> **Note:** 
>
> It is recommended to add a note to the *regions header file* about such user modifications as shown below:

```c
// <h> __RAM1 (is rwx memory: SRAM3 from DFP)
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region. Default: 0x20040000
//   <i> Note: DMA descriptors and buffers are in this region
```

## Using Components

The steps to create an application based on software components are:

1. Step: **Select software components**
   - Select the software pack that provides the required functionality (this could be based on pack datasheets) and identify the required software component(s).
   - Add the pack and the component to your `*.cproject.yml` file.
   - Run `csolution *.csolution.yml list dependencies` to identify other required software components.
   - Run `csolution list components --filter` to identify packs that provide this software components.
   - Repeat this step until all software components are part of your project.

2. Step: **Configure software components**
   - Run `csolution *.csolution.yml update-rte` to copy configuration files into the [RTE directory](./build-overview.md#rte-directory-structure).
   - Set the parameters in the configuration files for your application.
  
3. Step: **Use software components in application program**
   - User code templates provide a starting point for your application. 
   - Copy these template files to your project directory add add it to your `*.cproject.yml` file.
   - Adjust the code in the user template files as required.

## Software Component

A software component encapsulates a set of related functions. By offering API headers, it provides interfaces to other software components or to the user application.

The software pack provides for a software component other optional items such as configuration files, documentation, user code templates that show the usage of the software component, and a debug view description (for [CMSIS-View](https://arm-software.github.io/CMSIS-View/latest/index.html)). A software component typically interfaces to other software components or to device peripherals.

![Software Component Overview](./images/sw-component.png "Software Component Overview")

In the CMSIS-Pack system software components:

- Are identified by the node [components:](YML-Input-Format.md#components) using a [component name](YML-Input-Format.md#component-name-conventions).
- Use dependencies to describe required interfaces.
- List API header files for provided interfaces.

For example the LwIP network stack:

- requires an CMSIS-RTOS2 compliant kernel or a FreeRTOS kernel
- CMSIS-Drivers for the communication interface.
- List API header files for their interfaces.

> ToDo: A potential improvement is a pack data sheet that displays information about software components.

### Required Interfaces

There are two ways to describe required interfaces as shown in the diagram below. 

- Dependency reference to a component (a selection list is supported).
- Dependency reference to a API definition. Components that implement this API fulfill then the required interface.

![Software Component Stacking](./images/sw-component-stacking.png "Software Component Stacking")

The API definition has the benefit that components which implement the interface can be added over time. The exact component names need not to be known by the component that requires an interface.

> ToDo: A potential improvement is to use the command `csolution list components` to show available implementations for a required interface.

## Example: Network Stack

In this example, the application requires TCP Socket connectivity. Using the steps described under [Using Components](#using-components) delivers this content for `*.cproject.yml` file.

```yml
  packs:
    - pack: Keil::MDK-Middleware@7.16.0
    - pack: ARM::CMSIS@5.9.0
    - pack: ARM::CMSIS-Driver@2.7.2
    - pack: Keil::LPC1700_DFP@2.7.1

  components:
    - component: Network&MDK-Pro Net_v6:Socket:TCP
    - component: Network&MDK-Pro Net_v6:CORE&Release
    - component: Network&MDK-Pro Net_v6:Interface:ETH
    - component: CMSIS:CORE
    - component: CMSIS:RTOS2:Keil RTX5&Source
    - component: CMSIS Driver:Ethernet:KSZ8851SNL
    - component: CMSIS Driver:SPI:SPI
    - component: Device:PIN
    - component: Device:GPIO
    - component: Device:Startup
```

The required interfaces are identified using `csolution list dependencies`:

![Network Stack - Component View](./images/Network-components.png "Network Stack - Component View")

Adding more components such as a IoT Client would be the next step.

![Network Stack - Class View](./images/Network-classes.png "Network Stack - Class View")

## Update Software Packs

ToDo: this section needs review!

The update of software packs can be performed with these steps:

- Download new software packs as needed using `cpackget`.

- Use the command `csolution convert` with the option `--load latest` to update the software packs.

  ```bash
  >csolution convert Hello.csolution.yml --load latest
  ```

- List potentially outdated configuration files using the command `csolution list configs`.

  ```bash
  >csolution list configs Hello.csolution.yml
  ../RTE/CMSIS/RTX_Config.c@5.1.1 (update@5.2.0) from ARM::CMSIS:RTOS2:Keil RTX5&Source@5.8.0
  ../RTE/Device/SSE-300-MPS3/startup_SSE300MPS3.c@1.1.1 (up to date) from ARM::Device:Startup&C Startup@2.0.0
  ../RTE/Device/SSE-300-MPS3/system_SSE300MPS3.c@1.1.1 (up to date) from ARM::Device:Startup&C Startup@2.0.0
  ```

> **Note:** 
>
> The text `update@version` indicates that there is a new configuration file available. Use a merge utility to identify and merge configuration settings from a previous version. Refer to [PLM of configuration files](build-overview.md#plm-of-configuration-files) for more information.
