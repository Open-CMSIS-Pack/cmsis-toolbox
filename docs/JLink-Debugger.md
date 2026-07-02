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

J-Link supports a Telnet service that connects to character I/O functions. Character I/O is supported via Semihosting (or SEGGER RTT channel 0). Currently only semihosting is configured for the primary core.

`telnet:`                     |              | Description
:-----------------------------|:-------------|:------------------------------------
`- mode:`                     | **Required** | Redirect output: `off` (default), `server`, `console`, `monitor`.
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
    The `trace:` feature is under development. This section provides a preview.
  
J-Link supports the SWO trace output of Cortex-M devices. The raw trace data are made available from the J-Link GDB Server through a TCP connection.

The `trace:` node has one child type per supported trace transport mode which offers mode-specific options. Currently, the [`swo-uart`](#swo-uart) type is supported.

!!! Note
    The `trace:` node is implemented as a list. However, currently only one node is supported. Additional nodes are ignored.

```yml
trace:
  - swo-uart: TraceConfigName # Trace mode is SWO UART
    input-clock: 120000000    # Trace clock = 120 MHz
```

#### `swo-uart`

`trace:`                                  |              | Description
:-----------------------------------------|:-------------|:------------------------------------
`- swo-uart:`                             | **Required** | Transport mode is SWO UART. The node allows an optional name (default: `null`).
&nbsp;&nbsp;&nbsp; `mode:`                |   Optional   | Trace: `off` (default), `server`.
&nbsp;&nbsp;&nbsp; `input-clock:`         | **Required** | Trace input clock frequency in Hz.
&nbsp;&nbsp;&nbsp; `output-clock:`        |   Optional   | Trace output clock frequency in Hz, i.e. the baudrate, for the SWO output.
&nbsp;&nbsp;&nbsp; `server-port:`         |   Optional   | Set TCP/IP port number of trace server in `server` mode (default: 5555).

#### Trace Clocks

1. Trace `input-clock` is the frequency of the clock signal that goes into the trace port component. It equals the CPU clock frequency for the majority of systems with trace from a single core.
For more complex multi-core systems, the clock is normally derived from the system clock. Refer to the device manual and setup to find the exact value.
2. Trace `output-clock` is the clock frequency of the trace output signal. It is used to configure trace capture of the debug unit, and to calculate trace port prescaler values that need to be programmed. If not provided or if the value is `0`, then a best matching output frequency is automatically calculated based on `input-clock` and supported trace capture frequencies/baudrates of the debug unit.
