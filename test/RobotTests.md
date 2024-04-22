# Installation and Running Robot Framework Tests

This guide will walk you through the installation process and running of Robot Framework tests.

## Prerequisites

Before running Robot Framework tests, ensure you have the following prerequisites installed on your system:

- Python (minimum recommended version **3.11**)
- pip (python package manager)

## Install Robot Framework

Install Robot Framework and its dependencies using pip:

```bash
cd <root_dir>
pip install --upgrade pip
pip install -r test/requirements.txt
```

## Running Tests

### Run all tests

This command will run all tests located in the `test` directory and place the test reports and logs under specified directory.

```bash
robot -d <output_directory> <path_to_tests>
robot -d results ./test
```

### Running Specific Tests

To run specific tests, use the `--test` options:

```bash
robot --test <test_name> <path_to_tests>
```

for e.g.

```bash
robot --test "Validate build-c Example"  test/test.robot
```

## Adding Tests

The test cases in [test.robot](./test.robot) are implemented in a data-driven style, where each test case utilizes a single higher-level keyword to encapsulate the test workflow. To incorporate a new example for validation, follow the steps outlined below.

- Add Example under [data](./data/) directory.
- Add test details under **Test Cases** section following below conventions

  ```robot
  # <Name of the Test>
  #    <Path to the input <project>.csolution.yml file>    <Expected build status>    <Example root directory name>
  ```

  for e.g.

    ```robot
    Validate USB Example
        ${TEST_DATA_DIR}${/}${USB}${/}solution.csolution.yml    ${0}    ${USB}
    ```

```txt
☑️ Note:
    All options in the tests should be separated by **TABs**.
    For more information on robot test follow https://docs.robotframework.org/docs/testcase_styles/datadriven
```
