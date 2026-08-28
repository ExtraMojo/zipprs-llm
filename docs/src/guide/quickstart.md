---
title: Quickstart
type: docs
weight: 10
---

`ziprs` works as an ordinary Mojo package while Pixi builds and installs its Rust shared library.

## Install from Git

Enable Pixi source builds once, then add the package:

```sh
pixi workspace preview add pixi-build
pixi add --git "https://github.com/ExtraMojo/zipprs-llm.git" ziprs && pixi install
```

For reproducible builds, replace the branch selected by `pixi add` with a full `rev` in
`pixi.toml`.

## Round trip in memory

This example writes one Deflate-compressed file, opens the resulting archive, and decodes the file
again without touching the filesystem.

```mojo {doctest="quickstart" global=true}
from std.collections import Span

from ziprs import Archive, Compression_Deflated, ZipWriter
```

```mojo {doctest="quickstart" global=true hide=true}
from std.testing import assert_equal
```

```mojo {doctest="quickstart"}
var writer = ZipWriter()
var message = String("hello from Mojo")
writer.add_file("hello.txt", message.as_bytes(), Compression_Deflated)
var encoded = writer.finish()

var archive_data = encoded.to_list()
var archive = Archive(Span(archive_data))
var index = archive.index_for_name("hello.txt").value()
var decoded = archive.read_entry(index).to_list()
var text = String(from_utf8=Span(decoded))

print(text)  # hello from Mojo
```

```mojo {doctest="quickstart" hide=true}
assert_equal(text, message)
```

`Archive` owns a copy of `archive_data`. `encoded` and `decoded` are `ZipBytes` values backed by
native storage; `to_list()` makes Mojo-owned copies when needed.
