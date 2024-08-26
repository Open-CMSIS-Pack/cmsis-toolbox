# Proposal - Resource Management

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->
<!-- markdownlint-disable MD032 -->

The CMSIS-Toolbox has a simple linker management that assigns all available memory resources to a project. While this is useful for simple projects, it does not provide enough flexibility for multi-processor or multi-project applications.

This is a proposal on how these features could be added.

## Linker Script Management

The current [linker script processing](build-overview.md#linker-script-management) is suitable for single core projects and uses:

![Linker Script File Generation](./images/linker-script-file.png "Linker Script File Generation")

At project level the [`linker:`](YML-Input-Format.md#linker) node specifies the files above.

### Multi-processor or multi-project applications

In a multi-processor or multi-project application the:

- `target type` describes the target hardware. It contains memory resources from the `device:` and optionally `board:`. For many applications it is beneficial to list all resources in a single header file (that is specific to a `target type`.)
- A project uses a subset of resources (called regions at linker level).
- Depending on `build-types` the resources may need adjustments.

A potential solution could be: 

- Target specific `regions+target.h` file that contains all available memory regions and allows to partition these regions for each project. This file could be auto-generated based on the information available in DFP and BSP. The `define` symbols for `ROM0..3`, `RAM0..3` would be extended with a project (see example below). 

- Project specific linker scripts that include the `regions+target.h` file.  The project specific linker scripts use the extended `define` symbols described above.

**Example:**

The following is the `*.csolution.yml` file.  It contains 4 projects: `Core2`, `TFM`, `MQTT_AWS`, and `Bootloader`.

```yml
  target-types:
    type: MyTarget

  projects:
    - project: ./core2/Core2.cproject.yml            # Project that runs on a second core
    - project: ./security/TFM.cproject.yml           # Secure project 
    - project: ./application/MQTT_AWS.cproject.yml   # Non-secure project 
    - project: ./bootloader/Bootloader.cproject.yml  # Secure project (transfers control to TFM)
```

`regions-MyTarget.h`

```
// <h>ROM Configuration
// =======================
// <h> __ROM0=Flash
//   <o> Base address <0x0-0xFFFFFFFF:8>
//   <i> Defines base address of memory region.
//   <i> Default: 0x08000000
#define __ROM0_BASE 0x08000000
//   <o> Region size [bytes] <0x0-0xFFFFFFFF:8>
//   <i> Defines size of memory region.
//   <i> Default: 0x00200000
#define __ROM0_SIZE 0x00200000

// This are user configurable sizes
#define __ROM0_SIZE_Core2      0x10000
#define __ROM0_SIZE_TFM        0x0
#define __ROM0_SIZE_MQTT_AWS   0x20000
#define __ROM0_SIZE_BootLoader 0x40000

// This is the allocation order
#define __ROM0_BASE_Core2      __ROM0_BASE
#define __ROM0_BASE_TFM        (__ROM0_BASE_Core2+__ROM0_SIZE_Core2)
#define __ROM0_BASE_MQTT_AWS   (__ROM0_BASE_TFM+__ROM0_SIZE_TFM)
#define __ROM0_BASE_BootLoader (__ROM0_MQTT_AWS+__ROM0_MQTT_AWS)

 // similar information is generated for ROM1..ROM3 + RAM0..RAM4
 // in case that memory is only available for a core, only a fraction of the project is created
```

The linker script is extended for each project using the project name.  The copy process is similar to an %instance%, but expands %project% with the project name.

Generic linker script `ac6_linker_script.sct.src`

```
LR_ROM0 __ROM0_BASE_TFM __ROM0_SIZE_TFM  {

  ER_ROM0 __ROM0_BASE_TFM __ROM0_SIZE_TFM {
    *.o (RESET, +First)
    *(InRoot$$Sections)
    *(+RO +XO)
  }

#if defined (__ARM_FEATURE_CMSE) && (__ARM_FEATURE_CMSE == 3U)
  ER_CMSE_VENEER AlignExpr(+0, 32) (__ROM0_SIZE_TFM - AlignExpr(ImageLength(ER_ROM0), 32)) {
    *(Veneer$$CMSE)
  }
#endif

  RW_NOINIT __RAM0_BASE_TFM UNINIT (__RAM0_SIZE_TFM - __HEAP_SIZE - __STACK_SIZE - __STACKSEAL_SIZE) {
    *.o(.bss.noinit)
    *.o(.bss.noinit.*)
  }

  RW_RAM0 AlignExpr(+0, 8) (__RAM0_SIZE_TFM - __HEAP_SIZE - __STACK_SIZE - __STACKSEAL_SIZE - AlignExpr(ImageLength(RW_NOINIT), 8)) {
    *(+RW +ZI)
  }
  :
```

`ac6_linker_script.sct.src` expanded for TFM project

```
LR_ROM0 __ROM0_BASE_TFM __ROM0_SIZE_TFM  {

  ER_ROM0 __ROM0_BASE_TFM __ROM0_SIZE_TFM {
    *.o (RESET, +First)
    *(InRoot$$Sections)
    *(+RO +XO)
  }

#if defined (__ARM_FEATURE_CMSE) && (__ARM_FEATURE_CMSE == 3U)
  ER_CMSE_VENEER AlignExpr(+0, 32) (__ROM0_SIZE_TFM - AlignExpr(ImageLength(ER_ROM0), 32)) {
    *(Veneer$$CMSE)
  }
#endif

  RW_NOINIT __RAM0_BASE_TFM UNINIT (__RAM0_SIZE_TFM - __HEAP_SIZE - __STACK_SIZE - __STACKSEAL_SIZE) {
    *.o(.bss.noinit)
    *.o(.bss.noinit.*)
  }

  RW_RAM0 AlignExpr(+0, 8) (__RAM0_SIZE_TFM - __HEAP_SIZE - __STACK_SIZE - __STACKSEAL_SIZE - AlignExpr(ImageLength(RW_NOINIT), 8)) {
    *(+RW +ZI)
  }
  :
```

