# ziprs

> [!IMPORTANT]
> This is an AI-generated repository. It was created with the
> [`bind-rust-to-mojo` skill](https://github.com/sstadick/mojo-import-crates-skill/blob/main/SKILL.md)
> from the [`mojo-import-crates-skill`](https://github.com/sstadick/mojo-import-crates-skill)
> project. Review and test the generated bindings before using them in critical applications.

**[API documentation](https://extramojo.github.io/zipprs-llm/)**

`ziprs` is a compiled Mojo library backed by Rust's [`zip` 8.6.0](https://crates.io/crates/zip/8.6.0).
It reads and writes ZIP archives through an ordinary `from ziprs import ...` API while Pixi builds
and installs the Rust shared library as a transitive source dependency.

Supported targets are Linux x86-64, Linux ARM64, and macOS ARM64. The initial API supports Stored
and Deflate compression.

## Depend on `ziprs` from Git

The examples below track `main` so they work before the first release tag exists. For reproducible
builds, pin an immutable commit as shown below.

Enable Pixi's source-build support once with `pixi workspace preview add pixi-build`, then add the
Git source directly to the project:

```sh
pixi add --git "https://github.com/ExtraMojo/zipprs-llm.git" ziprs && pixi install
```

For an application that is only run from its Pixi environment, add `ziprs` to `[dependencies]`:

```toml
[workspace]
channels = [
    "https://prefix.dev/conda-forge",
    "https://conda.modular.com/max",
]
platforms = ["osx-arm64"]
preview = ["pixi-build"]
requires-pixi = ">=0.76"

[dependencies]
mojo = "=1.0.0"
ziprs = { git = "https://github.com/ExtraMojo/zipprs-llm.git", branch = "main" }
```

Then install and import it normally:

```sh
pixi install
pixi run mojo run main.mojo
```

### From another `pixi-build-mojo` package

A packaged Mojo library or executable needs the same Git source in three places:

- `[package.build-dependencies]` makes `ziprs` available while your Mojo package is precompiled.
- `[package.run-dependencies]` installs `ziprs` and its native Rust library for consumers.
- `[dependencies]` makes it available to local development tasks such as `mojo run` and tests.

Here is a complete minimal manifest:

```toml
[workspace]
channels = [
    "https://prefix.dev/conda-forge",
    "https://conda.modular.com/max",
]
platforms = ["osx-arm64"]
preview = ["pixi-build"]
requires-pixi = ">=0.76"

[package]
name = "my-mojo-library"
version = "0.1.0"

[package.build]
backend = { name = "pixi-build-mojo", version = "0.*", channels = [
    "https://prefix.dev/pixi-build-backends",
    "https://prefix.dev/conda-forge",
] }

[package.build.config.pkg]
name = "my_mojo_library"
path = "my_mojo_library"

[package.host-dependencies]
mojo-compiler = "=1.0.0"

[package.build-dependencies]
mojo-compiler = "=1.0.0"
ziprs = { git = "https://github.com/ExtraMojo/zipprs-llm.git", branch = "main" }

[package.run-dependencies]
mojo-compiler = "=1.0.0"
ziprs = { git = "https://github.com/ExtraMojo/zipprs-llm.git", branch = "main" }

[dependencies]
mojo = "=1.0.0"
ziprs = { git = "https://github.com/ExtraMojo/zipprs-llm.git", branch = "main" }
"my-mojo-library" = { path = "." }
```

Pin a tested commit for reproducible builds:

```toml
ziprs = { git = "https://github.com/ExtraMojo/zipprs-llm.git", rev = "<full-commit-sha>" }
```

Pixi resolves the Git checkout as a source package. `ziprs` then builds its vendored Rust bridge and
internal Mojo package automatically; downstream projects should not depend on
`ziprs-rust-mojo-bindings` directly.

## Use it

```mojo
from std.collections import Span

from ziprs import Archive, Compression_Deflated, ZipWriter


def main() raises:
    var writer = ZipWriter()
    var payload = String("hello from Mojo")
    writer.add_file("hello.txt", payload.as_bytes(), Compression_Deflated)
    var archive_bytes = writer.finish()

    var storage = archive_bytes.to_list()
    var archive = Archive(Span(storage))
    var index = archive.index_for_name("hello.txt").value()
    var contents = archive.read_entry(index).to_list()
    print(String(from_utf8=Span(contents)))
```

## Examples

The [`examples`](examples) directory contains standalone reading and writing programs:

```sh
pixi run mojo run examples/write.mojo ./example.zip
pixi run mojo run examples/read.mojo ./example.zip
```

## API scope

`Archive` provides entry lookup, metadata, archive comments, whole-entry reads, and exact-size
`read_into`. Check `Entry.enclosed_name()` before using an entry name as a filesystem path.

`ZipWriter` creates files and directory entries, sets archive comments, and finishes once. Stored
and Deflate compression are available.

The initial API intentionally excludes filesystem extraction, encryption, streaming I/O,
append/copy operations, and additional codecs.

## Develop

```sh
pixi install
pixi run check-generated
pixi run t
pixi publish --target-dir ./artifacts
```

Release history is recorded in [`CHANGELOG.md`](CHANGELOG.md).
