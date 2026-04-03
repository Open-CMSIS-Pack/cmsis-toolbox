# Segger J-Link Debugger

!!! Note
    - This section contains preliminary information and is work-in-progress.
  
The CMSIS-Toolbox organizes for debuggers projects and configuration options.
This chapter explains the usage of the [Segger J-Link GDB Server](https://kb.segger.com/J-Link_GDB_Server) in combination with the CMSIS-Toolbox.

- [Extended Options](#extended-options) explains additional configuration features that are required in specific use-cases.

Other manual sections describe how to configure debuggers:

- [Run and Debug Configuration](build-overview.md#run-and-debug-configuration) explains overall structure and how projects and images are configured.
- [Debugger Configuration - J-Link Server](YML-Input-Format.md#j-link-server) contains details about the options that are specific to J-Link.

## Extended Options

The section [Debugger Configuration - J-Link Server](YML-Input-Format.md#j-link-server) contains the J-Link configuration for typical systems.

### `telnet:`

!!! Note
    The `telnet:` feature will be implemented until Dec 2025. This section is only a preview.

J-Link supports a Telnet service that connects to character I/O functions. Character I/O is supported via Semihosting (or SEGGER RTT channel 0). Currently only semihosting is configured for the primary core.

`telnet:`                     |              | Description
:-----------------------------|:-------------|:------------------------------------
`- mode:`                     | **Required** | Redirect output: `server`, `console`, `monitor`, `off` (default).
&nbsp;&nbsp;&nbsp; `pname:`   |   Optional   | Identifies the processor (not required for single core system).
&nbsp;&nbsp;&nbsp; `port:`    |   Optional   | Set TCP/IP port number of Telnet Server (default: 4444, 4445, ... incremented for each processor).

Telnet Mode   | Description
:-------------|:--------------------------------------
`server`      | Serial I/O to Telnet server port
`console`     | Serial output to console (Debug console in VS Code). 
`monitor`     | Serial I/O via TCP/IP port to VS Code Serial Monitor.
`off`         | Serial I/O disabled.

!!! Note
    - The Telnet service is always enabled for the J-Link GDB Server. The mode `off` turns off the data source (semihosting, SEGGER RTT).
    - When no `telnet` node is added then Serial I/O to all processors is set to mode `off`.

### `connect:`

Configures the behavior for connecting J-Link to the hardware target for interactive debug.

`connect:`                                                |              | Description
:---------------------------------------------------------|:-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `mode:`                                | **Required** | Selects the connect mode: `attach`, `halt` (default).

Connect Mode  | Description
:-------------|:--------------------------------------
`attach`      | Do not change state of the core(s). No reset is executed.
`halt`        | Halt core(s) after connect.

### `reset:`

Configures the reset behavior for each core when a reset is requested during interactive debug.

`reset:`                                                  |              | Description
:---------------------------------------------------------|:-------------|:------------------------------------
`- pname:`                                                |   Optional   | Identifies the processor (not required for single core system).
&nbsp;&nbsp;&nbsp; `type:`                                | **Required** | Selects the reset type: `hardware`, `system` (default), `core`.

Reset Types   | Description
:-------------|:--------------------------------------
`hardware`    | Use the J-Link [`reset pin`](https://kb.segger.com/J-Link_Reset_Strategies#Type_2:_reset_pin) reset mode.
`system`      | Use the J-Link [`normal`](https://kb.segger.com/J-Link_Reset_Strategies#Type_0:_normal) reset mode.
`core`        | Use the J-Link [`core`](https://kb.segger.com/J-Link_Reset_Strategies#Type_1:_core) reset mode.

**Examples:**

```yml
debugger:
  name: J-Link Server       # default connect, halt and reset behavior
```

```yml
debugger:
  name: J-Link Server
  connect: attach           # connect without reset and without CPU state change
  reset:
    - type: system          # use system reset
```

```yml
debugger:
  name: J-Link Server
  connect: halt             # halt CPU after connect
  reset:
    - pname: Core0          # for Core0
      type: hardware        # use hardware reset
    - pname: Core1          # for Core1
      type: core            # use core reset
```

### `trace:`

!!! Note
    The `trace:` feature is Work-In-Progress and will be completed in Q1'26.
  
J-Link supports SWO Trace.

`trace:`                      |              | Description
:-----------------------------|:-------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `clock:`   | **Required** | Trace clock frequency in Hz.
&nbsp;&nbsp;&nbsp; `mode:`    |   Optional   | Set Trace Port transport mode. Currently only `SWO-UART` is accepted.
&nbsp;&nbsp;&nbsp; `port:`    |   Optional   | Set TCP/IP port number of Trace output (default: 4444).
