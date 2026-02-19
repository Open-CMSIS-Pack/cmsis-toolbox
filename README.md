# CMSIS-Toolbox

[![License](https://img.shields.io/github/license/Open-CMSIS-Pack/cbuild2cmake?label)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/blob/main/LICENSE)
[![Dependency review](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/dependency-review.yml?logo=arm&logoColor=0091bd&label=Dependency%20review)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/dependency-review.yml)
[![Markdown lint check](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/markdown.yml?logo=arm&logoColor=0091bd&label=Markdown%20lint%20check)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/markdown.yml)
[![Build documentation](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/mkdocs.yml?logo=arm&logoColor=0091bd&label=Build%20documentation)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/mkdocs.yml)
[![Build cmsis-toolbox](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/nightly.yml?logo=arm&logoColor=0091bd&label=Build%20cmsis-toolbox)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/nightly.yml)
[![End to end tests](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/e2e.yml?logo=arm&logoColor=0091bd&label=End%20to%20end%20tests)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/e2e.yml)
[![Publish cmsis-toolbox](https://img.shields.io/github/actions/workflow/status/Open-CMSIS-Pack/cmsis-toolbox/toolbox.yml?logo=arm&logoColor=0091bd&label=Publish%20cmsis-toolbox)](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/tree/main/.github/workflows/toolbox.yml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/Open-CMSIS-Pack/cmsis-toolbox/badge)](https://securityscorecards.dev/viewer/?uri=github.com/Open-CMSIS-Pack/cmsis-toolbox)

This contains the executable tools of the CMSIS-Toolbox that provides a set of command-line tools to work with software packs in Open-CMSIS-Pack format.

## Users Guide

The [**Users Guide**](https://open-cmsis-pack.github.io/cmsis-toolbox) provides detailed information.

## Project Creation

The following tools support the creation of build information for embedded applications:

Tool           | Description
:--------------|:-------------
**cpackget**   | **Pack Manager:** install and manage software packs in the development environment.
**cbuild**     | **Build Invocation:** orchestrate the build steps utilizing CMSIS tools and a CMake compilation process.
**csolution**  | **Project Manager:** create build information for embedded applications that consist of one or more related projects.

## Example Projects

Repository            | Description
:---------------------|:-------------------------------------
[csolution-examples](https://github.com/Open-CMSIS-Pack/csolution-examples) | Contains several `Hello World` examples that show single-core, multi-core, and TrustZone setup.
[vscode-get-started](https://github.com/Open-CMSIS-Pack/vscode-get-started) | Contains the setup for a VS Code development environment including an example project.
[github.com/Arm-Examples](https://github.com/Arm-Examples) | Contains many examples that include CMSIS-Toolbox setup.

## Software Pack Creation

The following tools support the creation of Software Packs in [CMSIS-Pack format](https://open-cmsis-pack.github.io/Open-CMSIS-Pack-Spec/main/html/index.html):

Tool           | Description
:--------------|:-------------
**packchk**    | **Pack Validation:** installs and manages software packs in the local development environment.
**svdconv**    | **SVD Check / Convert:** validate and/or convert System View Description (SVD) files.

In addition several scripts are provided that simplify pack creation with desktop or cloud workflows. This is described in several hands-on tutorials:

Hands-on Tutorial         | Description
:-------------------------|:-------------
[**SW-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/SW-Pack-HandsOn)    | Explains the steps to create a simple software pack using the Open-CMSIS-Pack technology.
[**DFP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/DFP-Pack-HandsOn)  | Explains the structure and creation of a Device Family Pack (DFP).
[**BSP-Pack-HandsOn**](https://github.com/Open-CMSIS-Pack/DFP-Pack-HandsOn)  | Explains the structure and creation of a Board Support Pack (BSP).

## Documentation

The documentation can be built using [mkdocs](https://www.mkdocs.org/). It requires Python 3 to be installed on your local machine.
Check out [Getting Started with MkDocs](https://www.mkdocs.org/getting-started/) to learn how to use it. A CI workflow is
in place that builds the documentation automatically.

## Report a Bug

Please report any issue you are facing while using CMSIS-Toolbox in the [Issues tab on GitHub](https://github.com/Open-CMSIS-Pack/cmsis-toolbox/issues/new/choose).
Select the appropriate issue template, depending on the severity of the issue. Bugs (or deviations) from the defined behaviour that can be worked around shall be reported as "non-blocking bug". In turn, issues that prevent you from using a certain feature entirely, are considered a "blocking bug" and labelled as *critical*.
