import re
import pandas as pd
import argparse
import sys

def extract_mean_times(markdown_file, verbose=False):
    if verbose:
        print(f"Parsing file: {markdown_file}")
    with open(markdown_file, "r") as f:
        content = f.read()

    rows = []
    lines = content.splitlines()
    in_table = False

    for i, line in enumerate(lines):
        line = line.strip()

        # Check for the header line that contains "Mean [ms]"
        if not in_table and "Mean [ms]" in line and line.startswith("|"):
            in_table = True
            continue  # skip to next line (formatting line)

        # Skip the formatting line after header
        if in_table and re.match(r"^\|[:\- ]+\|$", line):
            continue

        # Process table rows
        if in_table and line.startswith("|"):
            cols = [c.strip() for c in line.strip("|").split("|")]
            if len(cols) >= 5:
                command = cols[0]
                mean_match = re.search(r"([\d.]+)", cols[1])  # Extract only mean part before ±
                if mean_match:
                    mean = float(mean_match.group(1))
                    cleaned_cmd = re.sub(r"\./(ref_test_dir|curr_test_dir)/", "./", command)
                    rows.append((cleaned_cmd, mean))
                    if verbose:
                        print(f"  Found: {cleaned_cmd} -> {mean} ms")
        elif in_table:
            break  # exit if we're past the table

    return dict(rows)

def generate_comparison_table(ref_data, curr_data, verbose=False):
    comparison = []
    print(f"ref_data: {ref_data}")
    print(f"curr_data: {curr_data}")
    for command in ref_data:
        print(f"Comparing: {command}")
        if command in curr_data:
            ref = ref_data[command]
            curr = curr_data[command]
            delta = round(curr - ref, 1)
            pct = round((delta / ref) * 100, 2)
            comparison.append((command, ref, curr, delta, pct))
            if verbose:
                print(f"  Compared: {command} | Ref: {ref} | Curr: {curr} | Δ: {delta} | %: {pct}")
    df = pd.DataFrame(comparison, columns=["Test", "Reference (ms)", "Current (ms)", "Delta (ms)", "Change (%)"])
    return df

def main():
    parser = argparse.ArgumentParser(
        description="Compare benchmark Mean [ms] values from two markdown performance reports."
    )
    parser.add_argument("reference", help="Path to reference markdown file (e.g., released_benchmark_results.md)")
    parser.add_argument("current", help="Path to current markdown file (e.g., current_benchmark_results.md)")
    parser.add_argument("-o", "--output", help="Optional output file to write the markdown table")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose logging")

    args = parser.parse_args()

    try:
        ref_times = extract_mean_times(args.reference, verbose=args.verbose)
        curr_times = extract_mean_times(args.current, verbose=args.verbose)
    except FileNotFoundError as e:
        print(f"Error: {e}")
        sys.exit(1)

    df_comparison = generate_comparison_table(ref_times, curr_times, verbose=args.verbose)

    if df_comparison.empty:
        print("⚠️  No matching commands found between the two files.")
        sys.exit(0)

    output_md = df_comparison.to_markdown(index=False)

    if args.output:
        with open(args.output, "w") as f:
            f.write(output_md + "\n")
        print(f"✅ Comparison table written to {args.output}")
    else:
        print("\n" + output_md)

if __name__ == "__main__":
    main()
