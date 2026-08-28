---
title: ziprs
type: docs
---

`ziprs` is a compiled Mojo interface to Rust's `zip` crate. It supports reading ZIP archives and
creating Stored or Deflate-compressed archives through an ordinary Mojo package import.

All archive I/O is in memory: open an `Archive` from bytes, or collect bytes from a `ZipWriter` and
write them wherever your application needs. The Rust implementation is installed transitively; a
downstream Mojo program imports only `ziprs`.

## Install from Git

Enable Pixi source builds once, then add the package and install it:

```sh
pixi workspace preview add pixi-build
pixi add --git "https://github.com/ExtraMojo/zipprs-llm.git" ziprs && pixi install
```

For reproducible builds, pin a full Git `rev` in `pixi.toml` instead of following a branch.

## Complete in-memory example

This program creates a Deflate-compressed archive, opens it again, inspects its metadata, and reads
the file contents. It is compiled and run as part of the documentation build.

```mojo {doctest="homepage" global=true}
from std.collections import Span

from ziprs import Archive, Compression_Deflated, ZipWriter


def main() raises:
    var writer = ZipWriter()
    writer.add_directory("docs/")
    writer.add_file(
        "docs/hello.txt",
        "hello from Mojo".as_bytes(),
        Compression_Deflated,
    )
    writer.set_comment("created by ziprs")

    var encoded = writer.finish()
    var archive_data = encoded.to_list()

    var archive = Archive(Span(archive_data))
    var index = archive.index_for_name("docs/hello.txt").value()
    var metadata = archive.entry(index)
    var contents = archive.read_entry(index).to_list()
    var text = String(from_utf8=Span(contents))

    print(metadata.name(), metadata.size(), metadata.compression_name())
    print(text)
```

`ZipWriter.finish()` returns `ZipBytes`; `to_list()` makes the Mojo-owned byte list passed to
`Archive`. Opening an `Archive` copies that input, so the original list does not need to outlive it.

## Choose a task

| Goal | Guide | Main API |
| --- | --- | --- |
| Create an archive | [Writing archives](guide/writing/) | [`ZipWriter`](ziprs/lib/ZipWriter/) |
| Open and inspect an archive | [Reading archives](guide/reading/) | [`Archive`](ziprs/lib/Archive/) |
| Copy native results into Mojo storage | [Quickstart](guide/quickstart/) | [`ZipBytes`](ziprs/lib/ZipBytes/) |
| Inspect names, sizes, CRC-32, and file kind | [Safe metadata handling](guide/reading/#inspect-metadata-safely) | [`Entry`](ziprs/lib/#aliases) |

The [complete API reference](ziprs/) includes arguments, return values, raised errors, and focused
examples for every public `Archive`, `ZipWriter`, and `ZipBytes` method.

## Reading untrusted archives

- Inspect `Entry.size()` and enforce an application-specific limit before decompressing.
- Check `Entry.enclosed_name()` before treating a stored name as a filesystem path.
- Use `Archive.read_into()` when you want to control the exact destination allocation.
- `ziprs` reads and writes archive data; it deliberately does not extract files to disk.

## Design notes

- `Archive` copies its input, so the source byte buffer does not need to outlive it.
- `ZipWriter.finish()` finalizes once and returns a `ZipBytes` owner.
- `ZipBytes.to_list()` transfers native bytes into ordinary Mojo-owned storage.
- Check `Entry.enclosed_name()` before treating an archive entry name as a filesystem path.

The generated `ziprs_native` bridge is an implementation detail installed transitively by Pixi.
