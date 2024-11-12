import hashlib
import yaml  # To install, use: pip install pyyaml
import argparse
import subprocess
import re
import os
import logging
import sys

# Set up logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

# Define the binary files
BINARY_FILES = ["cbridge", "cbuild", "cbuild2cmake", "cbuildgen", "cpackget", "csolution", "packchk", "svdconv", "vidx2pidx"]

def calculate_checksum(filepath):
    """Calculate SHA-256 checksum of a file."""
    sha256 = hashlib.sha256()
    try:
        with open(filepath, "rb") as f:
            while chunk := f.read():
                sha256.update(chunk)
        return sha256.hexdigest()
    except FileNotFoundError:
        logging.warning(f"File not found: {filepath}")
        return None
    except Exception as e:
        logging.error(f"Error calculating checksum for {filepath}: {e}")
        return None

def get_version(binary_path):
    """Retrieve the version of the binary using the '-V' flag."""
    # Ensure the binary is executable
    try:
        result = subprocess.run(
            [binary_path, '-V'],
            shell=True,
            capture_output=True,
            universal_newlines=True
        )
        match = re.search(r'\b\d+\.\d+\.\d+(?:[-+][\w\.]+)?\b', result.stdout)
        if match:
            return match.group()
        else:
            logging.warning(f"Version format not found in output for {binary_path}")
            return "unknown"
    except subprocess.CalledProcessError as e:
        logging.error(f"Error retrieving version for {binary_path}: {e}")
        return "unknown"

def generate_manifest(args):
    """Generate the manifest with checksums and versions for binaries."""
    checksums = {}
    for binary in BINARY_FILES:
        binary_path = os.path.join(args.toolbox_root_dir, f"bin/{binary}{args.bin_extn}")
        checksum = calculate_checksum(binary_path)
        if checksum:
            version = get_version(binary_path)
            checksums[binary] = {"version": version, "sha256": checksum}

    manifest = {
        "name": "CMSIS-Toolbox",
        "version": args.toolbox_version,
        "binaries": checksums
    }
    return manifest

def write_manifest(manifest, output_file):
    """Write the manifest to a YAML file."""
    try:
        with open(output_file, "w") as manifest_file:
            yaml.dump(manifest, manifest_file, sort_keys=False)
    except Exception as e:
        logging.error(f"Error writing manifest to {output_file}: {e}")
        sys.exit(1)

def parse_arguments():
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description="Generate manifest file")
    parser.add_argument('-d', '--toolbox_root_dir', type=str, required=True, help='Root directory of CMSIS-Toolbox')
    parser.add_argument('-e', '--bin_extn', type=str, default='', help='Binary extension, e.g., .exe for Windows')
    parser.add_argument('-v', '--toolbox_version', type=str, help='Release version number of CMSIS-Toolbox')

    args = parser.parse_args()
    args.toolbox_version = args.toolbox_version or os.getenv("GITHUB_REF_NAME", "refs/tags/v1.0.0").split('/')[-1]

    return args

def main():
    args = parse_arguments()
    manifest = generate_manifest(args)
    output_manifest_file = os.path.join(args.toolbox_root_dir, f"manifest_{args.toolbox_version}.yml")
    manifest_filename = f"manifest_{args.toolbox_version}.yml"
    write_manifest(manifest, output_manifest_file)

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")
        sys.exit(1)
