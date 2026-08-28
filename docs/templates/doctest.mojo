from std.testing import TestSuite

{{range .Global}}{{.}}
{{end}}

{{if .Code -}}
def test_{{.Name}}() raises:
{{range .Code}}    {{.}}
{{end}}
{{- end}}


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
