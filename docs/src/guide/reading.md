---
title: Reading archives
type: docs
weight: 30
---

`Archive` reads from an in-memory span and keeps its own copy. Look entries up by exact name or
iterate their zero-based indexes.

The hidden setup used to test the examples on this page creates a small archive in memory.

```mojo {doctest="reading" global=true}
from std.collections import Span

from ziprs import Archive
```

```mojo {doctest="reading" global=true hide=true}
from std.testing import assert_equal, assert_true
from ziprs import Compression_Deflated, ZipWriter
```

```mojo {doctest="reading" hide=true}
var source_writer = ZipWriter()
source_writer.add_file(
    "docs/readme.txt",
    "hello from the archive".as_bytes(),
    Compression_Deflated,
)
source_writer.set_comment("reading example")
var source_data = source_writer.finish().to_list()
```

## Open and find an entry

```mojo {doctest="reading"}
var archive = Archive(Span(source_data))
print("entry count:", archive.len())

var maybe_index = archive.index_for_name("docs/readme.txt")
if not maybe_index:
    raise Error("required entry is missing")
var index = maybe_index.value()
```

Names are exact and case-sensitive. A missing name returns `None`; opening invalid ZIP bytes or
using an out-of-range numeric index raises an error.

## Inspect metadata safely

`entry()` returns a snapshot containing names, sizes, CRC-32, compression information, file kind,
and an optional Unix mode.

```mojo {doctest="reading"}
var metadata = archive.entry(index)
print("name:", metadata.name())
print("size:", metadata.size())
print("compressed size:", metadata.compressed_size())
print("compression:", metadata.compression_name())

var safe_name = metadata.enclosed_name()
if safe_name:
    print("safe relative path:", safe_name.value())
else:
    print("do not extract this entry name")
```

Never join `name()` directly to an extraction directory. Use `enclosed_name()` and reject `None` to
block absolute paths, parent traversal, and other unsafe path components. `ziprs` deliberately does
not extract files itself.

## Read an allocated result

```mojo {doctest="reading"}
var contents = archive.read_entry(index).to_list()
var text = String(from_utf8=Span(contents))
print(text)
```

`read_entry()` allocates storage for the entire uncompressed entry. ZIP data can claim very large
uncompressed sizes, so applications should inspect `metadata.size()` and apply their own limits
before reading untrusted archives.

## Read into an exact-size buffer

Use `read_into()` to control the allocation. The destination length must exactly match the
uncompressed entry size; partial reads are rejected.

```mojo {doctest="reading"}
var destination = List[UInt8](unsafe_uninit_length=Int(metadata.size()))
var written = archive.read_into(index, Span(destination))
```

```mojo {doctest="reading" hide=true}
assert_equal(text, "hello from the archive")
assert_equal(written, UInt(len(destination)))
assert_true(safe_name)
```

The archive-level comment is available as raw bytes through `archive.comment()`. ZIP comments are
not guaranteed to be UTF-8, so decode them only when the archive's encoding is known.
