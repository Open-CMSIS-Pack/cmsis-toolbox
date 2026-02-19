# -------------------------------------------------------
# Copyright (c) 2023-2026 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

from os import path
import platform
import glob

def test_check_archive(base_path):
    """
    Test to check the archive content
    """
    dirDict = dict()
    dirDict["bin"] = {
        'cbridge', 'cbuild', 'cbuild2cmake', 'cbuildgen',
        'cpackget', 'csolution', 'launch-MCUXpressoConfigTools',
        'packchk', 'svdconv',  'vidx2pidx', 'launch-Infineon_Dev_Config'}
    dirDict["doc"] = {'index.html'}
    dirDict["etc"] = {
        "AC6.6.16.2.cmake",
        "ac6_linker_script.sct.src",
        "cbuild.schema.json",
        "cbuild-gen.schema.json",
        "cbuild-gen-idx.schema.json",
        "cbuild-pack.schema.json",
        "cbuild-set.schema.json",
        "cdefault.schema.json",
        "cdefault.yml",
        "cgen.schema.json",
        "CLANG.17.0.1.cmake",
        "CLANG_TI.4.0.1.cmake",
        "clang_linker_script.ld.src",
        "clayer.schema.json",
        "CMakeASM",
        "CMSIS-Build-Utils.cmake",
        "common.schema.json",
        "CPRJ.xsd",
        "cproject.schema.json",
        "csolution.schema.json",
        "debug-adapters.schema.json",
        "debug-adapters.yml",
        "GCC.10.3.1.cmake",
        "gcc_linker_script.ld.src",
        "generator.schema.json",
        "global.generator.yml",
        "IAR.9.32.1.cmake",
        "iar_linker_script.icf.src",
        "PACK.xsd",
        "PackIndex.xsd",
        "XC.5.0.0.cmake"}

    assert(True == path.isfile(path.join(base_path,"LICENSE.txt")))
    for dir in dirDict:
        for file in dirDict[dir]:
            assert(glob.glob(path.join(base_path, dir, file + "*")))
