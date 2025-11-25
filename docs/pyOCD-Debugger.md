# pyOCD Debugger

!!! Note
    - This section contains preliminary information and is work-in-progress.
  
The CMSIS-Toolbox organizes for debuggers projects and configuration options.
This chapter explains the usage of the [pyOCD](https://pyocd.io/) Debugger in combination with the CMSIS-Toolbox.

- [Extended Options](#extended-options) explains additional configuration features that are required in specific use-cases.
- [Command Line Invocation](#command-line-invocation) describes how to call pyOCD directly from the command-line.
- [`cbuild-run:`](#cbuild-run) explains the configuration file that describes the overall pyOCD system setup.

Other manual sections describe how to configure debuggers:

- [Run and Debug Configuration](build-overview.md#run-and-debug-configuration) explains overall structure and how projects and images are configured.
- [Debugger Configuration - pyOCD](YML-Input-Format.md#pyocd) contains details about the options that are specific to pyOCD.

## Extended Options

The section [CSolution Project Format - pyOCD](YML-Input-Format.md#pyocd) contains the pyOCD configuration for typical systems.

Extended YML options are required to configure specific use-cases or overwrite information that is typically provided in the [DFP](build-overview.md#overview-of-operation).

CMSIS-DAP based Debug Adapters implement [debug access sequences](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#pdsc_SequenceNameEnum_pg) that are configured in the [DFP for a device](build-overview.md#overview-of-operation).

### `connect:`

Configures the behavior for connecting pyOCD to the hardware target.

`connect:`                                                |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `mode:`                                |**Required** | Selects the connect mode: `pre-reset`, `under-reset`, `attach`, `halt`.

Connect Mode  | Description
:-------------|:--------------------------------------
`pre-reset`   | Apply a hardware reset before connect. Sequence: [ResetHardware](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetHardware).
`under-reset` | Asserts a hardware reset using during connect and de-asserts after core(s) are halted. Sequence: [ResetHardwareAssert](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetHardwareAssert), [ResetHardwareDeassert](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetHardwareDeassert).
`attach`      | Do not change status of the core(s). No sequence is executed. ToDo: review StopProcessor as there is no squence.
`halt`        | Halt core(s) after connect. Sequence:  [ResetCatchSet](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetCatchSet), [ResetCatchClear](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetCatchClear).

### `reset:`

Configures the reset behavior for each core when a reset is requested.

`reset:`                                                  |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
`- pname:`                                                |  Optional   | Identifies the processor (not requried for single core system).
&nbsp;&nbsp;&nbsp; `type:`                                |**Required** | Selects the reset type: `hardware`, `system`, `core`. Default: specified in DFP by todo.

Reset Types   | Description
:-------------|:--------------------------------------
`hardware`    | Use the Reset pin of the debug adapter. Sequence: [ResetHardware](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetHardware).
`system`      | Use a system-wide reset via software mechanism. Sequence: [ResetSystem](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetSystem).
`core`        | Use a processor reset via software mechanism. Sequence: [ResetProcessor](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetProcessor)

!!! Note
    - The `defaultResetSequence` in DFP element [/package/devices/family/.../debug](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/pdsc_family_pg.html#element_debug) can define a different default reset type. If no `defaultResetSequence` the default reset type is `system`.

### `load-setup:`

Configures the debug sequences executed during the `load` command of pyOCD.

ToDo: missing is a overall flow chart of load and run sequences.  When is connect executed, etc.  Does pyOCD use Verify?  This info may go into pyOCD-Debugger.md.

`load-cmd:`                       |             | Description
:---------------------------------|:------------|:-----------------------------------------------
&nbsp;&nbsp;&nbsp; `halt:`        |  Optional   | Halt core(s) before load: `on` (default), `off`. Sequence: [ResetCatchSet](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetCatchSet), [ResetCatchClear](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/debug_description.html#resetCatchClear).
&nbsp;&nbsp;&nbsp; `pre-reset:`   |  Optional   | Reset type before loading: `off`, `hardware`, `system`, `core`. Default: specified in DFP (ToDo how???].
&nbsp;&nbsp;&nbsp; `post-reset:`  |  Optional   | Reset type after loading: `off`, `hardware` (default), `system`, `core`.

**Examples:**

```yml
debugger:
  name: CMSIS-DAP@pyOCD     # default connect, halt and reset behavior
```

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  connect: under-reset      # connect under hardware reset
  reset:
    - type: system          # use system reset
  load-setup:
    halt: on                # halt core after load
    post-reset: hardware    # use hardware reset after load
```

```yml
debugger:
  name: CMSIS-DAP@pyOCD
  connect: pre-reset        # apply hardware reset before connect
  reset:
    - pname: Core0          # for Core0
      type: hardware        # use hardware reset
    - pname: Core1          # for Core1
      type: system          # use system reset
  load-stop:
    post-reset: off         # no reset after load
```

### `trace:`

!!! Note
    The `trace:` feature will be implemented until Dec 2025. This section is only a preview.

CMSIS-DAP supports the SWO trace output of Cortex-M devices. The device-specific trace features are configured using the `*.dbgconf` file.

The default trace output file and location is derived from the [`cbuild-run.yml` file](YML-CBuild-Format.md#run-and-debug-management) and uses the extension `<pname>.txt`, format: `<solution-name>+<target-type>.trace`

`trace:`                                                  |             | Description
:---------------------------------------------------------|-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `mode:`                                |**Required** | Trace: `off` (default), `server`, `file`.
&nbsp;&nbsp;&nbsp; `clock:`                               |**Required** | Trace clock frequency in Hz.
&nbsp;&nbsp;&nbsp; `port-type:`                           |  Optional   | Set Trace Port transport mode. Currently only `SWO-UART` is accepted.
&nbsp;&nbsp;&nbsp; `baudrate:`                            |  Optional   | Maxium baudrate for `SWO-UART` mode.
&nbsp;&nbsp;&nbsp; `port:`                                |  Optional   | Set TCP/IP port number of Trace Server (default: 5555).
&nbsp;&nbsp;&nbsp; `file:`                                |  Optional   | Explicit path and name of the trace output file. Default: `<solution-name>+<target-type>.trace`.

## Command Line Invocation

The CMSIS-Toolbox debugger configuration is provided in the [file `*.cbuild-run.yml`](YML-CBuild-Format.md#file-structure-of-cbuild-runyml). Use the following command line syntax to leverage this information:

```bash
>pyOCD <command> --cbuild-run <cbuild-run.yml file> [options]
```

`<command>`          | Description
:--------------------|:-------------------------------------
`run`                | Execute application.
`erase`              | Erase device
`load`               | Load image to device.

`<options>`          | Description
:--------------------|:-------------------------------------
`--timelimit sec`    | Terminate pyOCD when the timelimit is reached.  Applies to `run` command only.
`--eot`              | Terminate when EOT character (`0x04`) is printed via a telnet channel. Applies to `run` command only.
`--load`             | Erase device and flash program the images specified in cbuild-run.yml. Applies to `run` command only.
`--udi <id>`         | Specify an id of a debug probe

**Examples:**

ToDo: command line examples

## Content of `cbuild-run.yml`

This section details the content of `cbuild-run.yml` file and how it is used to configure pyOCD. The `cbuild-run.yml` file is generated by the CMSIS-Toolbox from the information provided in the *csolution project*.
However, it is possible to create a `*.cbuild-run.yml` file manually and the following section explains the file structure.

**Configuration File Example:**

```yml
todo
```

## `cbuild-run:`

The `cbuild-run:` node is the start of a `*.cbuild-run.yml` file.

`cbuild-run:`                                               |            | Content
:-----------------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; `device:`                                |  Optional  | Identifies the device.
&nbsp;&nbsp;&nbsp; `device-pack:`                           |  Optional  | Identifies the device pack used.
&nbsp;&nbsp;&nbsp; [`output:`](#output)                     |  Optional  | Lists the possible compiler selection that this project is tested with.
&nbsp;&nbsp;&nbsp; [`system-resources:`](#system-resources) |  Optional  | When specified, the [`cdefault.yml`](build-overview.md#cdefaultyml) file is used to setup compiler specific controls.

### `output:`

`output:`                                                   |            | Content
:-----------------------------------------------------------|:-----------|:------------------------------------
&nbsp;&nbsp;&nbsp; `device:`                                |  Optional  | Identifies the device.
&nbsp;&nbsp;&nbsp; `device-pack:`                           |  Optional  | Identifies the device pack used.
&nbsp;&nbsp;&nbsp; [`output:`](#output)                     |  Optional  | Lists the possible compiler selection that this project is tested with.
&nbsp;&nbsp;&nbsp; [`system-resources:`](#system-resources) |  Optional  | When specified, the [`cdefault.yml`](build-overview.md#cdefaultyml) file is used to setup compiler specific controls.

### `system-resources:`

```yml
cbuild-run:
  device:
  device-pack:      ? is the board-pack: not used?
  output:
    - file:
      info:
      type:
      load-offset:
      load:
      pname:
  system-resources:
    memory:
      - name:
        access:
        start:
        size:
        pname:
        alias:
        from-pack:
  system-descriptions:
    - file:
      type:
      pname:
  debugger:
    name:
    clock:
    dbgconf:
    start-pname:
    gdbserver:
      - port:
        pname:
      - port:
        pname:
  debug-vars:
    vars:
  debug-sequences:
    - name:
      info:
      pname:
      blocks:
        - info:
          if:
          while:
          execute:
          timeout:
          atomic:
          blocks:
  programming:
    - algorithm:
      ram-start:
      size:
      ram-start:
      ram-size:
      pname:
  debug-topology:
    debugports:
      - dpid:
        accessports:
          - apid:
            address:
            index:
    processors:
      - pname:
        apid:
    swj:
    dormant:
```
