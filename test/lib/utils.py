import glob
from pathlib import Path

def glob_files_in_directory(directory:str, pattern: str, recursive: bool):
    yaml_files = glob.glob(directory + '/**/' + pattern, recursive=recursive)
    return yaml_files

def get_parent_directory_name(file_path:str):
    parent_dir = Path(file_path).parent
    return parent_dir.name

def get_parent_directory_path(file_path:str):
    return Path(file_path).parent.absolute()
