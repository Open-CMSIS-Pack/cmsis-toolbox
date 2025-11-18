# MCUXpresso for NXP Devices

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

This chapter explains how to use the [MCUXpresso Config Tool](https://www.nxp.com/configtools) with the CMSIS-Toolbox to manage device and board configuration.

!!! Note
    MCUXpresso Config Tools integration with CMSIS-Toolbox is available with CMSIS packs based on MCUXpresso SDK 2.16.0 (or higher).

## Overview

The [MCUXpresso Config Tool](https://www.nxp.com/configtools) is a graphical tool for configuring an NXP device or board. Based on user settings, MCUXpresso generates C code for project and peripheral initialization. The CMSIS-Toolbox interacts with MCUXpresso Config Tools using the [generic interface for generators](build-operation.md#generator-integration) and automatically adds generated source code to the project.

The `component: Device:Config Tools` connects a *csolution project* to MCUXpresso. This component imports the MCUXpresso generated files for a selected `device:` or `board:` using the [generator import file](YML-CBuild-Format.md#generator-import-file) (`*.cgen.yml`). This `*.cgen.yml` file is similar to a [software layer](build-overview.md#software-layers) but managed by MCUXpresso and should not be modified directly.

An example project created with MCUXpresso can be found in [**csolution-examples/DualCore**](https://github.com/Open-CMSIS-Pack/csolution-examples/tree/main/DualCore).

!!! Note
    - When a board is specified in the *csolution project*, MCUXpresso pre-configures the device peripherals with sensible settings for the evaluation board. The user may change these settings using the MCUXpresso dialogues.
    - When only a device is specified, the user needs to configure the peripherals manually using MCUXpresso dialogs.

## Simple Project

Below is a simple project that just adds the MCUXpresso-generated components.

!!! Tip
    The packs required for boards and devices are listed on [www.keil.arm.com/boards](https://www.keil.arm.com/boards/) and [www.keil.arm.com/devices](https://www.keil.arm.com/devices/).

**File: `Simple.csolution.yml`**

```yml
solution:
  created-for: CMSIS-Toolbox@2.6.0

  # List of tested compilers that can be selected
  select-compiler:
    - compiler: AC6
    - compiler: GCC
    - compiler: IAR

  # List the packs that define the device and/or board.
  packs:
    - pack: NXP::FRDM-MCXN947_BSP
    - pack: NXP::MCXN947_DFP
    - pack: ARM::CMSIS

  # List different hardware targets that are used to deploy the solution.
  target-types:
    - type: MCXN947VDF
      board: NXP::FRDM-MCXN947
      device: NXP::MCXN947VDF

  # List of different build configurations.
  build-types:
    - type: Debug
      debug: on
      optimize: none

    - type: Release
      debug: off
      optimize: balanced

  # List related projects.
  projects:
    - project: Simple.cproject.yml
```

**File: `Simple.cproject.yml`**

```yml
project:
  device: :cm33_core0

  generators:
    options:
      - generator: MCUXpressoConfig
        path: ./MCUXpressoConfig
        name: ConfigTools

  # List components to use for your application.
  # A software component is a reusable unit that may be configurable.
  components:
    - component: Device:Config Tools:Init
    - component: Device:Startup
    - component: Device:CMSIS:MCXN947_header
    - component: Device:CMSIS:MCXN947_system

    - component: Device:SDK Drivers:clock
    - component: Device:SDK Drivers:common
    - component: Device:SDK Drivers:mcx_spc
    - component: Device:SDK Drivers:reset

    - component: CMSIS:CORE

  groups:
    - group: Main
      files:
        - file: ./main.c
```

Such a project cannot be built directly as the `*.cgen.yml` file is initially missing. It requires running the MCUXpresso generator. Before you start, you may need to [`install missing packs`](build-tools.md#install-missing-packs).

- Identify the required generator and the directory where the generated files are stored with:

```bash
csolution Simple.csolution.yml list generators --verbose
MCUXpressoConfig (Global Registered Generator MCUXpresso Config tools)
  base-dir: MCUXpressoConfig
    cgen-file: MCUXpressoConfig/ConfigTools.cgen.yml
      context: Simple.Debug+MCXN947VDF
      context: Simple.Release+MCXN947VDF
```

- Using the above information to run the generator using this command:

```bash
csolution Simple.csolution.yml run --generator MCUXpressoConfig --context Simple.Debug+MCXN947VDF
```

   It starts MCUXpresso and passes information about the selected board, device, and selected toolchain. For a project that selects a board, MCUXpresso imports the default configuration for the evaluation kit. In MCUXpresso, review and adjust configuration options as required for your application, then just click the button `Update Code`. The generated files will be stored in the directory `./MCUXpressoConfig`.

- Build the project using this command:

```bash
cbuild Simple.csolution.yml --update-rte
```

!!! Note
    You may run the MCUXpresso Config Tools at any time to change the configuration setting of your device or board.

**Directory with generated files**

MCUXpresso generates the following content in the generator output directory of the *csolution project*. In our example, the generator output directory is `./MCUXpressoConfig`.

Directory `./MCUXpressoConfig`      | Content
:-----------------------------------|:---------------
`ConfigTools.cgen.yml`              | Import file, which adds the generated files to the *csolution project*.
`FRDM-MCXN947.mex`                  | MCUXpresso Config Tools configuration file.
`board/clock_config.c`              | Clock setup using clock driver functions.
`board/clock_config.h`              | Clock configuration header file.
`board/peripherals.c`               | Board peripherals are set up via init functions.
`board/peripherals.h`               | Board peripherals setup header file.
`board/pin_mux.c`                   | Board pin setup via init functions.
`board/pin_mux.h`                   | Board pin setup header file.

**Content of Generator Import File: `ConfigTools.cgen.yml`**

The file `ConfigTools.cgen.yml` lists the files and settings that are generated by MCUXpresso and imported into the *csolution project*. You may add further [user files](YML-Input-Format.md#files) here.

```yml
generator-import:
  generated-by: 'MCUXpresso config tools Generated: 09/12/2024 17:02:22'
  for-device: MCXN947
  for-board: FRDM-MCXN947
  groups:
  - group: ConfigTools board
    files:
    - file: board/clock_config.c
    - file: board/clock_config.h
    - file: board/peripherals.c
    - file: board/peripherals.h
    - file: board/pin_mux.c
    - file: board/pin_mux.h
```

## Linker Script

Depending on the toolchain, NXP provides a linker script. For Arm Compiler 6, a scatter file with the ending `*.scf` is
provided, for GCC, a linker script file with the ending `*.ld` is provided and for IAR, the provided linker script files
end with `*.icf` extension.

## Create a Board Layer

A [software layer](build-overview.md#software-layers) is a set of pre-configured software components and source files that can be reused in multiple projects. A board layer typically contains basic I/O drivers and related device and board configuration. MCUXpresso generates a significant part of a board layer.

The board layer is stored in a separate directory that is independent of a specific *csolution project*. To create a board layer, copy the related source files, the MCUXpresso generated files, and the configuration files of the `RTE directory` that relate to software components in the board layer.

**Example directory content of a NXP board layer**

Directory and Files               | Description
:---------------------------------|:---------------------------------------
`Board.clayer.yml`                | Defines the source files and software components of the board layer.
`MCUXpressoConfig/`               | Directory with MCUXpresso generated files.
`MCUXpressoConfig/Board.cgen.yml` | Generator import file that lists MCUXpresso generated files and options.

The `Board.clayer.yml` file defines, with the `generators:` node, options to locate the MCUXpresso generated files in the directory structure of the [software layer](build-overview.md#software-layers). As a board layer is used by many projects, the name of the generator import file should be explicitly specified, as shown below:

```yml
generators:
    options:
    - generator: MCUXpressoConfig
      path: ./MCUXpressoConfig              # path relative to the `*.clayer.yml` file
      name: Board                           # generator import file is named `Board.cgen.yml`.
```
