#ifndef TOOLBOXTESTENV_H
#define TOOLBOXTESTENV_H
/*
 * Copyright (c) 2020-2022 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include "gtest/gtest.h"

#include "CrossPlatformUtils.h"
#include "RteFsUtils.h"

#include <string>
#include <iostream>

#ifndef SH
#define SH "bash -c"
#endif

extern std::string scripts_folder;
extern std::string testout_folder;

/**
 * @brief global test environment for all the test suites
*/
class ToolboxTestEnv : public ::testing::Environment {
public:
  void SetUp()    override;

  static std::string ci_toolbox_installer_path;
};

#endif // TOOLBOXTESTENV_H
