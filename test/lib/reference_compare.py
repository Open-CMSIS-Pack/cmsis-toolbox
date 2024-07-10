import markdown
import pandas as pd
from io import StringIO

class SummaryResult:
    def __init__(self, passed, failed, skipped, total):
        self.passed = passed
        self.failed = failed
        self.skipped = skipped
        self.total = total

class MarkdownReader:
    def __init__(self, markdown_file_path:str):
      self.markdown_file_path=markdown_file_path
      self.html_content = ""

    def read(self):
      # Read the Markdown file
      with open('path_to_your_markdown_file.md', 'r') as file:
        md_content = file.read()

      # Convert the Markdown to HTML
      self.html_content = markdown.markdown(md_content)

    def extract_summary_table(self):
       # Extract the tables from the HTML
       tables = pd.read_html(StringIO(self.html_content))
       # The second table is the summary table
       summary_table = tables[1]
       # Extract the summary results
       passed = int(summary_table.iloc[0, 0])
       failed = int(summary_table.iloc[0, 1])
       skipped = int(summary_table.iloc[0, 2])
       total = int(summary_table.iloc[0, 3])
       
       return SummaryResult(passed, failed, skipped, total) 


def compare_summary(markdownFile:str, referenceFile:str):
    mdFileSummary = MarkdownReader(markdownFile).extract_summary_table()
    refFileSummary = MarkdownReader(referenceFile).extract_summary_table()
    # Compare the results
    results_match = (
        mdFileSummary.passed == refFileSummary.passed and
        mdFileSummary.failed == refFileSummary.failed and
        mdFileSummary.skipped == refFileSummary.skipped and
        mdFileSummary.total == refFileSummary.total
    )

    return results_match

# print("Summary results match expected values:", results_match)
# print(f"Passed: {passed}, Expected: {expected_passed}")
# print(f"Failed: {failed}, Expected: {expected_failed}")
# print(f"Skipped: {skipped}, Expected: {expected_skipped}")
# print(f"Total: {total}, Expected: {expected_total}")
