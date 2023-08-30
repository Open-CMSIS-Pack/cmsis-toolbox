# -------------------------------------------------------
# Copyright (c) 2023 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

from os import path
import platform

def test_check_archive(base_path):
    """
    Test to check the archive content
    """
    dirDict = dict()
    dirDict["bin"] = {'cbuild', 'cbuildgen', 'cpackget', 'csolution', 'packchk', 'svdconv'}
    dirDict["doc"] = {'index.html'}
    dirDict["etc"] = {
        "{{ProjectName}}.cproject.yml",
        "{{SolutionName}}.csolution.yml",
        "AC6.6.18.0.cmake",
        "ac6_linker_script.sct",
        "cbuild.schema.json",
        "cdefault.schema.json",
        "cdefault.yml",
        "CLANG.16.0.0.cmake",
        "clang_linker_script.ld",
        "clayer.schema.json",
        "CMakeASM",
        "CMSIS-Build-Utils.cmake",
        "common.schema.json",
        "CPRJ.xsd",
        "cproject.schema.json",
        "csolution.schema.json",
        "GCC.10.3.1.cmake",
        "gcc_linker_script.ld",
        "IAR.9.32.1.cmake",
        "iar_linker_script.icf",
        "PACK.xsd"}

    assert(True == path.isfile(path.join(base_path,"LICENSE.txt")))
    for dir in dirDict:
        for file in dirDict[dir]:
            if dir == "bin" and platform.system() == "Windows":
                file += ".exe"
            assert(True == path.exists(path.join(base_path, dir, file)))
