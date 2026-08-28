"""Reads and writes ZIP archives through a Rust-backed in-memory API.

The package exports [ziprs.lib.Archive Archive] for inspection and decompression,
[ziprs.lib.ZipWriter ZipWriter] for archive creation, [ziprs.lib.Entry Entry] for metadata, and
[ziprs.lib.ZipBytes ZipBytes] for owned native byte buffers. Supported writing methods are
[ziprs.lib.Compression_Stored Compression_Stored] and
[ziprs.lib.Compression_Deflated Compression_Deflated].

Examples:

```mojo
from std.collections import Span

from ziprs import Archive, ZipWriter

var writer = ZipWriter()
writer.add_file("hello.txt", "hello".as_bytes())
var archive_bytes = writer.finish()
var encoded = archive_bytes.to_list()

var archive = Archive(Span(encoded))
var index = archive.index_for_name("hello.txt").value()
var decoded = archive.read_entry(index).to_list()
print(String(from_utf8=Span(decoded)))
```
"""

from .lib import (
    Archive,
    Compression,
    Compression_Deflated,
    Compression_Stored,
    Entry,
    ZipBytes,
    ZipWriter,
)
