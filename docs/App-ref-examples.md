# Application Reference Examples

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->

[**CMSIS-Toolbox**](README.md) **> Application Reference Examples**

This chapter explains how to work with *Application Reference Examples* that can run on several evaluation boards.

**Chapter Contents:**

- [Application Reference Examples](#application-reference-examples)
  - [Overview](#overview)
  - [Middleware Examples](#middleware-examples)
    - [MDK Middleware Examples](#mdk-middleware-examples)
    - [Sensor Application Examples](#sensor-application-examples)
    - [Targeting Custom Hardware](#targeting-custom-hardware)
  - [Usage](#usage)
  - [Structure](#structure)
    - [Typical Directory Structure](#typical-directory-structure)
    - [Reference Application Example](#reference-application-example)
    - [Board Layer](#board-layer)
    - [Shield Layer](#shield-layer)
  - [Connections](#connections)
    - [Arduino Shield](#arduino-shield)

## Overview

The CMSIS-Pack format supports two different type of project examples:

- *Board Examples* that are created for a specific hardware. These are typically complete projects that directly interface with board and device peripherals.
- *Application Reference Examples* that use defined interfaces (APIs) and are therefore hardware agnostic. These example projects show usage of middleware components and require additional [software layers](build-overview.md#software-layers) with API drivers for the specific target hardware, typically an evaluation board.
 
The following sections explain the usage, structure, and creation of *Application Reference Examples* that can target many different evaluation boards.

## Middleware Examples

*Application Reference Examples* show the usage of middleware that may run on many different target hardware boards. Such middleware uses [application programming interfaces (APIs)](https://en.wikipedia.org/wiki/API) to interface with hardware interfaces or other software components.

### MDK Middleware Examples

The [MDK Middleware](https://www.keil.arm.com/packs/mdk-middleware-keil) provides software components for IPv4 and IPv6 networking, USB Host and Device communication, and File System for data storage. 

The [MDK Middleware Pack](https://www.keil.arm.com/packs/mdk-middleware-keil) contains *Application Reference Examples* that shows the usage of these these software components. These examples are hardware agnostic; adding a board layer that provides the required APIs allows to run the example project on a specific target hardware. 

![MDK Middleware Example](./images/MDK-MW-Example.png "MDK Middleware Example")

The picture above shows how and USB HID example connects to a board specific software layer.
The *Reference Application Example* does not specify a target hardware. For execution on target hardware a software layer is required that provides the hardware specific APIs. These board specific layers are provided in BSP Packs which allows to run the example on many different hardware targets.

The Reference example uses [`connections:`](YML-Input-Format.md#connections) to list the consumed (required) APIs. The board layer in the BSP Pack provides these [`connections:`](YML-Input-Format.md#connections), and may offer several additional `connections:` that makes the layer suitable for a range of *Reference Application Examples*.

As the *Application Reference Example* is not hardware specific it does not define a target type. It does also not add the board specific software layer. With two steps the `*.csolution.yml` file of such an example is configured for an evaluation board.

1. Specify the evaluation board under `target-types:`. This board should also provide a suitable board specific software layer for the application.
2. Use the command `cbuild setup` to identify the compatible board specific software layer. Add this software layer to your application.
  
***Reference Application Example* `*.csolution.yml` file**

```yml
solution:
  cdefault:
  compiler: AC6
  :
  target-types:
# Step 1: Specify your board, for example with:
#   - type: IMXRT1050-EVKB Board
#     board: NXP::IMXRT1050-EVKB
# Step 2: Run `cbuild setup` and use cbuild-idx.yml to identify variables, for example:
#     variables:
#       - Board-Layer:  %SolutionDir$/board/IMXRT1050-EVKB/board.clayer.yml
```

### Sensor Application Examples

The overall concept of *Reference Application Examples* and the same board specific software layers can be used for a wide range of applications. For example, a Sensor SDK Pack may provide *Reference Application Examples* that show the usage of a MEMS sensor. This MEMS sensor is additional hardware that could be provided by an widely supported Arduino UNO shield.

The Sensor SDK with the related Arduino shield can be structured to work with a wide range of evaluation boards that offer a compatible board specific software layer.

The overall structure of an sensor example project is shown in the picture below. It is composed of:

- The *Reference Application Example* with sensor specific middleware that shows usage of a MEMS sensor.
- `Layer type: Board` contains the hardware specific setup of an evaluation board with an Cortex-M processor along with drivers, i.e. for SPI or I2C that connect to Arduino pins.
- `Layer type: Shield` defines the pin routing of the Arduino UNO shield that adds the MEMS sensor to the evaluation board.

![Sensor Application Example](./images/Sensor-SDK-Example.png "Sensor Application Example")

> **Note:**
>
> As the `connections:` for the MEMS sensor are specific to the sensor itself, the same *Reference Application Example* also works with an evaluation board that integrates the MEMS sensor (and requires therefore no Shield layer). The board specific software layer adds in this case the sensor specific `connections:`.

### Targeting Custom Hardware

The *Reference Application Example* may serve as starting point for user applications that target custom hardware. It is required to provide:

- A software layer with a compatible set of APIs; the `connnections:` consumed by the *Reference Application Example*. This software layer can be added along with the target type that defines the custom hardware.
   > **Note:** It is not required to define `connections:` as this information is only used to identify compatible layers.
- A header file that replaces the <cmsis_board_header> (ToDo - more description).

**Example `*.csolution.yml` file for custom hardware**

```yml
solution:
  cdefault:
  compiler: AC6
  :
  target-types:
    - type: MyHardware
      device: STM32U585AIIx      # custom hardware uses only a device definition
      variables:
        - Board-Layer:  %SolutionDir$/MyTarget/MyHardware.clayer.yml
```

## Usage

ToDo once CMSIS-Toolbox 2.4.0 is complete.

## Structure

The following section describes the overall structure of *Reference Application Examples*.

### Typical Directory Structure

ToDo 

### Reference Application Example

A *Reference Application Example* starts with the C function:

```c
int app_main (void);
```

It may use a RTOS or run a simple `while` loop. Additional software components such as CMSIS-View, CMSIS-DSP, or mbedTLS are added directly to the *Reference Application Example* and not provided by other software layers.  In general the `connections:` that are consumed should be minimized allowing to run the example on many different target boards.

### Board Layer

Provides system startup, board/device hardware initialization, and transfers control to the application. It also exposes various drivers and interfaces.

**Typical Features:**

- System startup including clock configuration
- Heap and Stack configuration
- Device/Board hardware initialization
- Shield setup [optional]
- Calls application startup function
- Drivers for peripherals or Arduino interfaces [optional]
- STDIO re-targeting to debug interfaces [optional]

**Files:**

- CMSIS startup and system file for device initialization.
- `main.c` source module that implements the function `main`.
- Optional drivers and interfaces (CMSIS-Drivers, GPIO, STDIO).
- Files that relate to the device and/or board configuration (i.e. generated by MCUXpresso or STM32CubeMX)
- Linker Script definition for boards that require specific memory configurations.

The parameters of the available APIs are defined in `<cmsis_board_header>`.  ToDo: add more information.

- Do we need driver instance numbers in “connections”?
- Does this header include <cmsis_shield_header> when it exist?

**Generator Usage:**

The board specific software layer is used by many different projects. When a board configuration is generated by tools, for example MCUXpresso or STM32CubeMX, the generator output file name and output directory should be defined. Add therefore the [`generators:`](YML-Input-Format.md#generators) node to the board specific `*.clayer.yml` file as exemplified below: 

```yml
layer:

  generators:
    options:
      - generator: CubeMX
        path: ./CubeMX
        name: Board
```

### Shield Layer

Support for additional hardware via plugin shields (i.e. Arduino Uno).  Arduino shields [*consume connections*](YML-Input-Format.md#example-sensor-shield) with the prefix `ARDUINO_UNO_`.  Potentially other shields could be covered.

Shields may feature various hardware modules such as WiFi chips or MEMS sensors.  Frequently the Shield software layer only defines a header file that redirects the Arduino specific `connect:` to a chip specific `connect:` that is then used by application software.

The Shield software layer is configured from the Board software layer which calls the following function:

``` c
extern int32_t shield_setup (void);
```

## Connections

The [connections](YML-Input-Format.md#connections) are only used to identify compatible software layers. There are no strict rules for the **`connect` Name** it is therefore possible to extend it with additional name spacing, i.e. prefix with *ST_* to denote ST specific interfaces.

There are also no strict rules how the different software layers consume or provide the `connect` names.  However guidelines will be developed once reference applications mature.

Currently the following **`connect` names** are used.

`connect` name         | Value                  | Description
:----------------------|:-----------------------|:--------------------
.                      |.                       | **Arduino Shield Interface**
ARDUINO_UNO_UART       | CMSIS-Driver instance  | CMSIS-Driver UART connecting to UART on Arduino pins D0..D1
ARDUINO_UNO_SPI        | CMSIS-Driver instance  | CMSIS-Driver SPI connecting to SPI on Arduino pins D10..D13
ARDUINO_UNO_I2C        | CMSIS-Driver instance  | CMSIS-Driver I2C connecting to I2C on Arduino pins D20..D21
ARDUINO_UNO_I2C-Alt    | CMSIS-Driver instance  | CMSIS-Driver I2C connecting to I2C on Arduino pins D18..D19
ARDUINO_UNO_D0 .. D21  | -                      | CMSIS-Driver GPIO connecting to Arduino pins D0..D21
.                      |.                       | **CMSIS Driver and RTOS Interfaces**
CMSIS_\<driver-name\>  | CMSIS-Driver instance  | [CMSIS-Driver](https://arm-software.github.io/CMSIS_5/Driver/html/modules.html) name, i.e. CMSIS_I2C, CMSIS_ETH_MAC.
CMSIS-RTOS2            |.                       | CMSIS-RTOS2 compliant RTOS
.                      |.                       | **I/O Retargeting**
STDERR                 |.                       | Standard Error output
STDIN                  |.                       | Standard Input
STDOUT                 |.                       | Standard Output
.                      |.                       | **Memory allocation**
Heap                   | Heap Size              | Memory heap configuration in startup

### Arduino Shield

The software layers [Board](#board-layer) and [Shield](#shield-layer) are currently based on Arduino UNO connectors. To combine different boards and shields a consistent pin naming is required. The standardized mapping is shown in the diagram below.

![Arduino Shield Pinout](./images/Arduino-Shield.png "Arduino Shield Pinout")
