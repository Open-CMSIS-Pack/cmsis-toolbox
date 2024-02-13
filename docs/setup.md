# Proposal for command `cbuild setup`

To [streamline IDE integrations](https://github.com/Open-CMSIS-Pack/devtools/issues/1265) it is proposed to extend the `cbuild` tool with a `setup` command.

```bash
cbuild setup <name>.csolution.yml --update-rte -S
```

This command is invoked at start of an IDE or whenever one csolution project file is modified. Proposed operation is:

- Check for correctness of the csolution project files in the selected context set.
- Create for the selected context set build information files.
- Create for the selected context set the `compile_commands.json` in the `out` of the related context.
- When option `S` is used and the file `*.cbuild-set` is missing, the setup command creates a `*.cbuild-set` file with selection of the first `target-type` and the first `build-type`.

## Flow of the cbuild setup command is:

```bash
csolution convert <name>.csolution.yml --update-rte -S
cbuild_gen              // for selected context set
CMAKE --target database // for selected context set
```

## Extend `cbuild-idx.yml` Files:

As the build information file is generated also in case of errors, the file `cbuild-idx.yml` should be extended with:

### `errors:` and `packs-missing:` node

In case that this nodes exist, the `setup` process does not generate any `cbuild+<target-type>.<build-type>.yml` files.

`errors:` just indicates that there are some errors
`packs-missing:` is a list of missing packs

Example:

```yml
  errors:                       # indicates that there is an error during convert
  packs-missing:                # lists missing packs 
    - pack: ARM::CMSIS-RTX      # with unspecified version
    - pack: ARM::CMSIS@6.0.0    # with specified version
```

## Extend `cbuild+<target-type>.<build-type>.yml` Files:

### Generator Invocation

To support invocation of a `generator` in an IDE, the `component:` should be extended with `generator` as shown below:

```yml
- component: Keil::Device:CubeMX@0.9.0
  generator:
    - id: CubeMX
      path: <file>.cgen.yml
```

### Instance Number

For components that have instances, the component name is extended with a instance number using `=<instance-no>`.  Example:

```yml
    - component: Keil::USB&MDK-Plus:Device=0@6.17.0
```

### Template File Access

The user template files in the PDSC should be accessible by the IDE in an outline view. Therefore it should be added to the component.

```xml
          <file category="source" name="USB/Template/USBD_User_Device.c"        attr="template" select="USB Device"/>
          <file category="source" name="USB/Template/USBD_User_Device_SerNum.c" attr="template" select="USB Device Serial Number"/>
```

```yml
    - component: Keil::USB&MDK-Plus:Device=0@6.17.0
      files:
        - file: ${CMSIS_PACK_ROOT}/Keil/MDK-Middleware/7.17.0/USB/Template/USBD_User_Device.c
          category: source
          attr: template
          select: USB Device
      files:
        - file: ${CMSIS_PACK_ROOT}/Keil/MDK-Middleware/7.17.0/USB/Template/USBD_User_Device_SerNum.c
          category: source
          attr: template
          select: USB Device Serial Number
```

>**Note:** There are templates that require multiple files. In this case the `select:` text is identical.

### Extend Header with Select

Some software distributions contain a list of header files that are relevant for the user source code. Similar to template these header files should be accessible to the user.

```yml
 <components>
    <bundle Cbundle="lwIP" Cclass="Network" Cversion="2.2.0">
      <description>lwIP (Lightweight IP stack)</description>
      <doc>lwip/doc/doxygen/output/index.html</doc>
      <component Cgroup="CORE" Cvariant="IPv4" isDefaultVariant="true">
        <description>Network Core (IPv4)</description>
        <RTE_Components_h>
          <!-- the following content goes into file 'RTE_Components.h' -->
          #define RTE_Network_Core                /* Network Core */
          #define RTE_Network_IPv4                /* Network IPv4 Stack */
        </RTE_Components_h>
        <files>
          <file category="header"  name="rte/config/lwipopts.h" attr="config" version="2.2.0"/>
          <file category="include" name="rte/include/"/>
          <file category="include" name="lwip/src/include/"/>
          <file category="source"  name="lwip/src/core/init.c"/>
          <file category="header"  path="lwip/src/include/" name="lwip/udp.h" select=UDP Socket Interface"/>
          <file category="header"  path="lwip/src/include/" name="lwip/socket.h" select=BSD Socket Interface"/>
```

```yml
    - component: lwIP::Network&lwIP:CORE@2.2.0
      files:
        - file: ${CMSIS_PACK_ROOT}/lwip/src/include/lwip/udp.h
          category: header
          select: UDP Socket Interface
        - file: ${CMSIS_PACK_ROOT}/lwip/src/include/lwip/socket.h
          category: header
          select: BSD Socket Interface
```

### API Header Access

For components that are based on an API, the API header should be part of the component file list. This allows IDEs to access the related header file.

```yml
    - component: Keil::CMSIS Driver:MCI@2.11
      condition: STM32F4 CMSIS_Driver MCI
      from-pack: Keil::STM32F4xx_DFP@2.17.0
      selected-by: Keil::CMSIS Driver:MCI
      files:
        - file: ${CMSIS_PACK_ROOT}/Keil/STM32F4xx_DFP/2.17.0/CMSIS/Driver/MCI_STM32F4xx.c
          category: source
        - file: ${CMSIS_PACK_ROOT}/Keil/STM32F4xx_DFP/2.17.0/CMSIS/Driver/MCI_STM32F4xx.c
          category: source
        - file: ${CMSIS_PACK_ROOT}/Arm/Packs/ARM/CMSIS/6.0.0/CMSIS/Driver/Include/Driver_MCI.h
          category: api
```

### Config File Update

For configuration files that are outdated it should contain `base:` file and `update:` file.

```yml
  - file: RTE/CMSIS/RTX_Config.h
    category: header
    attr: config
    version: 1.2.0 
    base: ./RTE/component_class/ConfigFile.h.base@1.2.0       // current unmodified configuration file with version 
    update: ./RTE/component_class/ConfigFile.h.update@1.3.0     // new configuration file; used for merge utility
```
