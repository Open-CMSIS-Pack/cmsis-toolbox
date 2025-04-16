# CMSIS Debugger Integration

<!-- markdownlint-disable MD009 -->
<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD036 -->
<!-- markdownlint-disable MD032 -->

This document summarizes how to integrate the CMSIS-Debugger and pyOCD into the workflows.

ToDo: extend cbuild-set.yml, review debugger: 

## Context-Set

The Context Set dialog is extended as shown below.

![Context-Set](./images/CMSIS-Debugger-Context.png "Context Set")

### Changes

- **Apply** makes the dialog stateful (similar to new Components/Packs dialog).

### Active Projects and Images

- **Processor:** is added for projects that contain a `pname` selection.
    - `cbuild-idx.yml` and `cbuild.yml` should be extended with `pname:` information.
  
- **Run and Debug** allows to select how the project is used (setting is in `cbuild-set.yml` file)
    - `Load & Debug` (default) image is loaded and debugger loads symbol (DWARF) information.
    - `Load` image is loaded, but no symbol information is loaded.
    - `Debug` only symbol (DWARF) information is loaded.
    - Offset can be specified in the `cproject.yml` file or for images in the `csolution.yml` file.
    - **Additional Images** shows additional image files that are specified in `csolution.yml` using [`load:`](YML-Input-Format.md#load).

### Manage Target Connection Configuration

- **Target Type** lists all target types of the csolution.
- **Debug Adapter** is a selection from `adapters.yml` (see below).  If cbuild-xxx.yml contains a debugger name, this debugger is the pre-selected (default).
- **Start Processor** is only added for projects that contain a `pname` selection. It allows to choose a `pname:`. Default is `pname' of the first project.

Add in `arm.cmsis-csolution-xxx` directory a sub-directory with the name `.\adapters`.  This directory contain a file `adapters.yml` along with template files for updating `launch.json` and `tasks.json`.  It defines the configuration for the CMSIS-View `Run` and `Debug` button and specifies the templates that are used to inject content in the related files.

- The file `./.vscode/launch.json` is updated for VS Code Debugger (replaced are sections with same type).
- The file `./.vscode/tasks.json` is updated external debuggers / tools.

**Potential `adapters.yml` content**

```yml
adapters:
  name: "pyOCD: CMSIS-DAP"
  short: pyOCD                           # short name
  run: pyOCD-CMSIS-DAP.launch.json       # template for run
  debug: pyOCD-CMSIS-DAP.launch.json     # template for debug

  name: "JLink Server"
  short: JLink                           # short name
  run: jlink.launch.json                 # template for run
  debug: jlink.launch.json               # template for debug

  name: "AVH-FVP"
  short: "FVP"
  run: FVP.tasks.json                    # template for run
  debug:                                 # debug not possible (button is disabled)

  name: "Keil uVision"
  short: uVision
  run: uVision.tasks.json                # template for run
  debug: uVision.tasks.json              # template for debug
```

Initially, only the features required for "pyOCD: CMSIS-DAP" could be implemented.

**Template file proposal for "pyOCD: CMSIS-DAP".**

`%<symbol>` strings are replaced with values when updating `launch.json` or `tasks.json`.

- `%port` is the port number (port-default is inital value). Incremented after each insert.
- `%image-debug` the elf file of the project. Resolves to `<empty>` when "Debug" is inactive in Context Set.
- `%image-load` the file that should be loaded (for AC6 the HEX file, other compilers ELF file). Resolves to `<empty>` when "Load" is inactive in Context Set.
- `%adapter-short` the short name of the adapter.
- `%target-pname` the pname of the processor

If more than one *.cproject.yml* is assigned, `%image-debug` and `%image-load` results in a comma-separated file list. For multi-core systems the file list is also `pname:` specific.

- The section `singlecore:` is used for systems that do not use `pname:` specifiers.
- The section `multicore-xxx:` is used for systems that use `pname:` specifiers.


```json
    "port-default:"  3333     // start value for port (if not specified otherwise)

    "singlecore":             // for single core systems
        {
            "name": "GDB %adapter-short"
            "type": "gdbtarget",
            "request": "launch",
            "cwd": "${workspaceFolder}",
            "program": %image-debug
            "gdb": "arm-none-eabi-gdb",
            "initCommands": [
                "load %image-load"
                "tbreak main"
            ],
            "target": {
                "server": "pyocd",
                "port": %port
            },
            "cmsis": {
                "cbuildRunFile": %{cmsis-csolution.getCbuildRunFile}
            }
        }

    "multicore-start":        // for start processor in multi-core systems
        {
            "name": "%target-pname %adapter-short"
            "type": "gdbtarget",
            "request": "launch",
            "cwd": "${workspaceFolder}",
            "program": %image-debug
            "gdb": "arm-none-eabi-gdb",
            "initCommands": [
                "load %image-laod"
                "tbreak main"
            ],
            "target": {
                "server": "pyocd",
                "port": %port
            },
            "cmsis": {
                "cbuildRunFile": %{cmsis-csolution.getCbuildRunFile}
                "pname:" %target-pname
            }
        }

    "multicore-other:"    // for other processors in multi-core systems
            "name": "%target-pname %adapter-short"
            "type": "gdbtarget",
            "request": "attach",
            "cwd": "${workspaceFolder}",
            "program": %image-debug
            "gdb": "arm-none-eabi-gdb",
            "initCommands": [
                "load %image-load"
            ],
            "target": {
                "server": "pyocd",
                "port": %port
            },
            "cmsis": {
                "pname:" %target-pname
            }
        }
```

## New csolution Features

Command                               | Description
:-------------------------------------|:-----------------------------------------------------
`cmsis-csolution.launchRequest        | Resolves one-time to string "launch" when Debug button is used, otherwise "attach".
`cmsis-csolution.tbreakMain`          | Resolves one-time to string "tbreak main" when Debug button is used, otherwise \<empty\>.
`cmsis-csolution.workspace`           | Resolves to workspace path of active *csolution project*. Solves [problem #156](https://github.com/Open-CMSIS-Pack/vscode-cmsis-debugger/issues/156)

### Test Environment for Multi-Workspace

- Open [NXP_FRDM-MCXN947 DualCore](https://github.com/Open-CMSIS-Pack/NXP_FRDM-MCXN947_BSP/tree/cmsis-debugger/boards/frdmmcxn947/cmsis/examples/DualCore) - branch "cmsis-debugger"
- Use *File - Add Folder to Workspace() and add https://github.com/Open-CMSIS-Pack/csolution-examples

Using "Select Active Solution from Workspace" allows to select the active solution, but unfortunately does not select the right `/.vscode` folder for `launch.json` and `tasks.json`
