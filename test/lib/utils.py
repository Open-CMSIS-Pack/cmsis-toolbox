import glob
from pathlib import Path
import subprocess
import re
import os
import fnmatch
import platform

def glob_files_in_directory(directory: str, pattern: str, recursive: bool, ignore_dir: str = None):
    matched_files = []
    
    # Use os.walk to iterate over the directory
    for root, dirs, files in os.walk(directory):
        # If ignore_dir is specified, filter out directories to ignore
        if ignore_dir:
            dirs[:] = [d for d in dirs if d != ignore_dir]
        
        # Use glob to match files in the current root directory
        matched_files.extend(glob.glob(os.path.join(root, pattern)))
        
        # If not recursive, break after the first iteration (top-level)
        if not recursive:
            break

    return matched_files

def get_parent_directory_name(file_path:str):
    parent_dir = Path(file_path).parent
    return parent_dir.name

def get_parent_directory_path(file_path:str):
    absPath = Path(file_path).parent.absolute()
    path = str(absPath).replace('\\', '/')
    return path

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

def get_operating_system():
    return platform.system()
