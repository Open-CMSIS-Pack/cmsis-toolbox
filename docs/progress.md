## Implementation Progress

Feature                                                                                  | Status                   | Version
:----------------------------------------------------------------------------------------|:-------------------------|:----------------
`csolution.yml`, `cproject.yml` and `clayer.yml` handling                                | :heavy_check_mark:       | csolution 0.9.0
`cdefault.yml` handling                                                                  | :heavy_check_mark:       | csolution 0.9.3
`build-types` and `target-types` at csolution level                                      | :heavy_check_mark:       | csolution 0.9.0 
`for-type`/`not-for-type` context handling                                               | :heavy_check_mark:       | csolution 0.9.0
list `packs`, `devices`, `components`, `dependencies` at cproject level                  | :heavy_check_mark:       | csolution 0.9.0
`defines`/`undefines`/`add-paths`/`del-paths` at solution/project/target level           | :heavy_check_mark:       | csolution 0.9.0
`defines`/`undefines`/`add-paths`/`del-paths` at component/group/file level in csolution | :heavy_check_mark:       | csolution 0.9.3
`defines`/`undefines`/`includes`/`excludes` at component/group/file level in cbuild      | :heavy_check_mark:       | cbuild 0.10.6
compiler `misc` options                                                                  | :heavy_check_mark:       | csolution 0.9.0
`device` discovering from `board` setting                                                | :heavy_check_mark:       | csolution 0.9.1
`optimize`, `debug`, `warnings` in csolution                                             | :heavy_check_mark:       | csolution 1.2.0
`optimize`, `debug`, `warnings` in cbuild                                                | :heavy_check_mark:       | cbuild 1.3.0
access sequences handling in csolution                                                   | :heavy_check_mark:       | csolution 0.9.1
access sequences handling in cbuild                                                      | :heavy_check_mark:       | cbuild 0.11.0
list commands at csolution and context level                                             | :heavy_check_mark:       | csolution 0.9.1
csolution `context` input parameter                                                      | :heavy_check_mark:       | csolution 0.9.1
generator commands: `list generators` and `run --generator <id>`                         | :heavy_check_mark:       | csolution 0.9.1
generator component extensions                                                           | :heavy_multiplication_x: | in progress
automatic schema checking                                                                | :heavy_check_mark:       | csolution 0.9.1
config files PLM                                                                         | :heavy_check_mark:       | csolution 0.9.2
pack selection: `pack` keyword in csolution                                              | :heavy_check_mark:       | csolution 0.9.2
pack selection: context filtering                                                        | :heavy_check_mark:       | csolution 0.9.3
pack selection: `path` keyword in csolution                                              | :heavy_check_mark:       | csolution 0.9.2
pack selection: `path` attribute in cbuild                                               | :heavy_check_mark:       | cbuild 0.10.6
`device` variant handling                                                                | :heavy_check_mark:       | csolution 0.9.2
schema for flexible vendor specific additions                                            | :heavy_check_mark:       | csolution 0.9.2
user provided linker script selection                                                    | :heavy_check_mark:       | csolution 0.9.2
support for IAR compiler                                                                 | :heavy_check_mark:       | cbuild 0.10.5
minimum/range component version handling                                                 | :heavy_check_mark:       | csolution 1.1.0
replacement of cbuild bash scripts                                                       | :heavy_check_mark:       | cbuild 0.11.0
multi-project solution handling in cbuild                                                | :heavy_check_mark:       | cbuild 1.5.0
layered solutions in-source conversion                                                   | :heavy_check_mark:       | csolution 0.9.4
support for output directories customization at csolution level                          | :heavy_check_mark:       | csolution 1.0.0
support for board attributes in conditions                                               | :heavy_check_mark:       | csolution 1.0.0
`for-compiler` and `setup` handling                                                      | :heavy_check_mark:       | csolution 1.0.0
multiple contexts selection via wildcards                                                | :heavy_check_mark:       | csolution 1.0.0
layer `interfaces` definitions                                                           | :heavy_check_mark:       | csolution 1.1.0
separation of config files belonging to layers                                           | :heavy_check_mark:       | csolution 1.2.0
generation of cbuild-idx.yml and cbuild.yml files                                        | :heavy_check_mark:       | csolution 1.2.0
support for linux-arm64 host platform                                                    | :heavy_check_mark:       | csolution 1.3.0
support for win-arm64 and mac-arm64 host platforms                                       | :heavy_check_mark:       | csolution 1.7.0
distribution of layers                                                                   | :heavy_multiplication_x: | in progress
disable update of RTE folder by default in cbuild                                        | :heavy_check_mark:       | cbuild 1.4.0
`--update-rte` flag to enable the update of RTE folder contents in cbuild                | :heavy_check_mark:       | cbuild 1.4.0
`--no-update-rte` flag to skip the update of RTE folder contents in csolution            | :heavy_check_mark:       | csolution 1.4.0
`connections` handling replacing `interfaces`                                            | :heavy_check_mark:       | csolution 1.4.0
`variables` handling for setting layer paths                                             | :heavy_check_mark:       | csolution 1.4.0
`list layers` command for finding layers with compatible connections                     | :heavy_check_mark:       | csolution 1.4.0
`list toolchains` command for finding configured toolchains                              | :heavy_check_mark:       | csolution 1.4.0
support csolution.yml and context as input data in cbuild                                | :heavy_check_mark:       | cbuild 1.5.0
add `output` filenames customization handling in cbuild                                  | :heavy_check_mark:       | cbuild 1.5.0
add `output` filenames customization handling in csolution                               | :heavy_check_mark:       | csolution 1.5.0
rework toolchains registration in cbuild                                                 | :heavy_check_mark:       | cbuild 1.5.0
rework toolchains registration in csolution                                              | :heavy_check_mark:       | csolution 1.5.0
`--toolchains` command line option for selecting the compiler                            | :heavy_check_mark:       | csolution 1.5.0
linker script file pre-processing in csolution                                           | :heavy_check_mark:       | csolution 1.7.0
linker script file pre-processing in cbuild                                              | :heavy_check_mark:       | cbuild 1.7.0
generate regions_*.h file from memory tags                                               | :heavy_check_mark:       | csolution 1.7.0
`context-map` handling                                                                   | :heavy_check_mark:       | csolution 2.0.0-dev0
reworked `output` nodes                                                                  | :heavy_check_mark:       | csolution 2.0.0-dev0
reworked output file types                                                               | :heavy_check_mark:       | cbuild 2.0.0-dev0
updated access sequences                                                                 | :heavy_check_mark:       | csolution 2.0.0-dev0
removed deprecated nodes                                                                 | :heavy_check_mark:       | csolution 2.0.0-dev0
`update-rte` command for creating/updating and listing config files                      | :heavy_check_mark:       | csolution 2.0.0-dev1
`rte` `base-dir` at cproject level for RTE folder customization                          | :heavy_check_mark:       | csolution 2.0.0-dev1
reworked `cdefault` handling                                                             | :heavy_check_mark:       | csolution 2.0.0-dev1
support multiple `--context` inputs                                                      | :heavy_check_mark:       | csolution 2.0.0-dev2
support multiple `setup` for each context                                                | :heavy_check_mark:       | csolution 2.0.0-dev2
support for standard language options in cbuild                                          | :heavy_check_mark:       | cbuild 2.0.0-dev3
support for standard language options in csolution                                       | :heavy_check_mark:       | csolution 2.0.0-dev3
support for `language` and `scope` component file attributes in csolution                | :heavy_check_mark:       | csolution 2.0.0-dev3
alpha support for LLVM/Clang in cbuild                                                   | :heavy_check_mark:       | cbuild 2.0.0
alpha support for LLVM/Clang in csolution                                                | :heavy_check_mark:       | csolution 2.0.0
resources management                                                                     | :x:                      |
execution groups/phases                                                                  | :x:                      |
pre/post build steps in csolution                                                        | :x:                      |
pre/post build steps in cbuild                                                           | :x:                      |
