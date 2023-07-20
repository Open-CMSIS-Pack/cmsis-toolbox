from os import path
import platform
import unittest

class TestSum(unittest.TestCase):
    BASE_ARCHIVE_PATH = "../toolbox"
    def test_check_archives(self):
        """
        Test to check the archive context
        """
        binExtn = ""
        if platform.system() == "Windows":
            binExtn = ".exe"

        dirDict = dict()
        dirDict["bin"] = {'cbuilds', 'cbuildgen', 'cpackget', 'csolution', 'packchk', 'svdconv'}
        dirDict["doc"] = {'index.html'}
        dirDict["etc"] = {
            "AC6.6.18.0.cmake", "ac6_linker_script.sct", "gcc_linker_script.ld",
            "iar_linker_script.icf", "CPRJ.xsd", "PACK.xsd", "GCC.10.3.1.cmake",
            "CLANG.16.0.0.cmake", "IAR.9.32.1.cmake", "setup",
            "{{ProjectName}}.cproject.yml", "{{SolutionName}}.csolution.yml",
            "clayer.schema.json", "common.schema.json", "cproject.schema.json",
            "cproject.schema.json", "CMakeASM",
            "cbuild.schema.json", "cdefault.schema.json", "cdefault.yml",
            "clang_linker_script.ld", "CMSIS-Build-Utils.cmake", "csolution.schema.json"}
        self.assertFalse(path.isfile(path.join(self.BASE_ARCHIVE_PATH,"LICENSE.txt")))
        for dir in dirDict:
            for file in dirDict[dir]:
                self.assertFalse(path.isfile(path.join(self.BASE_ARCHIVE_PATH, dir, file + binExtn)))


if __name__ == '__main__':
    unittest.main()
