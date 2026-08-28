from std.testing import TestSuite, assert_equal

from ziprs_ci_consumer import round_trip


def test_git_dependency_round_trip() raises:
    assert_equal(round_trip(), "resolved through a Git source dependency")


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
