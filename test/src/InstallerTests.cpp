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
                "AC5.5.6.7.cmake", "AC6.6.18.0.cmake",
                "CPRJ.xsd", "GCC.11.2.1.cmake",
                "IAR.8.50.6.cmake", "setup",
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
    { "bin", vector<string>{
              "cbuild.sh", "cbuildgen.exe","cbuildgen.lin","cbuildgen.mac",
              "cpackget.exe", "cpackget.lin", "cpackget.mac",
              "csolution.exe", "csolution.lin", "csolution.mac" }},
    { "doc", vector<string>{
              "index.html"}},

    { "etc", vector<string>{
                "AC5.5.6.7.cmake", "AC6.6.18.0.cmake",
                "CPRJ.xsd", "GCC.11.2.1.cmake",
                "IAR.8.50.6.cmake", "setup",
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

// Test installer with Invalid arguments
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
