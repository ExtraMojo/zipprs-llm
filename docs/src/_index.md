---
title: ziprs
type: docs
---

`ziprs` is a compiled Mojo interface to Rust's `zip` crate. It supports reading ZIP archives and
creating Stored or Deflate-compressed archives through an ordinary Mojo package import.

## Packages

The public API is exposed by the `ziprs` package. Its generated native bridge is an implementation
detail and is installed transitively by Pixi.
