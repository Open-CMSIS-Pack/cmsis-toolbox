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
        "AC6.6.18.0.cmake", "ac6_linker_script.sct", "gcc_linker_script.ld",
        "iar_linker_script.icf", "CPRJ.xsd", "PACK.xsd", "GCC.10.3.1.cmake",
        "CLANG.16.0.0.cmake", "IAR.9.32.1.cmake",
        "{{ProjectName}}.cproject.yml", "{{SolutionName}}.csolution.yml",
        "clayer.schema.json", "common.schema.json", "cproject.schema.json",
        "cproject.schema.json", "CMakeASM",
        "cbuild.schema.json", "cdefault.schema.json", "cdefault.yml",
        "clang_linker_script.ld", "CMSIS-Build-Utils.cmake", "csolution.schema.json"}

    assert(True == path.isfile(path.join(base_path,"LICENSE.txt")))
    for dir in dirDict:
        for file in dirDict[dir]:
            if dir == "bin" and platform.system() == "Windows":
                file += ".exe"
            assert(True == path.exists(path.join(base_path, dir, file)))
