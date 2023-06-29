/*
 * Copyright (c) 2020-2022 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/*
 * IMPORTANT:
 * These tests are designed to run only in CI environment.
*/

#include "ToolboxTestEnv.h"
#include <fstream>

using namespace std;

class ToolBoxInstallerTests : public ::testing::Test {
  void SetUp();

protected:
  void RunInstallerScript   (const string& arg);
  void CheckInstallationDir (const string& path, bool expect);
  void CheckExtractedDir    (const string& path, bool expect);
};

void ToolBoxInstallerTests::SetUp() {
  if (ToolboxTestEnv::ci_toolbox_installer_path.empty()) {
    GTEST_SKIP();
  }
}

void ToolBoxInstallerTests::RunInstallerScript(const string& arg) {
  int ret_val;
  error_code ec;

  ASSERT_EQ(true, fs::exists(scripts_folder + "/installer_run.sh", ec))
    << "error: installer_run.sh not found";

  string cmd = "cd " + scripts_folder + " && " + SH +
    " \"./installer_run.sh " + arg + "\"";
  ret_val = system(cmd.c_str());

  ASSERT_EQ(ret_val, 0);
}

void ToolBoxInstallerTests::CheckInstallationDir(
  const string& path,
  bool expect)
{
  vector<pair<string, vector<string>>> dirVec = {
    { "bin", vector<string>{
              "cbuild.sh",
              string("cbuildgen") + EXTN,
              string("cpackget") + EXTN,
              string("csolution") + EXTN }},
    { "doc", vector<string>{
              "index.html"}},

    { "etc", vector<string>{
                "AC6.6.18.0.cmake",
                "ac6_linker_script.sct", "gcc_linker_script.ld", "iar_linker_script.icf",
                "CPRJ.xsd", "PACK.xsd", "GCC.10.3.1.cmake",
                //"CLANG.16.0.0.cmake",
                "IAR.9.32.1.cmake", "setup",
                "{{ProjectName}}.cproject.yml",
                "{{SolutionName}}.csolution.yml",
                "clayer.schema.json", "common.schema.json",
                "cproject.schema.json", "cproject.schema.json",
                "CMakeASM"}}
  };

  error_code ec;
  EXPECT_EQ(expect, fs::exists(path, ec)) << "Path " << path << " does "
    << (expect ? "not " : "") << "exist!";

  for (auto dirItr = dirVec.begin(); dirItr != dirVec.end(); ++dirItr) {
    for (auto fileItr = dirItr->second.begin(); fileItr != dirItr->second.end(); ++fileItr) {
      EXPECT_EQ(expect, fs::exists(path + "/" + dirItr->first + "/" + (*fileItr), ec))
        << "File " << (*fileItr) << " does " << (expect ? "not " : "") << "exist!";
    }
  }

  EXPECT_EQ(expect, fs::exists(path + "/LICENSE.txt", ec))
    << "File LICENSE.txt does " << (expect ? "not " : "") << "exist!";
}

void ToolBoxInstallerTests::CheckExtractedDir(const string& path, bool expect) {
  vector<pair<string, vector<string>>> dirVec = {
    { "bin", vector<string>{ "cbuild.sh",
              "cbuild.lin-amd64",    "cbuild.exe-amd64",    "cbuild.mac-amd64",
              "cpackget.lin-amd64",  "cpackget.exe-amd64",  "cpackget.mac-amd64",
              "cbuildgen.lin-amd64", "cbuildgen.exe-amd64", "cbuildgen.mac-amd64",
              "csolution.lin-amd64", "csolution.exe-amd64", "csolution.mac-amd64",
              "packchk.lin-amd64",   "packchk.exe-amd64",   "packchk.mac-amd64",
              "svdconv.lin-amd64",   "svdconv.exe-amd64",   "svdconv.mac-amd64",
              "cbuild.lin-arm64",    "cbuild.exe-arm64",    "cbuild.mac-arm64",
              "cpackget.lin-arm64",  "cpackget.exe-arm64",  "cpackget.mac-arm64",
              "cbuildgen.lin-arm64", "cbuildgen.exe-arm64", "cbuildgen.mac-arm64",
              "csolution.lin-arm64", "csolution.exe-arm64", "csolution.mac-arm64",
              "packchk.lin-arm64",   "packchk.exe-arm64",   "packchk.mac-arm64",
              "svdconv.lin-arm64",   "svdconv.exe-arm64",   "svdconv.mac-arm64"}},

    { "doc", vector<string>{
              "index.html"}},

    { "etc", vector<string>{
                "AC6.6.18.0.cmake",
                "ac6_linker_script.sct", "gcc_linker_script.ld", "iar_linker_script.icf",
                "CPRJ.xsd", "PACK.xsd", "GCC.10.3.1.cmake",
                //"CLANG.16.0.0.cmake",
                "IAR.9.32.1.cmake", "setup",
                "{{ProjectName}}.cproject.yml",
                "{{SolutionName}}.csolution.yml",
                "clayer.schema.json", "common.schema.json",
                "cproject.schema.json", "cproject.schema.json",
                "CMakeASM" }}
  };

  error_code ec;
  EXPECT_EQ(expect, fs::exists(path, ec)) << "Path "<< path << " does " << (expect ? "not " : "") << "exist!";

  for (auto dirItr = dirVec.begin(); dirItr != dirVec.end(); ++dirItr) {
    for (auto fileItr = dirItr->second.begin(); fileItr != dirItr->second.end(); ++fileItr) {
      EXPECT_EQ(expect, fs::exists(path + "/" + dirItr->first + "/" + (*fileItr), ec))
        << "File " << (*fileItr) << " does " << (expect ? "not " : "") << "exist!";
    }
  }

  EXPECT_EQ(expect, fs::exists(path + "/LICENSE.txt", ec))
    << "File LICENSE.txt does " << (expect ? "not " : "") << "exist!";
}

// Test installer wih Invalid arguments
TEST_F(ToolBoxInstallerTests, InvalidArgTest) {
  string installDir = testout_folder + "/Installation";
  string arg = "--testoutput=" + testout_folder + " -Invalid";

  RteFsUtils::DeleteTree (installDir);
  RunInstallerScript     (arg);
  CheckInstallationDir   (installDir, true);
}

// Run installer with help command
TEST_F(ToolBoxInstallerTests, InstallerHelpTest) {
  string installDir = testout_folder + "/Installation";
  string arg = "--testoutput=" + testout_folder + " -h";

  RteFsUtils::DeleteTree (installDir);
  RunInstallerScript     (arg);
  CheckInstallationDir   (installDir, false);
}

// Run installer with version command
TEST_F(ToolBoxInstallerTests, InstallerVersionTest) {
  string installDir = testout_folder + "/Installation";
  string arg = "--testoutput=" + testout_folder + " -v";

  RteFsUtils::DeleteTree (installDir);
  RunInstallerScript     (arg);
  CheckInstallationDir   (installDir, false);
}

// Validate installer extract option
TEST_F(ToolBoxInstallerTests, InstallerExtractTest) {
  string arg = "--testoutput=" + testout_folder + " -x " +
    testout_folder + "/Installation/ExtractOut";
  string extractDir = testout_folder + "/Installation/ExtractOut";

  RteFsUtils::DeleteTree (extractDir);
  RunInstallerScript     (arg);
  CheckExtractedDir      (extractDir, true);
}

// Validate installation and post installation content
TEST_F(ToolBoxInstallerTests, ValidInstallationTest) {
  string installDir = testout_folder + "/Installation";
  string arg = "--testoutput=" + testout_folder;

  RteFsUtils::DeleteTree (installDir);
  RunInstallerScript     (arg);
  CheckInstallationDir   (installDir, true);
}
