import glob
from pathlib import Path
import subprocess
import re
# import os

def glob_files_in_directory(directory:str, pattern: str, recursive: bool):
    yaml_files = glob.glob(directory + '/**/' + pattern, recursive=recursive)
    return yaml_files

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

# def insert_at_front(lst, item):
#     """
#     Inserts an item at the front of the list.
    
#     :param lst: List to insert the item into
#     :param item: Item to insert
#     :return: Modified list with the item inserted at the front
#     """
#     lst.insert(0, item)
#     return lst

# def remove_read_only(path):
#     # Remove read-only attribute on a file or directory
#     def onerror(func, path, exc_info):
#         # Is the error an access error?
#         if not os.access(path, os.W_OK):
#             os.chmod(path, stat.S_IWUSR)
#             func(path)
#         else:
#             raise

#     if os.path.isdir(path):
#         for root, dirs, files in os.walk(path):
#             for dir in dirs:
#                 os.chmod(os.path.join(root, dir), stat.S_IWUSR | stat.S_IREAD)
#             for file in files:
#                 os.chmod(os.path.join(root, file), stat.S_IWUSR | stat.S_IREAD)
#     else:
#         os.chmod(path, stat.S_IWUSR | stat.S_IREAD)
