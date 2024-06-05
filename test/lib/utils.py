import glob
from pathlib import Path
import shutil
import subprocess
import re

def glob_files_in_directory(directory:str, pattern: str, recursive: bool):
    yaml_files = glob.glob(directory + '/**/' + pattern, recursive=recursive)
    return yaml_files

def get_parent_directory_name(file_path:str):
    parent_dir = Path(file_path).parent
    return parent_dir.name

def get_parent_directory_path(file_path:str):
    return Path(file_path).parent.absolute()

def write_test_environment(test_env_file:str):
    toolList = ["cbuild", "cpackget", "csolution", "cbuild2cmake", "cbuildgen"]

    # Create markdown content
    markdown_content = "|Name|Version|\n"
    markdown_content += "|:---|:------|\n"

    for index in range(0, len(toolList)):
        version = "unknown"
        tool = toolList[index]
        versionCmd = tool + ' -V'
        output = subprocess.run(versionCmd, shell=True, universal_newlines=True, capture_output=True)
        if output.stdout != "":
            result = re.search(r"(\d+\.\d+\.\d+.*) \(C\)", output.stdout)
            if result:
                if len(result.groups()) > 0:
                    version = result.group(1)
        markdown_content += "|" + tool + "|" + version + "|\n"

    # Write tool version info
    with open(test_env_file, "w") as file:
        file.write(markdown_content)
