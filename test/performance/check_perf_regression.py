import json
import sys
import argparse

def load_json_file(file_path: str) -> dict:
    """
    Load and parse a JSON file.

    Args:
        file_path (str): Path to the JSON file.

    Returns:
        dict: Parsed JSON data.
    """
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            return json.load(file)
    except FileNotFoundError:
        sys.stderr.write(f"Error: File not found - {file_path}\n")
        sys.exit(1)
    except json.JSONDecodeError:
        sys.stderr.write(f"Error: Failed to parse JSON - {file_path}\n")
        sys.exit(1)


def compare_performance_results(ref_data: dict, curr_data: dict, permissible_limit: float) -> list:
    """
    Compare reference and current performance data.

    Args:
        ref_data (dict): Reference JSON data.
        curr_data (dict): Current JSON data.
        permissible_limit (float): Multiplier threshold for acceptable performance regression.

    Returns:
        list: List of error messages if performance regressions are found.
    """
    errors = []

    ref_results = ref_data.get("results", [])
    curr_results = curr_data.get("results", [])

    # Check if both JSON files contain results
    if not ref_results or not curr_results:
        sys.stderr.write("Error: Missing 'results' key or empty results in input JSON files.\n")
        sys.exit(1)

    # Warn if the number of results differ
    if len(ref_results) != len(curr_results):
        sys.stderr.write("Warning: Mismatch in number of results between reference and current JSON files.\n")

    for index, (ref, curr) in enumerate(zip(ref_results, curr_results)):
        command = curr.get("command", f"Unknown Command (Index: {index})")
        ref_time = ref.get("mean")
        curr_time = curr.get("mean")

        # Ensure 'mean' values exist
        if ref_time is None or curr_time is None:
            sys.stderr.write(f"Warning: Missing 'mean' value in results at index {index}.\n")
            continue  # Skip invalid entries

        threshold = ref_time * permissible_limit
        if curr_time > threshold:
            errors.append(
                f"⚠️ Performance regression detected in `{command}`: "
                f"{curr_time:.3f}s (was {ref_time:.3f}s)"
            )

    return errors


def main():
    parser = argparse.ArgumentParser(description="Compare performance results")
    parser.add_argument("-r", "--reference_data_file", type=str, required=True, help="Path to reference JSON file")
    parser.add_argument("-c", "--current_data_file", type=str, required=True, help="Path to current JSON file")
    parser.add_argument(
        "-p", "--permissible_limit",
        type=float,
        default=1.10,
        help="Permissible limit multiplier for regression tolerance (default: 1.10)"
    )
    args = parser.parse_args()

    ref_data = load_json_file(args.reference_data_file)
    curr_data = load_json_file(args.current_data_file)

    failures = compare_performance_results(ref_data, curr_data, args.permissible_limit)

    if failures:
        print("\n".join(failures))
        sys.exit(1)  # Fail the GitHub job
    else:
        print("✅ All cbuild setup executions are within permissible limits.")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        sys.stderr.write(f"An error occurred: {e}\n")
        sys.exit(1)
