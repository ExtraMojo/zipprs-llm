from std.collections import Span
from std.testing import TestSuite, assert_equal, assert_false, assert_raises, assert_true

from ziprs import Archive, Compression_Stored, ZipWriter


def test_public_facade_round_trip() raises:
    var writer = ZipWriter()
    writer.add_directory("docs/")
    var payload = String("hello from ziprs")
    writer.add_file("docs/hello.txt", payload.as_bytes(), Compression_Stored)
    writer.set_comment("ziprs public test")
    var archive_bytes = writer.finish()
    assert_true(writer.is_finished())

    var storage = archive_bytes.to_list()
    var archive = Archive(Span(storage))
    assert_equal(archive.len(), 2)
    assert_false(archive.is_empty())

    var maybe_index = archive.index_for_name("docs/hello.txt")
    assert_true(maybe_index)
    var index = maybe_index.value()
    var entry = archive.entry(index)
    var name = entry.name()
    assert_equal(name, "docs/hello.txt")
    assert_equal(entry.size(), UInt64(payload.byte_length()))

    var contents = archive.read_entry(index)
    var output = contents.to_list()
    var decoded = String(from_utf8=Span(output))
    assert_equal(decoded, payload)


def test_dynamic_parse_error_raises() raises:
    var invalid = String("not a zip archive")
    with assert_raises():
        _ = Archive(invalid.as_bytes())


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
