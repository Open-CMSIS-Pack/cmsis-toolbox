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
`optimize`, `debug`, `warnings` in csolution                                             | :x:                      |
`optimize`, `debug`, `warnings` in cbuild                                                | :x:                      |
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
minimum/range component version handling                                                 | :x:                      |
replacement of cbuild bash scripts                                                       | :heavy_check_mark:       | cbuild 0.11.0
multi-project solution handling in cbuild                                                | :x:                      |
layered solutions in-source conversion                                                   | :heavy_check_mark:       | csolution 0.9.4
support for output directories customization at csolution level                          | :heavy_check_mark:       | csolution 1.0.0
support for board attributes in conditions                                               | :heavy_check_mark:       | csolution 1.0.0
`for-compiler` and `setup` handling                                                      | :heavy_check_mark:       | csolution 1.0.0
multiple contexts selection via wildcards                                                | :heavy_check_mark:       | csolution 1.0.0
layer `interface` definitions                                                            | :x:                      |
distribution of layers                                                                   | :x:                      |
resources management                                                                     | :x:                      |
linker scatter file handling                                                             | :x:                      |
execution groups/phases                                                                  | :x:                      |
pre/post build steps in csolution                                                        | :x:                      |
pre/post build steps in cbuild                                                           | :x:                      |
