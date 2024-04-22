import sys
from robot.api import ExecutionResult, ResultVisitor
from robot.result.model import TestCase

class ResultVisitorEx(ResultVisitor):
    def __init__(self, markdown_file='summary_report.md'):
        self.failed_tests = {}
        self.passed_tests = {}
        self.skipped_tests = {}
        self.markdown_file = markdown_file

    def visit_test(self, test: TestCase):
        update = lambda test_status, tags, status: (
            test_status.update({tags: [status]}) if tags not in test_status else test_status[tags].append(status)
        )

        tags = ", ".join(test.tags)
        status = (test.name, test.message, str(round(test.elapsed_time.total_seconds(), 2)) + ' s', test.parent.name)
        if test.status == 'FAIL':
            update(self.failed_tests, tags, status)
        elif test.status == 'PASS':
            update(self.passed_tests, tags, status)
        elif test.status == 'SKIP':
            update(self.skipped_tests, tags, status)

    def end_result(self, result):
        # Create a new markdown file
        with open(self.markdown_file, "w") as f:
            f.write("# Robot Framework Report\n")
            f.write("## Passed Tests\n")
            f.write("|Tag|Test|:clock1030: Duration|Suite|\n")
            f.write("|:---:|:----:|:------:|:-----:|\n")
            for key, value in self.passed_tests.items():
                for name, msg, duration, suite in value:
                    f.write(f"|{key}|{name}|{duration}|{suite}|\n")

            f.write("\n## Failed Tests\n")
            f.write("|Tag|Test|Message|:clock1030: Duration|Suite|\n")
            f.write("|:---:|:----:|:-------:|:------:|:-----:|\n")

            for key, value in self.failed_tests.items():
                for name, msg, duration, suite in value:
                    f.write(f"|{key}|{name}|{msg}|{duration}|{suite}|\n")

            # for key, value in self.skipped_tests.items():
            #     for pair in value:
            #         f.write(f"|{key}|{pair[0]}|{pair[1]}|\n")
                
if __name__ == '__main__':
    try:
        output_file = sys.argv[1]
    except IndexError:
        output_file = "output.xml"
    try:
        markdown_file = sys.argv[2]
    except IndexError:
        markdown_file = "summary_report.md"
    result = ExecutionResult(output_file)
    # print(result.statistics.total.passed)
    # print(result.statistics.total.failed)
    # stats = result.statistics.total.skipped
    result.visit(ResultVisitorEx())
