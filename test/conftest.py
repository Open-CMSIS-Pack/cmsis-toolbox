# -------------------------------------------------------
# Copyright (c) 2023 Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: Apache-2.0
# -------------------------------------------------------

import pytest

def pytest_addoption(parser):
    parser.addoption(
        '--base-path', action='store', default='.', help='Base path for the installation directory'
    )

@pytest.fixture
def base_path(request):
    return request.config.getoption('--base-path')
