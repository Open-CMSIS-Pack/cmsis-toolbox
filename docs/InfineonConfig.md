# Infineon Configuration Tools

<!-- markdownlint-disable MD013 -->

This chapter explains how to start Infineon Configuration Tools from a *csolution project*.

CMSIS-Toolbox provides global generators for these tools:

| Generator ID | Tool | Use |
|--------------|------|-----|
| `InfineonDeviceConfigurator` | Device Configurator | Infineon devices supported by a selected Configurator library provider |
| `InfineonDevConf_MotixLitix` | Device Configurator | MOTIX and LITIX devices |
| `InfineonMcuConfigWizard` | MCU Config Wizard | MOTIX and LITIX devices |

## Requirements

- Windows on an amd64 host. The Infineon generators are not supported on Windows arm64, Linux, or macOS.
- Install the required tool from the [Infineon Developer Center](https://softwaretools.infineon.com/).
- Select a software pack component that refers to one of the global generator IDs listed above.

Device Configurator is normally located using its Infineon Toolbox registration. To use a different executable, set `CONFIGURATOR_EXE` to its complete path before running `csolution`.

## Run a Configurator

List the generators available for a project context with:

```shell
csolution MyApp.csolution.yml list generators --context MyProject.Debug+MyTarget --verbose
```

Start the generator required by the selected component, for example:

```shell
csolution MyApp.csolution.yml run --generator InfineonDeviceConfigurator --context MyProject.Debug+MyTarget
```

Only one context may be selected when running an Infineon generator. After changing the configuration and generating source files, run `cbuild setup` or build the application to update the project.

## Device Configurator

The `InfineonDeviceConfigurator` launcher reads the selected device and Configurator library from the [`*.cbuild-gen-idx.yml` and `*.cbuild-gen.yml` files](YML-CBuild-Format.md#generator-information-files). It copies a suitable `design.modus` template to the generator directory when no context-specific design exists, and then opens that design in Device Configurator.

The selected software packs must provide exactly one Configurator library for the device. An existing context-specific `design.modus` is preserved and must match the selected device.

For MOTIX and LITIX devices, use `InfineonDevConf_MotixLitix` when this generator is specified by the selected component. It keeps `design.modus` in the solution's `config` directory and records the files from `GeneratedSource` in the generator import file.

## MCU Config Wizard

Start MCU Config Wizard with:

```shell
csolution MyApp.csolution.yml run --generator InfineonMcuConfigWizard --context MyProject.Debug+MyTarget
```

The launcher finds the latest registered MCU Config Wizard installation and passes the generator index file to the tool. This generator is intended for MOTIX and LITIX devices.
