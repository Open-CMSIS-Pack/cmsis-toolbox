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

    def extract_passed_tests(self):
        self.read()
        
        passed_tests_pattern = re.compile(
            r"## Passed Tests\n\n\|Tag\|Test\|:clock1030: Duration\|Suite\|\n\|:---:\|:---:\|:---:\|:---:\|\n((\|.+\|\n)+)"
        )

        # Find the failed tests section
        passed_tests_section = passed_tests_pattern.search(self.content)
    
        # Extract the passed tests table if it exists
        if not passed_tests_section:
            return []

        passed_tests_table = passed_tests_section.group(1)
    
        # Regular expression to extract tag and test name from each row
        # test_pattern = re.compile(r"\|(.+?)\|(.+?)\|.+?\|.+?\|.+?\|")
        test_pattern = re.compile(r"(\|.+?\|.+?\|).+?\|.+?\|")

        # Find all matches
        passed_tests = test_pattern.findall(passed_tests_table)
        return passed_tests

def compare_test_results(markdown_file: str, reference_file: str):
    md_file = MarkdownReader(markdown_file)
    ref_file = MarkdownReader(reference_file)

    md_summary = md_file.extract_summary()
    ref_summary = ref_file.extract_summary()

    if md_summary is None or ref_summary is None:
        print("Comparison could not be performed due to missing summary data.", file=sys.stderr)
        return False

    error = 0
    if md_summary != ref_summary:
       print(f"error: Test results do not match the reference\n"
          f"  Expected: Passed: {ref_summary.passed}, Failed: {ref_summary.failed}, Skipped: {ref_summary.skipped}, Total: {ref_summary.total}\n"
          f"  Actual: Passed: {md_summary.passed}, Failed: {md_summary.failed}, Skipped: {md_summary.skipped}, Total: {md_summary.total}")
       error = 1 # failure
    
    md_passed_tests = md_file.extract_passed_tests()
    ref_passed_tests = ref_file.extract_passed_tests()

    for testInfo in md_passed_tests:
        if testInfo in ref_passed_tests:
            ref_passed_tests.remove(testInfo)

    if len(ref_passed_tests) > 0:
        print(f"error: Regression detected. The following tests were expected to execute and pass:")
        for reg_test in ref_passed_tests:
            print(f"  {reg_test}")
        error = 1 # failure

    return error

def main():
    parser = argparse.ArgumentParser(description='Compare test results in Markdown files.')
    parser.add_argument('-r', '--reference_file', type=str, required=True, help='Path to reference file')
    parser.add_argument('-m', '--markdown_file', type=str, default='summary_report.md', help='Path to consolidated summary markdown file')
    args = parser.parse_args()

    if compare_test_results(args.markdown_file, args.reference_file):
        print("Regression found")
    else:
        print("No regression found")

if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        print(f'An error occurred: {e}', file=sys.stderr)
        sys.exit(1)
