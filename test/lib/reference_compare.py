import argparse
import sys
import re

class SummaryResult:
    def __init__(self, passed, failed, skipped, total):
        self.passed = passed
        self.failed = failed
        self.skipped = skipped
        self.total = total

    def __eq__(self, other):
        if isinstance(other, SummaryResult):
            return (self.passed == other.passed and
                    self.failed == other.failed and
                    self.skipped == other.skipped and
                    self.total == other.total)
        return False

    def __str__(self):
        return f'SummaryResult(passed={self.passed}, failed={self.failed}, skipped={self.skipped}, total={self.total})'

class MarkdownReader:
    def __init__(self, input_file_path: str):
        self.input_file = input_file_path
        self.content = ""

    def read(self):
        # Read the Markdown file
        try:
            with open(self.input_file, 'r') as file:
                self.content = file.read()
        except FileNotFoundError:
            print(f"File not found: {self.input_file}", file=sys.stderr)
            raise
        except Exception as e:
            print(f"Error reading file {self.input_file}: {e}", file=sys.stderr)
            raise

    def extract_summary(self):
        self.read()
        # Use regex to find the Summary section and extract the table values
        summary_pattern = re.compile(
            r"## Summary\n\n\|:white_check_mark: Passed\|:x: Failed\|:fast_forward: Skipped\|Total\|\n"
            r"\|:----:\|:----:\|:-----:\|:---:\|\n\|(\d+)\|(\d+)\|(\d+)\|(\d+)\|"
        )
        match = summary_pattern.search(self.content)
        if match:
            return SummaryResult(*map(int, match.groups()))
        else:
            print(f"No summary found in file: {self.input_file}", file=sys.stderr)
            return None

def compare_summaries(markdown_file: str, reference_file: str):
    md_summary = MarkdownReader(markdown_file).extract_summary()
    ref_summary = MarkdownReader(reference_file).extract_summary()

    if md_summary is None or ref_summary is None:
        print("Comparison could not be performed due to missing summary data.", file=sys.stderr)
        return False

    if md_summary != ref_summary:
       print(f"error: Test results do not match the reference\n"
          f"  Expected: Passed: {ref_summary.passed}, Failed: {ref_summary.failed}, Skipped: {ref_summary.skipped}, Total: {ref_summary.total}\n"
          f"  Actual: Passed: {md_summary.passed}, Failed: {md_summary.failed}, Skipped: {md_summary.skipped}, Total: {md_summary.total}")
       return 1 # failure
    
    return 0 # success

# def main():
#     parser = argparse.ArgumentParser(description='Compare summaries in Markdown files.')
#     parser.add_argument('-r', '--reference_file', type=str, required=True, help='Path to reference file')
#     parser.add_argument('-m', '--markdown_file', type=str, default='summary_report.md', help='Path to consolidated summary markdown file')
#     args = parser.parse_args()

#     if compare_summaries(args.markdown_file, args.reference_file):
#         print("Summaries are equal.")
#     else:
#         print("Summaries are not equal.")

# if __name__ == '__main__':
#     try:
#         main()
#     except Exception as e:
#         print(f'An error occurred: {e}', file=sys.stderr)
#         sys.exit(1)
