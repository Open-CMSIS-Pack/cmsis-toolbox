### Migrating examples created for `cmsis-toolbox` `1.x.y` to `2.0.0`

This document clarifies breaking changes introduced in the CMSIS-Toolbox 2.0.0 and describes most common issues faced when migrating examples created for older versions.
Please [extend this document](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/edit/main/docs/migration.md) if you encounter further issues.


For highlighting changes in yml nodes it's recommended to update the YAML Language Support extension settings to use the tagged schemas [`schemas/projmgr/2.0.0`](
https://github.com/Open-CMSIS-Pack/devtools/releases/tag/schemas/projmgr/2.0.0).

For example the following `# yaml-language-server` comment can be used:
- in *.csolution.yml:
```
# yaml-language-server: $schema=https://github.com/Open-CMSIS-Pack/devtools/blob/schemas/projmgr/2.0.0/tools/projmgr/schemas/csolution.schema.json
```
- in *.cproject.yml:
```
# yaml-language-server: $schema=https://github.com/Open-CMSIS-Pack/devtools/blob/schemas/projmgr/2.0.0/tools/projmgr/schemas/cproject.schema.json
```
- in *.clayer.yml:
```
# yaml-language-server: $schema=https://github.com/Open-CMSIS-Pack/devtools/blob/schemas/projmgr/2.0.0/tools/projmgr/schemas/clayer.schema.json
```

**The following deprecated yml nodes and related handling were removed:**

all occurrences:
- `add-paths` (replaced by [`add-path`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#add-path))
- `del-paths` (replaced by [`del-path`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#del-path))
- `defines` (replaced by [`define`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#define))
- `undefines` (replaced by [`undefine`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#undefine))
- `for-type` (replaced by [`for-context`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#for-context))
- `not-for-type` (replaced by [`not-for-context`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#not-for-context))
- `output-type` (replaced by [`output`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#output) node)

in [`misc`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#misc):
- `compiler` (replaced by [`for-compiler`)
- `C*` (replaced by `C-CPP`)

in `output-dirs`:
- `gendir` (replaced by [`generators`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#generators) node)
- `rtedir` (replaced by [`rte`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#rte) node in *.cproject.yml)
>Note: RTE files belonging to components specified in *.clayer.yml files remain next to such *.clayer.yml.
 
in [`processor`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#processor):
- `fpu` and `endian` (but accepted with disabled schema check)

in [`cdefault:`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#default):
- `packs`
- `build-types`
- `output-dirs`

**The cdefault enablement has changed:**

The [`cdefault:`](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#default) empty node must be added to *.csolution.yml to activate its use.
>Note: the file must be named `cdefault.yml` or `cdefault.yaml` without leading dot.

**The following [Access Sequences](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/docs/YML-Input-Format.md#access-sequences) were removed:**

- `$Source(context)` (replaced by `$ProjectDir(context)$`)
- `$Out(context)` (replaced by `$elf(context)$`, `$bin(context)$`, `$hex(context)$`, `$lib(context)$` and `$cmse-lib(context)$`)

**The following environment variable must be unset or removed:**
- `CMSIS_BUILD_ROOT`
> Note: This is needed because `cbuild` calls binaries pointed by `CMSIS_BUILD_ROOT` which are potentially outdated.
