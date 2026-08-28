from std.collections import Span
from std.sys import argv

from ziprs import Compression_Deflated, Compression_Stored, ZipWriter


def main() raises:
    var arguments = argv()
    var output_path = String("example.zip")
    if len(arguments) > 1:
        output_path = String(arguments[1])

    var writer = ZipWriter()
    writer.add_directory("docs/")
    writer.add_file(
        "docs/hello.txt",
        "hello from ziprs\n".as_bytes(),
        Compression_Deflated,
    )
    writer.add_file(
        "version.txt",
        "ziprs example v1\n".as_bytes(),
        Compression_Stored,
    )
    writer.set_comment("created by the ziprs writing example")

    var archive = writer.finish()
    var archive_data = archive.to_list()
    with open(output_path, "w") as output_file:
        output_file.write_bytes(Span(archive_data))

    print("wrote", len(archive_data), "bytes to", output_path)
