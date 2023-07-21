import pytest

def pytest_addoption(parser):
    parser.addoption(
        '--base-path', action='store', default='.', help='Base path for the installation directory'
    )

@pytest.fixture
def base_path(request):
    return request.config.getoption('--base-path')
