# Proposal for command `cbuild setup`

To [streamline IDE integrations](https://github.com/Open-CMSIS-Pack/devtools/issues/1265) it is proposed to extend the `cbuild` tool with a `setup` command.

```bash
cbuild setup <name>.csolution.yml --VSC_clang --update-rte -S
```

This command is invoked at start of an IDE or whenever one csolution project file is modified. Proposed operation is:

- check all defined `contexts` for correctness of the csolution project files.
- create for the selected context set build information files.
- create for VS Code the CLANG setup for Intellisense (when option `--VSC_clang` is used).

## Extend Build Information Files

As the build information file is generated also in case of errors, the file `cbuild-idx.yml` may be extended with an `error:` node.

To support IDE specific features, the `cbuild.yml` information for `components:` should be extended with:

- `generator:` (to start a generator using the csolution run command)
- `apis:` to show available include files of a component.
- `doc:` to access the documentation of a component.

```yml
- component: Keil::Device:CubeMX@0.9.0
  generator:
    - id: CubeMX
      path: <file>.cgen.yml
  apis:
    - file: <file>.h
      brief: optional title
  doc: <file | URL>
```

For configuration files that are outdated it should contain `base:` file, `update:` file, and `status:`.

```yml
  - file: RTE/CMSIS/RTX_Config.h
    category: header
    attr: config
    version: 5.5.2 
    base: ./RTE/component_class/ConfigFile.h.base@1.2.0       // current unmodified configuration file with version 
    update: ./RTE/component_class/ConfigFile.h.update@1.3.0     // new configuration file; used for merge utility
    status: { minor | major | incompatible }
```