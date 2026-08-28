from std.collections import Span

from ziprs import Compression_Deflated, ZipWriter, Archive


def round_trip() raises -> String:
    var writer = ZipWriter()
    writer.add_file(
        "from-git.txt",
        "resolved through a Git source dependency".as_bytes(),
        Compression_Deflated,
    )
    var archive_bytes = writer.finish()

    var storage = archive_bytes.to_list()
    var archive = Archive(Span(storage))
    var index = archive.index_for_name("from-git.txt").value()
    var contents = archive.read_entry(index).to_list()
    return String(from_utf8=Span(contents))
