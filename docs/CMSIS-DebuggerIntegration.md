# CMSIS Debugger Integration

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->
<!-- markdownlint-disable MD032 -->

This document summarizes how to integrate the CMSIS-Debugger and pyOCD into the workflows.

## Summary of Proposed Changes

- Add/change [CMSIS View Action buttons](#cmsis-view-action-buttons)
- One or more [target-set configurations](#changes-cmsis-toolbox) are stored in `csolution.yml` for each target.
- [Manage Solution](#manage-solution) dialog allows debugger configuration.
- [launch.json and tasks.json update process](#launchjson-and-tasksjson-update-process) to enable load and run commands.
- [Multi-Workspace](#multi-workspace) command to access the solution workspace.
- [Build Information File Locations](#build-information-file-locations)
- [ToDo's](#todos) is a list of open questions

## Overview

The diagram below shows how the VS Code Debugger uses the GDB server ports of a multi-processor system. The SoC is in this case a heterogenous processor system with one Cortex-A running Linux and a dual-core Cortex-M system. Using a debug adapter with GDB server (for the Cortex-M part exemplified with pyOCD and CMSIS-DAP), the connection to each core is represented by one GDB Port. The GDB server that is part of Linux offers another GDB Port.

For trace capturing, a separate Trace Port is used. The information may be streamed to data files for analysis.

![CMSIS Debugger Overview](./images/CMSIS-Debugger-Overview.png "CMSIS Debugger Overview")

The integration in VS Code works via:
- [Arm CMSIS Solution](https://marketplace.visualstudio.com/items?itemName=Arm.cmsis-csolution) extension for project management.
- [Arm CMSIS Debugger](https://marketplace.visualstudio.com/items?itemName=Arm.vscode-cmsis-debugger) for bare metal targets connected a debug adapter with GDB server (pyOCD with CMSIS-DAP or ST-Link, JLINK GDB Server, etc.).
- [Microsoft C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools) extension for Linux user space or application debugging.

## CMSIS View Action buttons

The CMSIS View offers for the bare metal targets action buttons to:
- **Load & Run** a *csolution* application which downloads and starts the image in the target.
- **Load & Debug** a *csolution* application which downloads the image and starts the debugger.
- **Manage Solution** configures the solution.  For each target, the context set stores the project and debug adapter selection. Multiple context set configuration can be selected.


        "multicore-start":        // for start processor in multi-core systems
            {
                "name": "%gdbserver-pname %debugger-name"
                "type": "gdbtarget",
                "request": "launch",
                "cwd": "${workspaceFolder}",
                "program": %symbol-file-list
                "gdb": "arm-none-eabi-gdb",
                "preLaunchTask": "CMSIS Load",  // Load is executed via the dedicated task
                "initCommands": [
                    "tbreak main"
                ],
                "target": {
                    "server": "pyocd",
                    "port": %gdbserver-port
                },
                "cmsis": {
                    "cbuildRunFile": %{cmsis-csolution.getCbuildRunFile}
                    "pname:" %gdbserver-pname
                    "target-type": %target-type
                    "updateConfiguration": "auto" 
                }
            }
    
        "multicore-other:"    // added multiple times for each processors (that is not start) in multi-core systems
                "name": "%gdbserver-pname %debugger-name"
                "type": "gdbtarget",
                "request": "attach",
                "cwd": "${workspaceFolder}",
                "program": %symbol-file-list
                "gdb": "arm-none-eabi-gdb",
                "initCommands": [
                ],
                "target": {
                    "server": "pyocd",
                    "port": %gdbserver-port
                },
                "cmsis": {
                    "pname:" %gdbserver-pname
                    "target-type": %target-type
                    "updateConfiguration": "auto" 
                }
            }
        }
    
    "tasks:" [                       // section to update tasks.json
        {
            "label": "CMSIS Load+Run",
            "type": "shell",
            "command": [
                "pyocd load --no-reset --cbuild-run ${command:cmsis-csolution.getCbuildRunFile}",
                "pyocd gdbserver --reset-run --cbuild-run ${command:cmsis-csolution.getCbuildRunFile}",
            ],
            "problemMatcher": [],
        },
        {
            "label": "CMSIS Load",
            "type": "shell",
            "command": [
                "pyocd load --cbuild-run ${command:cmsis-csolution.getCbuildRunFile}",
            ],
            "problemMatcher": [],
        },
        {
            "label": "CMSIS Erase",
            "type": "shell",
            "command": [
                "pyocd erase --chip --cbuild-run ${command:cmsis-csolution.getCbuildRunFile}",
            ],
            "problemMatcher": [],
        }
    ]
```

Example of `launch.json` updated for multicore configuration.

**launch.json: Example for multicore:**

```json
    "configurations": [
        {
            "name": "cm33_core0 CMSIS-DAP@pyOCD",
            "type": "gdbtarget",
            "request": "launch",
            "cwd": "${workspaceFolder}",
            "program": "./out/core0/MCXN947/Debug/core0.axf",
            "gdb": "arm-none-eabi-gdb",
            "preLaunchTask": "CMSIS Load",  // Load is executed via the dedicated task
            "initCommands": [
                "tbreak main"
            ],
            "target": {
                "server": "pyocd",
                "port": "3333"
            },
            "cmsis": {
                "cbuildRunFile": "%{cmsis-csolution.getCbuildRunFile}",
                "pname": cm33_core0
                "target-type": MCXN947 
                "updateConfiguration": "auto" 
            }
        },
        {
            "name": "cm33_core1 CMSIS-DAP@pyOCD",
            "type": "gdbtarget",
            "request": "attach",
            "cwd": "${workspaceFolder}",
            "program": "./out/core1/MCXN947/Debug/core1_image.axf",
            "gdb": "arm-none-eabi-gdb",
            "target": {
                "port": "3334"
            },
            "cmsis": {
                "pname:" cm33_core1  // only if mapped to "debugger:gdbserver:processors:port", otherwise not provided
                "target-type": MCXN947 
                "updateConfiguration": "auto" 
            }
        }
    ]
```

## Multi-Workspace

[Problem #156](https://github.com/Open-CMSIS-Pack/vscode-cmsis-debugger/issues/156) describes that `${workspaceFolder}` does not work in multi-workspace configurations.
As Linux App and Cortex-M software development is supported in the same IDE, this issue should be solved.

The proposal here is to replace `${workspaceFolder}` with `${cmsis-csolution.workspaceFolder}` in above scripts.

### New csolution Feature

Command                               | Description
:-------------------------------------|:-----------------------------------------------------
`cmsis-csolution.workspaceFolder`     | Resolves to workspace path of active *csolution project*. Solves [problem #156](https://github.com/Open-CMSIS-Pack/vscode-cmsis-debugger/issues/156)

### Test Environment for Multi-Workspace

- Open [NXP_FRDM-MCXN947 DualCore](https://github.com/Open-CMSIS-Pack/NXP_FRDM-MCXN947_BSP/tree/cmsis-debugger/boards/frdmmcxn947/cmsis/examples/DualCore) - branch "cmsis-debugger"
- Use *File - Add Folder to Workspace()* and add https://github.com/Open-CMSIS-Pack/csolution-examples

Using "Select Active Solution from Workspace" allows to select the active solution, but unfortunately does not select the right `/.vscode` folder for `launch.json` and `tasks.json`

## Build Information File Locations

The locations for the build information files should change as follows:

- `*.cbuild-run.yml` file relocate to `out`  (specified in csolution.yml with `output-dirs:`, but $Project$, $TargetType$, and $BuildType$ are replaced by empty strings).
- `*.cbuild.yml` file relocate to `out\$Project$\$TargetType$\$BuildType$` (specified in csolution.yml with `output-dirs:`).

## ToDo's

- How to prevent that tasks.json commands start a GDB server twice?  Executing another Load&Run while the terminal is still running would fail.
    - Robi: this is solved at VS Code level. No need to worry.  
- How are the commands mapped to JLink?  We need here examples.
    - Robi+Omar will work it out.  New %symbols required: device, connection-type.
- How to create launch.json when using CMSIS Run command (with attach instead of launch) - should we just duplicate the sections launch and attach for the time being?
    - yes; for now we need both
- Can we simplify the `updateConfigruation: auto` to just the first core?
    - no, only sections with auto will be removed and replaced. 
- Do we always update tasks.json with commands that start with `CMSIS`?
    - yes  
- The active solution and active target-set is stored in workspaceStorage. Is this OK?
    - yes  
- Discuss if we move debugger: configuration in csolution to target-set: section.
    - yes
- The file `debug-adapters.yml` could also list the options that are possible for a debugger.
    - open, we will work on that later 
- Should we remove `debuggers:` under csolution and only allow it under target-set.
    - yes
- Should we find a way to add West configurations under images?
    - Task for Matthais+Christoper together with John Thomson
- Should target-set image be a complete filename or just a base name?
    - full filename; potentially make it smarter later
- Where is the location of the dbgconf files?
    - introduce a .cmsis folder, same base directory as csolution.yml. All dbgconf files are in this folder. 

Cortex-A/M systems
- Currently the Linux GDB server must be manually entered.  I believe this is OK, but let's discuss.
    - yes OK, no action.
- How to deal with load on Cortex-A/M systems (Cortex-M image downloaded using SSH)
    - Hans will try it out.

AC6 work-around
- Finalize workaround for GDB AXF file load with gdb (see below)
    - JLink needs a workaround. Suggest to handle this with documentation for the first implementation (workaround is to use HEX file).

pyOCD can use two separate calls for Load and Run. This does not require a LOAD command from GDB init commands and solves the issue with AC6 axf and gdb! The proposal is to use the "CMSIS Load" task as "preLaunchTask" (see below the launch.json example) - this simplifies also pyOCD implementation.

## Tasks

- Jonatan: 
    - implement [tasks.json + launch.json](#launchjson-and-tasksjson-update-process) update process.
    - implement [CMSIS View action buttons](#cmsis-view-action-buttons).
    - implement [Multi-Workspace](#multi-workspace) solution.

Dialog changes will be implemented later (after release of CMSIS-Toolbox 2.9)
