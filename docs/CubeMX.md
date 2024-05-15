# Configure STM32 Devices with CubeMX

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **> Configure STM32 Devices with CubeMX**

This chapter explains how to use [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html) with the CMSIS-Toolbox to manage device and board configuration.

**Chapter Contents:**

- [Configure STM32 Devices with CubeMX](#configure-stm32-devices-with-cubemx)
  - [Overview](#overview)
  - [Simple Project](#simple-project)
  - [Add RTOS](#add-rtos)
  - [Linker Script](#linker-script)
  - [Create a Board Layer](#create-a-board-layer)
  - [TrustZone or Multi-Core Project](#trustzone-or-multi-core-project)
  - [CubeMX Runtime Context Mapping](#cubemx-runtime-context-mapping)

## Overview

[STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html) (CubeMX) is a graphical tool for configuration of a STM32 device or board. CubeMX generates C code for project and peripheral initialization based on user settings. Depending on the device configuration related drivers are added to the user application. The CMSIS-Toolbox interacts with CubeMX using the [generic interface for generators](build-operation.md#generator-integration).

The `component: Device:CubeMX` connects a *csolution project* to CubeMX. This component imports the CubeMX generated files for a selected `device:` or `board:` using the [generator import file](YML-CBuild-Format.md#generator-import-file) (`*.cgen.yml`). This `*.cgen.yml` file is similar to a [software layer](build-overview.md#software-layers) but managed by CubeMX and should be not modified directly.

An example project created with CubeMX can be found in [**csolution-examples/CubeMX**](https://github.com/Open-CMSIS-Pack/csolution-examples/tree/main/CubeMX).

>**Notes:**
>
> - When a board is specified in the *csolution project*, CubeMX pre-configures the device peripherals with sensible settings for the evaluation board. The user may change these settings using the CubeMX dialogs.
> - When only a device is specified, the user need to configure the peripherals manually using CubeMX dialogs.

## Simple Project

Below is a simple project that just adds the CubeMX generated components.

>**Note:**  
>
> The packs required for boards and devices are listed on [www.keil.arm.com/boards](https://www.keil.arm.com/boards/) and [www.keil.arm.com/devices](https://www.keil.arm.com/devices/).

**File: `CubeMX.csolution.yml`**

```yml
solution:
  created-for: CMSIS-Toolbox@2.3.0
  description: Simple CubeMX example
  cdefault:                                   # use toolchain default settings
  compiler: AC6                               # select toolchain

# it is recommended to list the pack or packs that define the device or board used in the csolution.yml file
  packs:
    - pack: ARM::CMSIS                        # CMSIS pack is required for most projects
    - pack: Keil::B-U585I-IOT02A_BSP
    - pack: Keil::STM32U5xx_DFP@>=3.0.0-0
    
  target-types:
    - type: MyBoard                           # My evaluation kit
      board: B-U585I-IOT02A                   # Board name as defined by the pack

  build-types:                                # defines toolchain options for 'debug' and 'release'
    - type: Debug
      debug: on
      optimize: none

    - type: Release
      debug: off
      optimize: balanced

  projects:                                   # list related projects
    - project: ./CubeMX.cproject.yml
```

**File: `CubeMX.cproject.yml`**

```yml
project:
  components:
    - component: CMSIS:CORE                   # CMSIS-Core component is required
    - component: Device:CubeMX                # Component that connects to CubeMX    
```

Such a project cannot be directly generated as initially the `*.cgen.yml` file is missing. It requires to run the CubeMX generator.  Before you start, you may need to [`install missing packs`](build-tools.md#install-missing-packs).

1. Identify the required generator and the directory where the generated files are stored with:
   
   ```bash
   >csolution CubeMX.csolution.yml list generators --verbose
   CubeMX (Global Registered Generator)    # generator name
     base-dir: STM32CubeMX/MyBoard         # directory for generated files
       context: CubeMX.Debug+MyBoard       # list of context that uses this directory
       context: CubeMX.Release+MyBoard 
   ```

2. Using the above information to run the generator using this command:

   ```bash
   >csolution CubeMX.csolution.yml run --generator CubeMX --context CubeMX.Debug+MyBoard
   ```

   It starts CubeMX and passes the information about the selected board, device, and select toolchain. For a project that selects a board, CubeMX imports the default configuration for the evaluation kit. In CubeMX review and adjust configuration options as required for your application, then just click the button `GENERATE CODE`. The generated files will be stored in the directory `STM32CubeMX/MyBoard`.

3. Build the project using this command:
 
   ```bash
   >cbuild CubeMX.csolution.yml --update-rte
   ```

>**Note:**
>
> You may run the CubeMX generator any time to change the configuration setting of your device or board.

**Directory with generated files**

CubeMX generates the following content in the generator output directory of the *csolution project*. In our example the generator output directory is `STM32CubeMX/MyBoard`.

Directory `STM32CubeMX/MyBoard`     | Content
:-----------------------------------|:---------------
`CubeMX.cgen.yml`                   | Generator import file adds the CubeMX generated files to  the *csolution project*.
`MX_Device/CubeMX/MX_Device.h`      | Header file with configuration settings for CMSIS software components.
`STM32CubeMX/STM32CubeMX.ioc`       | CubeMX project file with settings.
`STM32CubeMX/Src`                   | CubeMX generated application code: `main.c` and STM32 setup code.
`STM32CubeMX/Inc`                   | Header files for CubeMX generated application code.
`STM32CubeMX/EWARM`                 | Project files for IAR; only startup code and linker scripts are used for *csolution projects*.
`STM32CubeMX/GCC`                   | Project files for GCC; only startup code and linker scripts are used for *csolution projects*.
`STM32CubeMX/MDK-ARM`               | Project files for MDK version 5; only startup code and linker scripts are used for *csolution projects*.

> **Note:**
>
> CubeMX generates only the directory for the selected toolchain which is either `STM32CubeMX/EWARM`, `STM32CubeMX/GCC`, or `STM32CubeMX/MDK-ARM`.

**Content of Generator Import File: `CubeMX.cgen.yml`**

The file `*.cgen.yml` lists the files and settings that are generated by CubeMX and imported in the *csolution project*. The files under `group: CubeMX` may be modified by the user in sections marked with `USER CODE BEGIN` and `USER CODE END` to implement the application specific features. In the file `*.cproject.yml` additional [user files](YML-Input-Format.md#files) can be added.

```yml
generator-import:
  for-device: STM32U585AIIx
  for-board: B-U585I-IOT02A
  define:
    - USE_FULL_LL_DRIVER
    - USE_HAL_DRIVER
    - STM32U585xx
  add-path:
    - ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Inc
    - ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Inc/Legacy
    - ./STM32CubeMX/Drivers/CMSIS/Device/ST/STM32U5xx/Include
    - ./STM32CubeMX/Inc
    - ./MX_Device/CubeMX
  groups:
    - group: CubeMX
      files:
        - file: ./STM32CubeMX/Src/main.c
        - file: ./STM32CubeMX/Src/stm32u5xx_it.c
        - file: ./STM32CubeMX/Src/stm32u5xx_hal_msp.c
        - file: ./STM32CubeMX/MDK-ARM/startup_stm32u585xx.s
        - file: ./STM32CubeMX/Src/system_stm32u5xx.c
    - group: STM32 HAL Driver
      files:
        - file: ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_utils.c
        - file: ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_exti.c
            :
        - file: ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_hal_pcd_ex.c
        - file: ./STM32CubeMX/Drivers/STM32U5xx_HAL_Driver/Src/stm32u5xx_ll_usb.c
```

## Add RTOS

Many applications require an RTOS kernel. By default, CubeMX implements interrupts functions for all Cortex-M exception handlers. However some exception handlers are typically required for the RTOS kernel execution. 

Adding an RTOS kernel requires these steps:

1. **Add the RTOS kernel to application** (in this case RTX) as should below:

   **File: `CubeMX.cproject.yml`**    

   ```yml
   project:
     packs:
       - pack: ARM::CMSIS-RTX                    # RTOS Software Pack    

     groups:
       - group: MyApp
         files:
           - file: MyMain.c    

     components:
       - component: CMSIS:CORE                   # CMSIS-Core component is required
       - component: Device:CubeMX                # Component that connects to CubeMX    
       - component: CMSIS:RTOS2:Keil RTX5&Source # RTOS component
       - component: CMSIS:OS Tick                # OS Tick implementation for RTOS
   ```    

   > **Note:**
   >
   > The example above uses RTX as the RTOS kernel, other kernels require different components and packs, but the concept is similar.

1. **In CubeMX configure interrupt handlers** as shown below:

   Run CubeMX with:

   ```bash
   >csolution CubeMX.csolution.yml run --generator CubeMX --context CubeMX.Debug+MyBoard
   ```

   Open the dialog *Pinout & Configuration - System Core NVIC - Code generation* and disable *Generate IRQ handler* for:

    - System service call via SWI instruction
    - Pendable request for system service
    - Time base: System tick timer

   ![STM32CubeMX - configure interrupt handlers](./images/CubeMX_NVIC_RTOS.png "configure interrupt handlers")

   Then click the button `GENERATE CODE` to update the generated files in the directory `STM32CubeMX/MyBoard`

## Linker Script

Depending on the project type and toolchain, CubeMX provides a linker script:

- `compiler: AC6`
  - no linker script is generated for a simple memory. In this case, the default linker script from the CMSIS-Toolbox is used, but needs a modification: remove ARM_LIB_HEAP and ARM_LIB_STACK as they are defined in the STM32 startup file.
  - linker script is provided for more complex projects (typically when using the CubeMX Memory Manager).
  
- `compiler: GCC` or `compiler: IAR`
  - linker script is always provided.

> **Note:** 
>
> The linker script that is provided by CubeMX is defined in the `*.cgen.yml` and imported into the *csolution project*.

## Create a Board Layer

A [software layer](build-overview.md#software-layers) is a set of pre-configured software components and source files for re-use in multiple projects. A board layer contains typically basic I/O drivers and related device and board configuration. CubeMX does generate a significant part of a board layer.

The board layer is stored in an separate directory that is independent of a specific *csolution project*. To create a board layer, copy the related source files, the STM32CubeMX generated files, and the configuration files of the [RTE directory](.) that relate to software components in the board layer.

**Example directory content of a STM32 board layer**

Directory and Files          | Description
:----------------------------|:---------------------------------------
`Board.clayer.yml`           | Defines the source files and software components of the board layer.
`Driver/`                    | Directory with driver related source files.
`STM32CubeMX/`               | Directory with CubeMX generated files.
`STM32CubeMX/Board.cgen.yml` | Generator import file that lists CubeMX generated files and options.

The `Board.clayer.yml` file defines with the `generators:` node, options to locate the CubeMX generated files in the directory structure of the [software layer](build-overview.md#software-layers). As a board layer is used by many projects, the name of the generator import file should be explicitly specified as shown below:

```yml
generators:
    options:
    - generator: CubeMX
      path: ./STM32CubeMX                   # path relative to the `*.clayer.yml` file
      name: Board                           # generator import file is named `Board.cgen.yml`.
```

## TrustZone or Multi-Core Project

Projects that use TrustZone or a multi-core device share the same STM32CubeMX configuration. There is therefore just one directory `STM32CubeMX` located at the same level as the `*.csolution.yml` project file.

## CubeMX Runtime Context Mapping

Some devices, for example the STM32H7S series, provide in CubeMX *runtime contexts*, for example: `Boot`, `Appli`, `ExtMemLoader`. To map the *csolution* project context to these CubeMX *runtime contexts* it is required for this type of devices to use `map:` key in the `generator`: option as shown below.

The STM32H7S series uses the following CubeMX run-time names:

- `Boot` for the boot loader.
- `Appli` for the user application program.
- `ExtMemLoader` for the part that is in external memory.

The `generators:` node is used to map a `*.cproject.yml` or `*.clayer.yml` file to a CubeMX run-time context as shown below.

```yml
generators:
    options:
    - generator: CubeMX
      map: Appli            # map project or layer to CubeMX runtime context
```
