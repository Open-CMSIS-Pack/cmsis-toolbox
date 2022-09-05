/*
 * Copyright (c) 2020-2022 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "ToolboxTestEnv.h"

using namespace std;

error_code errorCode;
string scripts_folder = string(TEST_FOLDER) + "scripts";
string testout_folder = fs::current_path(errorCode).append("testoutput").generic_string();

std::string ToolboxTestEnv::ci_toolbox_installer_path;

void ToolboxTestEnv::SetUp() {
  error_code ec;
  fs::create_directories(testout_folder, ec);

  scripts_folder = fs::canonical(scripts_folder, ec).generic_string();
  testout_folder = fs::canonical(testout_folder, ec).generic_string();

  ci_toolbox_installer_path = CrossPlatformUtils::GetEnv("CI_TOOLBOX_INSTALLER");
}

int main(int argc, char **argv) {
  try {
    testing::InitGoogleTest(&argc, argv);
    ::testing::AddGlobalTestEnvironment(new ToolboxTestEnv);
    return RUN_ALL_TESTS();
  }
  catch (testing::internal::GoogleTestFailureException const& e) {
    std::cout << "runtime_error: " << e.what();
    return 2;
  }
  catch (...) {
    std::cout << "non-standard exception";
    return 2;
  }
}
