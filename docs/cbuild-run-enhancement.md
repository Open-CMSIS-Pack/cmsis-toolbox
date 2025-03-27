## `cbuild-run:`

### `debug:`
`debug:`                                          | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `config:`                      |        |   Optional   | Default debugger configuration for a target connection.
&nbsp;&nbsp;&nbsp; `debugports:`                  |        |   Optional   | Describes CoreSight debug ports of the device and its capabilities. If not provided a single debug port and access port (APv1) with index `0` will be implicitly used.
&nbsp;&nbsp;&nbsp; `processors:`                  |        |   Optional   | Mapping of processor identifiers, their default reset sequences and access port unique IDs. This node is mandatory for devices that embed multiple processors.

`config:`                                         | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `protocol:`                    | string |   Optional   | Specifies the default debug protocol to use for target connections. Predefined values: `jtag`, `swd`. Default value is `swd`.
&nbsp;&nbsp;&nbsp; `clock:`                       | uint   |   Optional   | Specifies the default debug clock setting in Hz for a target connection. Default value is `10000000`.
&nbsp;&nbsp;&nbsp; `swj:`                         | bool   |   Optional   | The device is accessed via a CoreSight SWJ-DP capable of switching between Serial Wire Debug (SWD) and JTAG protocols. Default value is `true`.
&nbsp;&nbsp;&nbsp; `dormant:`                     | bool   |   Optional   | The device is accessed via a CoreSight DP that requires the dormant state to switch debug protocols. Default value is `false`.

`debugports:`                                     | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- dp:`                                           | uint   | **Required** | Unique ID of this debug port.
&nbsp;&nbsp;&nbsp; `jtag:`                        |        |   Optional   | Describes JTAG Test Access Port (TAP) properties of this debug port.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `tapindex:`  | uint   |   Optional   | Specifies the TAP index relative to the JTAG scan chain of this device from TDI to TDO. Default value is `0`.
&nbsp;&nbsp;&nbsp; `swd:`                         |        |   Optional   | Describes CoreSight Serial Wire Debug Port (SW-DP) properties of this debug port.
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `targetsel:` | uint   |   Optional   | SWD muti-drop target selection.
&nbsp;&nbsp;&nbsp; `accessports:`                 |        |   Optional   | List of device CoreSight access ports (APv1/APv2). Mandatory for devices that embed multiple processors. If not provided access port (APv1) with index `0` will be implicitly used.

`accessports:`                                    | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- apid:`                                         | uint   | **Required** | Unique ID of this access port. If only `apid` is provided, access port (APv1) with index `0` will be implicitly used.
&nbsp;&nbsp;&nbsp; `index:`                       | uint   |   Optional   | The index to select this access port (APv1) for a target access.
&nbsp;&nbsp;&nbsp; `address:`                     | uint   |   Optional   | The address to select this access port (APv2) in its parent's address space for a target access.
&nbsp;&nbsp;&nbsp; _`accessports:`_               |        |   Optional   | Nested CoreSight access ports (APv2).

`processors:`                                     | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- pname:`                                        | string | **Required** | Processor identifier. This node is mandatory for devices that embed multiple processors.
&nbsp;&nbsp;&nbsp; _`punits:`_                    |        |   Optional   | Specifies processor units in a symmetric multi-processor core (MPCore). Mandatory if multiple CPU debug blocks are accessible via a single AP.
&nbsp;&nbsp;&nbsp; `apid:`                        | uint   | **Required** | Default access port ID to use for target accesses in this debug connection.
&nbsp;&nbsp;&nbsp; `defaultResetSequence:`        | string |   Optional   | Specifies the debug sequence that shall be used by default for the reset operation. If not specified then `ResetSystem` sequence will be set as default.

_`punits:`_                                       | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
_`- punit:`_                                      | uint   | **Required** | Specifies a specific processor unit of a symmetric MPCore.
&nbsp;&nbsp;&nbsp; _`address:`_                   | uint   | **Required** | Specifies the base address of the CPU debug block.

>Nodes in _italic_ can be skipped for now and considered in the future.

### `programming:`
`programming:`                                    | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- algorithm:`                                    | string | **Required** | Flash Programming Algorithm file including the path.
&nbsp;&nbsp;&nbsp; `start:`                       | uint   | **Required** | Start address of flash covered by the Flash programming algorithm.
&nbsp;&nbsp;&nbsp; `size:`                        | uint   | **Required** | Size of flash covered by the Flash programming algorithm.
&nbsp;&nbsp;&nbsp; `ram-start:`                   | uint   | **Required** | Start address of the RAM where the Flash programming algorithm will be executed from.
&nbsp;&nbsp;&nbsp; `ram-size:`                    | uint   | **Required** | Maximum size of RAM available for the execution of the Flash programming algorithm.
&nbsp;&nbsp;&nbsp; `default:`                     | bool   |   Optional   | If `true`, then this is the default Flash programming algorithm that gets configured in a project. Default value is `false`.
&nbsp;&nbsp;&nbsp; `pname:`                       | string |   Optional   | Processor identifier. Mandatory for devices that embed multiple processors that require different algorithms.


### `system-descriptions:`
`system-descriptions:`                            | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- file:`                                         | string | **Required** | Specifies the file name including the path.
&nbsp;&nbsp;&nbsp; `type:`                        | string | **Required** | Specifies the file type. Predefined values: `svd`, `sdf`.
&nbsp;&nbsp;&nbsp; `info:`                        | string |   Optional   | Brief description of the file.


### `output:`
`output:`                                         | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- file:`                                         | string | **Required** | Specifies the file name including the path.
&nbsp;&nbsp;&nbsp; `type:`                        | string | **Required** | Specifies the file type. Predefined values: `lib`, `elf`, `hex`, `bin`, `map`.
&nbsp;&nbsp;&nbsp; `info:`                        | string |   Optional   | Brief description of the file.
&nbsp;&nbsp;&nbsp; `run:`                         | string |   Optional   | Additional command string for download or programming.
&nbsp;&nbsp;&nbsp; `debug:`                       | string |   Optional   | Additional command string for debug.
> Where do `run` and `debug` come from?

### `system-resources:`
`system-resources:`                               | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `memory:`                      |        |   Optional   | Identifies the section for memory.

`memory:`                                         | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- name:`                                         | string | **Required** | Name of the memory region (when PDSC contains id, it uses the id as name).
&nbsp;&nbsp;&nbsp; `access:`                      | string | **Required** | Access permission of the memory (combination of `r`, `w`, `x`, `p`, `s`, `n`, `c`).
&nbsp;&nbsp;&nbsp; `start:`                       | uint   | **Required** | Start address of the memory.
&nbsp;&nbsp;&nbsp; `size:`                        | uint   | **Required** | Size of the memory.
&nbsp;&nbsp;&nbsp; `default:`                     | bool   |   Optional   | Memory is always accessible. Default value is `false`.
&nbsp;&nbsp;&nbsp; `startup:`                     | bool   |   Optional   | Default startup code location (vector table). Default value is `false`.
&nbsp;&nbsp;&nbsp; `pname:`                       | string |   Optional   | Only accessible by a specific processor.
&nbsp;&nbsp;&nbsp; `uninit:`                      | bool   |   Optional   | If `true`, the memory region shall be kept uninitialized. Default value is `false`.
&nbsp;&nbsp;&nbsp; `alias:`                       | string |   Optional   | Name of identical memory exposed at a different address.
&nbsp;&nbsp;&nbsp; `from-pack:`                   | string |   Optional   | Pack that defines this memory.
>`uninit` is a SW view and IMHO we should remove it. Same for `startup`.

### `debugger:`
`debugger:`                                       | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- name:`                                         | string | **Required** | Identifies the debug configuration.
&nbsp;&nbsp;&nbsp; `info:`                        | string |   Optional   | Brief description of the connection.
&nbsp;&nbsp;&nbsp; `port:`                        | string |   Optional   | Selected debug port (`jtag` or `swd`).
&nbsp;&nbsp;&nbsp; `clock:`                       | uint   |   Optional   | Selected debug clock speed in Hz.
&nbsp;&nbsp;&nbsp; `dbgconf:`                     | string |   Optional   | Debugger configuration file including the path (pinout, trace).
> Should `port` be renamed to `protocol` (see `debug:` `config:`)?

### `debug-vars:`
`debug-vars:`                                     | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
&nbsp;&nbsp;&nbsp; `vars:`                        | string |   Optional   | Initial values for debug variables used in [`debug-sequences:`](#debug-sequences).


### `debug-sequences:`
`debug-sequences:`                                | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- name:`                                         | string | **Required** | Name of the sequence. It overrides a predefined debug access sequence with the same name.
&nbsp;&nbsp;&nbsp; `info:`                        | string |   Optional   | Descriptive text to display for example for error diagnostics.
&nbsp;&nbsp;&nbsp; `blocks:`                      | string |   Optional   | A list of command blocks in order of execution.
&nbsp;&nbsp;&nbsp; `pname:`                       | string |   Optional   | Executes sequence only for a specific processor; default is for all processors.
>`disable` attribute from PDSC can be emulated by providing a sequence with the same name but without any `blocks:`.

`blocks:`                                         | Value  |   Use        | Content
:-------------------------------------------------|--------|--------------|:------------------------------------
`- info:`                                         | string |   Optional   | Descriptive text to display for example for error diagnostics.
&nbsp;&nbsp;&nbsp; `blocks:`                      | string |   Optional   | A list of command blocks in the order of execution.
&nbsp;&nbsp;&nbsp; `execute:`                     | string |   Optional   | Commands for execution.
&nbsp;&nbsp;&nbsp; `atomic:`                      | bool   |   Optional   | Atomic execution of commands; cannot be used with `blocks:`. Default value is `false`.
&nbsp;&nbsp;&nbsp; `if:`                          | string |   Optional   | Only executed when expression is true.
&nbsp;&nbsp;&nbsp; `while:`                       | string |   Optional   | Executed in loop until while expression is true.
&nbsp;&nbsp;&nbsp; `timeout:`                     | uint   |   Optional   | Timeout in milliseconds for while loop.
