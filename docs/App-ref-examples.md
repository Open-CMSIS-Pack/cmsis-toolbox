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
    - [Project Files](#project-files)
    - [Typical Directory Structure](#typical-directory-structure)
    - [Application Program Start](#application-program-start)
    - [Board Layer](#board-layer)
    - [Shield Layer](#shield-layer)
  - [Connections](#connections)
    - [ARDUINO\_UNO\_UART](#arduino_uno_uart)
    - [ARDUINO\_UNO\_I2C / ARDUINO\_UNO\_I2C-Alt](#arduino_uno_i2c--arduino_uno_i2c-alt)
    - [ARDUINO\_UNO\_SPI](#arduino_uno_spi)
    - [ARDUINO\_UNO\_D0 .. D21](#arduino_uno_d0--d21)
    - [CMSIS\_USB\_Device](#cmsis_usb_device)
    - [CMSIS\_VIO](#cmsis_vio)
  - [Arduino Shield](#arduino-shield)
  - [Header Files](#header-files)

## Overview

The CMSIS-Pack format supports two different types of project examples:

- *Board Examples* that are created for a specific hardware. These are typically complete projects that directly interface with board and device peripherals.
- *Application Reference Examples* that use defined interfaces (APIs) and are therefore hardware agnostic. These example projects show usage of middleware components and require additional [software layers](build-overview.md#software-layers) with API drivers for the specific target hardware, typically an evaluation board.
 
The following sections explain the usage, structure, and creation of *Application Reference Examples* that can target many different evaluation boards.

## Middleware Examples

*Application Reference Examples* show the usage of middleware that may run on many different target hardware boards. Such middleware uses [application programming interfaces (APIs)](https://en.wikipedia.org/wiki/API) to interface with hardware interfaces or other software components.

### MDK Middleware Examples

The [MDK Middleware](https://www.keil.arm.com/packs/mdk-middleware-keil) provides software components for IPv4 and IPv6 networking, USB Host and Device communication, and File System for data storage. 

The [MDK Middleware Pack](https://www.keil.arm.com/packs/mdk-middleware-keil) contains *Application Reference Examples* that shows the usage of these software components. These examples are hardware agnostic; adding a board layer that provides the required APIs allows to run the example project on a specific target hardware. 

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
#       - Board-Layer:  %SolutionDir()$/board/IMXRT1050-EVKB/board.clayer.yml
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

- A software layer with a compatible set of APIs; the `connections:` consumed by the *Reference Application Example*. This software layer can be added along with the target type that defines the custom hardware.
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

A *Reference Application Examples* is an incomplete `*.csolution.yml` project file that requires an compatible software layer for execution. The CMSIS-Toolbox helps you to identify compatible software layers with this process:

ToDo finalize when CMSIS-Toolbox 2.4.0 is released.

## Structure

The following section describes the overall file structure of *Reference Application Examples*.

### Project Files

A `*.csolution.yml` project file that contains software layers for two different evaluation boards should look like shown below.  This project contains three different examples that show different features of a USB device middleware.

The actual example project (HID, MSC, or CDC1) is selected using a [context set](build-overview.md#working-with-context-set); the compiler is selected using the `--toolchain` option. To translate the completed *Reference Application Examples* use:

```bash
cbuild USB-Device.csolution.yml --context-set --toolchain AC6
```

**Example `USB_Device.csolution.yml` file with three different projects**

```yml
solution:
  created-for: CMSIS-Toolbox@2.4.0
  cdefault:

  target-types:
    - type: B-U585I-IOT02A
      board: B-U585I-IOT02A
      variables:
        - Board-Layer: $SolutionDir()$\Board\B-U585I-IOT02A\Board.clayer.yml
 
    - type: LPC55S69-EVK            # type name identical with board name?
      board: LPC55S69-EVK
      variables:
        - Board-Layer: $SolutionDir()$\Board\LPC55S69-EVK\Board.clayer.yml

  build-types:
    - type: Debug
      debug: on
      optimize: debug
    - type: Release
      debug: off
      optimize: balanced

  projects:
    - project: HID/HID.cproject.yml
    - project: MSC/MassStorage.cproject.yml
    - project: CDC1/VirtualCOM.cproject.yml
```

### Typical Directory Structure

The directory structure of the above example from the programmers point of view is shown below.  The software layer in the directory `./Board` is copied from the BSP of the related board.

Directory Content                   | Content
:-----------------------------------|:---------------
`USB_Device.csolution.yml`          | Overall CMSIS solution project file.
`./HID/`                            | HID example project from MDK-Middleware pack.
`./MSC/`                            | MSC example project from MDK-Middleware pack.
`./CDC1/`                           | CDC1 example project from MDK-Middleware pack.
`./Board/B-U585I-IOT02A`            | Board software layer from B-U585I-IOT02A BSP.
`./Board/LPC55S69-EVK`              | Board software layer from LPC55S69-EVK BSP.

### Application Program Start

A *Reference Application Example* starts with the C function `app_main` as shown below.

To access board resources the header file `<cmsis_board_header> is used. This header file includes driver and configuration specific defines of the [Board Layer](#board-layer). When a [Shield Layer](#shield-layer) is added, it also provides settings that reflect the hardware provided by the extension shield. Refer to [Header Files](#header-files) for further information.

```c
#include <cmsis_board_header>    // board resource definitions 

// application example of a middleware component
int app_main (void)  {

};
```

It may use a RTOS or run a simple `while` loop. Additional software components such as CMSIS-View, CMSIS-DSP, or mbedTLS are added directly to the *Reference Application Example* and not provided by other software layers.  In general the `connections:` that are consumed should be minimized allowing to run the example on many different target boards.

### Board Layer

Provides system startup, board/device hardware initialization, and transfers control to the application. It also exposes various drivers and interfaces.

**Typical Features:**

- System startup including clock and memory configuration

- Device/Board hardware initialization
- Calls the application startup function
- Drivers for board peripherals [optional]
- Interfaces to LEDs and switches [optional]
- STDIO re-targeting to debug interfaces [optional]
- Shield setup and drivers for Arduino interfaces [optional]
- Heap and Stack configuration [optional]

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

The board specific software layer is used by many different projects. When a board configuration is generated by tools, for example MCUXpresso or STM32CubeMX,[configure the generator](build-overview.md#configure-generator-output) output directory and import file using the [`generators:`](YML-Input-Format.md#generators) node in the `*.clayer.yml` file as shown below: 

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
[ARDUINO_UNO_UART](#arduino_uno_uart)       | CMSIS-Driver instance  | CMSIS-Driver USART connecting to UART on Arduino pins D0..D1
[ARDUINO_UNO_SPI](#arduino_uno_spi)         | CMSIS-Driver instance  | CMSIS-Driver SPI connecting to SPI on Arduino pins D10..D13; Master Mode and CPOL.CPHA Frame Format (no TI or Microwire)
[ARDUINO_UNO_I2C](#arduino_uno_i2c--arduino_uno_i2c-alt)         | CMSIS-Driver instance  | CMSIS-Driver I2C connecting to I2C on Arduino pins D20..D21
[ARDUINO_UNO_I2C-Alt](#arduino_uno_i2c--arduino_uno_i2c-alt)    | CMSIS-Driver instance  | CMSIS-Driver I2C connecting to I2C on Arduino pins D18..D19
[ARDUINO_UNO_D0 .. D21](#arduino_uno_d0--d21)  | -                      | CMSIS-Driver GPIO connecting to Arduino pins D0..D21
.                      |.                       | **CMSIS Driver and RTOS Interfaces**
[CMSIS_USB_Device](#cmsis_usb_device)     | CMSIS-Driver instance  | CMSIS-Driver USB Device connected to physical board connector
[CMSIS_VIO](#cmsis_vio)     |.   | CMSIS-Driver VIO interface for virtual I/O
CMSIS-RTOS2            |.                       | CMSIS-RTOS2 compliant RTOS
.                      |.                       | **I/O Retargeting**
STDERR                 |.                       | Standard Error output
STDIN                  |.                       | Standard Input
STDOUT                 |.                       | Standard Output
.                      |.                       | **Memory allocation**
Heap                   | Heap Size              | Memory heap configuration

### ARDUINO_UNO_UART

Connects to a [CMSIS-Driver USART Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__usart__interface__gr.html) configured in asynchronous UART mode with no Modem lines.

<cmsis_board_header> contains driver instance number with this define:

```c
#define ARDUINO_UNO_UART    3     // CMSIS-Driver USART instance number
```

### ARDUINO_UNO_I2C / ARDUINO_UNO_I2C-Alt

Connects to a [CMSIS-Driver I2C Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__i2c__interface__gr.html) configured in Master Mode.

<cmsis_board_header> contains driver instance number with this define:

```c
#define ARDUINO_UNO_I2C    0     // CMSIS-Driver I2C instance number
```

### ARDUINO_UNO_SPI 

Connects to a [CMSIS-Driver SPI Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__spi__interface__gr.html) configured in Master Mode and CPOL.CPHA Frame Format (no TI or Microwire). 

The Slave Select (SS) pin (typically on ARDUINO_UNO_D10) is not handled by CMSIS-Driver SPI interface. This is driven by the GPIO interface. 

<cmsis_board_header> contains driver instance number with this define:

```c
#define ARDUINO_UNO_SPI    1     // CMSIS-Driver SPI instance number
```

### ARDUINO_UNO_D0 .. D21

Connects to a [CMSIS-Driver GPIO Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__gpio__interface__gr.html).

<cmsis_board_header> contains the pin mapping to the physical driver.

```c
#define ARDUINO_UNO_D0  GPIO_PORTD(9U)  /* USART3: RX */
#define ARDUINO_UNO_D1  GPIO_PORTD(8U)  /* USART3: TX */
#define ARDUINO_UNO_D2  GPIO_PORTD(15U)
#define ARDUINO_UNO_D3  GPIO_PORTB(2U)
#define ARDUINO_UNO_D4  GPIO_PORTE(7U)
#define ARDUINO_UNO_D5  GPIO_PORTE(0U)
#define ARDUINO_UNO_D6  GPIO_PORTB(6U)
#define ARDUINO_UNO_D7  GPIO_PORTF(13U)
#define ARDUINO_UNO_D8  GPIO_PORTC(1U)
#define ARDUINO_UNO_D9  GPIO_PORTA(8U)
#define ARDUINO_UNO_D10 GPIO_PORTE(12U)
#define ARDUINO_UNO_D11 GPIO_PORTE(15U) /* SPI1: MOSI */
#define ARDUINO_UNO_D12 GPIO_PORTE(14U) /* SPI1: MISO */
#define ARDUINO_UNO_D13 GPIO_PORTE(13U) /* SPI1: SCK  */
#define ARDUINO_UNO_D14 GPIO_PORTC(0U)
#define ARDUINO_UNO_D15 GPIO_PORTC(2U)
#define ARDUINO_UNO_D16 GPIO_PORTC(4U)
#define ARDUINO_UNO_D17 GPIO_PORTC(5U)
#define ARDUINO_UNO_D18 GPIO_PORTA(7U)
#define ARDUINO_UNO_D19 GPIO_PORTB(0U)
#define ARDUINO_UNO_D20 GPIO_PORTB(8U)  /* I2C1: SDA  */
#define ARDUINO_UNO_D21 GPIO_PORTB(9U)  /* I2C1: SCL  */
```

### CMSIS_USB_Device

Connects to a [CMSIS-Driver USB Device Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__usbd__interface__gr.html) that offers a physical USB connector on the evaluation board.

<cmsis_board_header> contains the pin mapping to the physical driver.

```c
#define CMSIS_USB_Device    0     // CMSIS-Driver USB Device instance number
```

### CMSIS_VIO

Connects to a [CMSIS-Driver VIO Interface](https://arm-software.github.io/CMSIS_6/latest/Driver/group__vio__interface__gr.html), a virtual I/O interface that connects on physical boards to LEDs and switches.

## Arduino Shield

The software layers [Board](#board-layer) and [Shield](#shield-layer) are currently based on Arduino UNO connectors. To combine different boards and shields a consistent pin naming is required. The standardized mapping is shown in the diagram below.

![Arduino Shield Pinout](./images/Arduino-Shield.png "Arduino Shield Pinout")

## Header Files

Two header files contain I/O configuration settings for the application program:

- `<cmsis_board_header>` defines the resources available in the [Board Layer](#board-layer).
- `<cmsis_shield_header>` defines settings of the [Shield Layer](#shield-layer). When a shield is applied, this header file is included in the `<cmsis_board_header>`.

Content examples:

**`<cmsis_board_header>`**

```c
#ifndef B_U585I_IOT02A_H_
#define B_U585I_IOT02A_H_

#include "stm32u5xx_hal.h"
#include "GPIO_STM32U5xx.h"
#include "Driver_I2C.h"
#include "Driver_SPI.h"
#include "Driver_USART.h"

// B-U585I-IOT02A Arduino Connector Pin Defintions
#define ARDUINO_UNO_D0  GPIO_PORTD(9U)  /* USART3: RX */
#define ARDUINO_UNO_D1  GPIO_PORTD(8U)  /* USART3: TX */
#define ARDUINO_UNO_D2  GPIO_PORTD(15U)
#define ARDUINO_UNO_D3  GPIO_PORTB(2U)
#define ARDUINO_UNO_D4  GPIO_PORTE(7U)
#define ARDUINO_UNO_D5  GPIO_PORTE(0U)
#define ARDUINO_UNO_D6  GPIO_PORTB(6U)
#define ARDUINO_UNO_D7  GPIO_PORTF(13U)
#define ARDUINO_UNO_D8  GPIO_PORTC(1U)
#define ARDUINO_UNO_D9  GPIO_PORTA(8U)
#define ARDUINO_UNO_D10 GPIO_PORTE(12U)
#define ARDUINO_UNO_D11 GPIO_PORTE(15U) /* SPI1: MOSI */
#define ARDUINO_UNO_D12 GPIO_PORTE(14U) /* SPI1: MISO */
#define ARDUINO_UNO_D13 GPIO_PORTE(13U) /* SPI1: SCK  */
#define ARDUINO_UNO_D14 GPIO_PORTC(0U)
#define ARDUINO_UNO_D15 GPIO_PORTC(2U)
#define ARDUINO_UNO_D16 GPIO_PORTC(4U)
#define ARDUINO_UNO_D17 GPIO_PORTC(5U)
#define ARDUINO_UNO_D18 GPIO_PORTA(7U)
#define ARDUINO_UNO_D19 GPIO_PORTB(0U)
#define ARDUINO_UNO_D20 GPIO_PORTB(8U)  /* I2C1: SDA  */
#define ARDUINO_UNO_D21 GPIO_PORTB(9U)  /* I2C1: SCL  */

// CMSIS Driver instances on Arduino connector
#define ARDUINO_UNO_I2C     1
#define ARDUINO_UNO_SPI     1
#define ARDUINO_UNO_UART    3

// CMSIS Driver instances of Board peripherals
#define CMSIS_DRV_USBD      0  // instance of CMSIS-Driver USB Device

// CMSIS Drivers
extern ARM_DRIVER_I2C   Driver_I2C1;
extern ARM_DRIVER_SPI   Driver_SPI1;
extern ARM_DRIVER_USART Driver_USART1;
extern ARM_DRIVER_USART Driver_USART3;

#ifdef cmsis_shield_header
#include <cmsis_shield_header>
#endif

#endif /* B_U585I_IOT02A_H_ */
```

**`<cmsis_shield_header>`**

```c
#ifndef _FRDM_STBC_AGM01_SHIELD_H_
#define _FRDM_STBC_AGM01_SHIELD_H_

// FRDM-STBC-AGM01 Shield Reset
#define RESET_GPIO              ARDUINO_UNO_D17

#define SHIELD_MULTIB   0
#define SHIELD_NONE     1
#define SHIELD_AGM01    2
#define SHIELD_AGM02    3
#define SHIELD_AGMP03   4
#define SHIELD_AGM04    5
#define THIS_SHIELD     SHIELD_AGM01

// Shield Setup (default configuration)
extern int32_t shield_setup (void);

#endif /* _FRDM_STBC_AGM01_SHIELD_H_ */
```
