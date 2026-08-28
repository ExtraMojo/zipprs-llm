---
title: ziprs
type: docs
---

`ziprs` is a compiled Mojo interface to Rust's `zip` crate. It supports reading ZIP archives and
creating Stored or Deflate-compressed archives through an ordinary Mojo package import.

All archive I/O is in memory: open an `Archive` from bytes, or collect bytes from a `ZipWriter` and
write them wherever your application needs.

## Start here

- [Quickstart](guide/quickstart/) builds and reads an archive in one complete example.
- [Writing archives](guide/writing/) covers compression, directories, comments, and finalization.
- [Reading archives](guide/reading/) covers lookup, metadata, decompression, exact-size buffers,
  and safe entry names.
- [`ziprs` API reference](ziprs/) documents every public type and method.

## Design notes

- `Archive` copies its input, so the source byte buffer does not need to outlive it.
- `ZipWriter.finish()` finalizes once and returns a `ZipBytes` owner.
- `ZipBytes.to_list()` transfers native bytes into ordinary Mojo-owned storage.
- Check `Entry.enclosed_name()` before treating an archive entry name as a filesystem path.

The generated `ziprs_native` bridge is an implementation detail installed transitively by Pixi.
