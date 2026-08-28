# Generated Mojo integration tests for the zip 8.6.0 binding.
# Generator: rust-to-mojo binding workflow 0.1.0; Mojo: 1.0.0.

from std.collections import Span
from std.testing import TestSuite, assert_equal, assert_false, assert_true

from ziprs_native import (
    Archive,
    ArchiveResult,
    BytesResult,
    Compression_Deflated,
    Compression_Stored,
    EntryResult,
    UnitResult,
    ZipWriter,
)


def _require_unit_success(result: UnitResult) raises:
    if not result.is_ok():
        raise Error(result.error())


def _require_bytes_success(result: BytesResult) raises:
    if not result.is_ok():
        raise Error(result.error())


def _require_archive_success(result: ArchiveResult) raises:
    if not result.is_ok():
        raise Error(result.error())


def _require_entry_success(result: EntryResult) raises:
    if not result.is_ok():
        raise Error(result.error())


def test_write_read_and_metadata_round_trip() raises:
    var writer = ZipWriter()
    var directory_result = writer.add_directory("safe/")
    _require_unit_success(directory_result)

    var stored_payload = String("stored payload")
    var stored_result = writer.add_file(
        "safe/stored.txt", stored_payload.as_bytes(), Compression_Stored
    )
    _require_unit_success(stored_result)

    var deflated_payload = String("deflated payload deflated payload")
    var deflated_result = writer.add_file(
        "safe/deflated.txt", deflated_payload.as_bytes(), Compression_Deflated
    )
    _require_unit_success(deflated_result)

    var comment_result = writer.set_comment("ziprs mojo test")
    _require_unit_success(comment_result)
    var finish_result = writer.finish()
    _require_bytes_success(finish_result)
    var archive_bytes = finish_result.take()
    assert_true(writer.is_finished())

    var archive_storage = List[UInt8]()
    for _ in range(Int(archive_bytes.len())):
        archive_storage.append(0)
    assert_equal(
        archive_bytes.fill(Span(archive_storage)), UInt(len(archive_storage))
    )

    var open_result = Archive.open(Span(archive_storage))
    _require_archive_success(open_result)
    var archive = open_result.take()
    assert_equal(archive.len(), 3)
    assert_false(archive.is_empty())

    var maybe_index = archive.index_for_name("safe/deflated.txt")
    assert_true(maybe_index)
    var index = maybe_index.value()
    var entry_result = archive.entry(index)
    _require_entry_success(entry_result)
    var entry = entry_result.take()
    var entry_name = entry.name()
    assert_equal(entry_name, "safe/deflated.txt")
    var enclosed_name = entry.enclosed_name()
    assert_equal(enclosed_name.value(), "safe/deflated.txt")
    assert_equal(entry.compression_code(), 8)
    var compression_name = entry.compression_name()
    assert_equal(compression_name, "Deflated")
    assert_true(entry.is_file())
    assert_false(entry.is_dir())

    var read_result = archive.read_entry(index)
    _require_bytes_success(read_result)
    var contents = read_result.take()
    var output = String(unsafe_uninit_length=Int(contents.len()))
    assert_equal(contents.fill(output.unsafe_as_bytes_mut()), contents.len())
    assert_equal(output, deflated_payload)


def test_invalid_archive_keeps_dynamic_error() raises:
    var invalid = String("not a zip archive")
    var result = Archive.open(invalid.as_bytes())
    assert_false(result.is_ok())
    assert_true(result.error().byte_length() > 0)


def main() raises:
    TestSuite.discover_tests[__functions_in_module()]().run()
