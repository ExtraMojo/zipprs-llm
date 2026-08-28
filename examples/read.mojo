from std.collections import Span
from std.sys import argv

from ziprs import Archive


def main() raises:
    var arguments = argv()
    var input_path = String("example.zip")
    if len(arguments) > 1:
        input_path = String(arguments[1])

    with open(input_path, "r") as input_file:
        var archive_data = input_file.read_bytes()
        var archive = Archive(Span(archive_data))

        print("archive:", input_path)
        print("entries:", archive.len())
        for raw_index in range(Int(archive.len())):
            var index = UInt(raw_index)
            var entry = archive.entry(index)
            print(
                "-",
                entry.name(),
                "size:",
                entry.size(),
                "compressed:",
                entry.compressed_size(),
                "method:",
                entry.compression_name(),
            )

            var safe_name = entry.enclosed_name()
            if not safe_name:
                print("  warning: the entry name is not safe for extraction")

            if entry.is_file():
                var contents = archive.read_entry(index)
                print("  read", contents.len(), "content bytes")
