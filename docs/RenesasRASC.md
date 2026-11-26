# Renesas RA Smart Configurator

<!-- markdownlint-disable MD013 -->

This chapter explains how to start the [Renesas RA Smart Configurator](https://github.com/renesas/fsp/releases) (RASC) from a *csolution project*.

## Requirements

- Windows on an amd64 or arm64 host. RASC is not supported on Linux or macOS.
- A Renesas RA Smart Configurator installation.
- A software pack component that refers to the global generator ID `RenesasRASC`.

Set the environment variable `RASC_EXE_PATH` to the complete path of `rasc.exe`, for example:

```powershell
$env:RASC_EXE_PATH = 'C:\Renesas\RA\sc_<version>\eclipse\rasc.exe'
```

When the variable is configured in the Windows environment settings, restart the terminal or VS Code so that the new process inherits it.

## Run the Configurator

The CMSIS-Toolbox registers RASC as the global generator `RenesasRASC`. When a selected component uses this generator, list it for the project context with:

```shell
csolution MyApp.csolution.yml list generators --context MyProject.Debug+MyTarget --verbose
```

Start RASC with:

```shell
csolution MyApp.csolution.yml run --generator RenesasRASC --context MyProject.Debug+MyTarget
```

The CMSIS-Toolbox launcher reads the project directory from the generated [`*.cbuild-gen-idx.yml` and `*.cbuild-gen.yml` files](YML-CBuild-Format.md#generator-information-files), changes to the directory that contains `*.cproject.yml`, and opens:

```txt
<project-directory>/configuration.xml
```

RASC creates `configuration.xml` when it does not exist. Configure the device and peripherals, select **Generate Project Content**, and close RASC when generation is complete. The `csolution run` command waits until RASC is closed.

Run `cbuild setup` or build the application after regenerating the project content.
