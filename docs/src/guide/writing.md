---
title: Writing archives
type: docs
weight: 20
---

`ZipWriter` accumulates a ZIP archive in memory. Add directory and file entries, optionally attach
an archive comment, and call `finish()` once to write the central directory.

## Build an archive

```mojo {doctest="writing" global=true}
from ziprs import Compression_Deflated, Compression_Stored, ZipWriter
```

```mojo {doctest="writing" global=true hide=true}
from std.testing import assert_true
```

```mojo {doctest="writing"}
var writer = ZipWriter()
writer.add_directory("docs/")
writer.add_file(
    "docs/readme.txt",
    "Compressed text belongs here.\n".as_bytes(),
    Compression_Deflated,
)
writer.add_file(
    "version.txt",
    "1\n".as_bytes(),
    Compression_Stored,
)
writer.set_comment("created by ziprs")

var encoded = writer.finish()
var archive_data = encoded.to_list()
```

```mojo {doctest="writing" hide=true}
assert_true(writer.is_finished())
assert_true(len(archive_data) > 0)
```

## Choose compression

| Constant | Behavior | Typical use |
| --- | --- | --- |
| `Compression_Deflated` | Compresses with Deflate and is the default. | Text and other compressible data. |
| `Compression_Stored` | Copies bytes without compression. | Already-compressed data or minimum CPU work. |

Compression is selected per file. Directory entries are Stored automatically.

## Save the result

`finish()` returns `ZipBytes`. Convert it to a list and pass a span to Mojo's file API:

```mojo
from std.collections import Span

var archive_data = encoded.to_list()
with open("example.zip", "w") as output:
    output.write_bytes(Span(archive_data))
```

After `finish()` succeeds, `is_finished()` returns `True`; further calls that add entries, change the
comment, or finish again raise an error.
