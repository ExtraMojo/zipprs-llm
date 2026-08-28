"""Provides the public in-memory ZIP archive API.

The structs in this module own their Rust-backed resources. Archive input bytes are copied when an
[.Archive] is opened, and [.ZipWriter] produces an owned [.ZipBytes] buffer when finished.

Examples:

```mojo
from std.collections import Span

from ziprs import Archive, Compression_Deflated, ZipWriter

var writer = ZipWriter()
var message = String("hello from Mojo")
writer.add_file("hello.txt", message.as_bytes(), Compression_Deflated)
var encoded = writer.finish()

var archive_data = encoded.to_list()
var archive = Archive(Span(archive_data))
var index = archive.index_for_name("hello.txt").value()
var decoded = archive.read_entry(index).to_list()
print(String(from_utf8=Span(decoded)))
```
"""

from std.collections import ImmSpan, MutSpan, Span

import ziprs_native as _native

comptime Compression = _native.Compression
"""The compression method accepted by [.ZipWriter.add_file]."""

comptime Compression_Stored: Compression = _native.Compression_Stored
"""Stores file data without compression."""

comptime Compression_Deflated: Compression = _native.Compression_Deflated
"""Compresses file data with the Deflate algorithm."""

comptime Entry = _native.Entry
"""An immutable metadata snapshot for one ZIP entry.

Obtain an entry with [.Archive.entry]. The snapshot provides `name()`, `enclosed_name()`,
`comment()`, `compressed_size()`, `size()`, `crc32()`, `compression_code()`,
`compression_name()`, `is_dir()`, `is_file()`, `is_symlink()`, and `unix_mode()`.

Always check `enclosed_name()` before using an entry name as a filesystem path. It returns `None`
when the name contains a path traversal, an absolute path, or another unsafe component.

Examples:

```mojo
var entry = archive.entry(index)
print(entry.name(), entry.size(), entry.compression_name())
if not entry.enclosed_name():
    print("unsafe extraction path")
```
"""


struct ZipBytes(Movable):
    """Owns a byte buffer returned by the Rust ZIP implementation.

    `ZipBytes` values contain either a completed archive from [.ZipWriter.finish], entry contents
    from [.Archive.read_entry], or an archive comment from [.Archive.comment]. Copy the bytes into
    Mojo-owned storage with [.ZipBytes.to_list] or into an existing destination with
    [.ZipBytes.fill].
    """

    var _inner: _native.ZipBytes

    @doc_hidden
    def __init__(out self, *, var _from_native: _native.ZipBytes):
        self._inner = _from_native^

    @doc_hidden
    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    def len(self) raises -> UInt:
        """Returns the number of bytes in the buffer.

        Returns:
            The buffer length in bytes.

        Raises:
            An error if the underlying native value is no longer valid.
        """
        return self._inner.len()

    def fill(self, buffer: MutSpan[UInt8, _]) raises -> UInt:
        """Copies bytes into an existing mutable span.

        At most `len(buffer)` bytes are copied. Use a destination of [.ZipBytes.len] bytes to copy
        the entire value.

        Args:
            buffer: The destination span to fill.

        Returns:
            The number of bytes copied.

        Raises:
            An error if the underlying native value is no longer valid.

        Examples:

        ```mojo
        var destination = List[UInt8](unsafe_uninit_length=Int(contents.len()))
        var copied = contents.fill(Span(destination))
        ```
        """
        return self._inner.fill(buffer)

    def to_list(self) raises -> List[UInt8]:
        """Copies the complete buffer into a new Mojo `List[UInt8]`.

        Returns:
            A newly allocated list containing every byte.

        Raises:
            An error if the native value is invalid or the native copy reports an unexpected
            length.

        Examples:

        ```mojo
        var bytes = contents.to_list()
        var text = String(from_utf8=Span(bytes))
        ```
        """
        var output = List[UInt8](unsafe_uninit_length=Int(self.len()))
        var written = self.fill(Span(output))
        if written != UInt(len(output)):
            raise Error("zip byte copy length mismatch")
        return output^


struct Archive(Movable):
    """Reads entry metadata and contents from an in-memory ZIP archive.

    Opening an archive copies the input span into native-owned storage, so the caller may release
    or reuse the original bytes afterward. Entry indexes are zero-based and remain valid for the
    lifetime of the archive.

    Examples:

    ```mojo
    var archive = Archive(Span(archive_data))
    print("entries:", archive.len())
    for raw_index in range(Int(archive.len())):
        var entry = archive.entry(UInt(raw_index))
        print(entry.name(), entry.size())
    ```
    """

    var _inner: _native.Archive

    def __init__(out self, data: ImmSpan[UInt8, _]) raises:
        """Opens a ZIP archive from an in-memory byte span.

        Args:
            data: The complete encoded ZIP archive. The bytes are copied.

        Raises:
            An error if the data is not a valid or supported ZIP archive.
        """
        var result = _native.Archive.open(data)
        if not result.is_ok():
            raise Error(result.error())
        self._inner = result.take()

    @doc_hidden
    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    @staticmethod
    def open(data: ImmSpan[UInt8, _]) raises -> Self:
        """Opens a ZIP archive from an in-memory byte span.

        This named constructor is equivalent to `Archive(data)`.

        Args:
            data: The complete encoded ZIP archive. The bytes are copied.

        Returns:
            The opened archive.

        Raises:
            An error if the data is not a valid or supported ZIP archive.
        """
        return Self(data)

    def len(self) raises -> UInt:
        """Returns the number of entries in the archive.

        Returns:
            The number of file and directory entries.

        Raises:
            An error if the underlying native archive is no longer valid.
        """
        return self._inner.len()

    def is_empty(self) raises -> Bool:
        """Checks whether the archive contains no entries.

        Returns:
            `True` when [.Archive.len] is zero, otherwise `False`.

        Raises:
            An error if the underlying native archive is no longer valid.
        """
        return self._inner.is_empty()

    def index_for_name(self, name: String) raises -> Optional[UInt]:
        """Looks up an entry index by its exact stored name.

        Names are case-sensitive and use the separators stored in the archive.

        Args:
            name: The exact entry name to find.

        Returns:
            The zero-based index when present, otherwise `None`.

        Raises:
            An error if the underlying native archive is no longer valid.

        Examples:

        ```mojo
        var maybe_index = archive.index_for_name("docs/readme.txt")
        if maybe_index:
            print("entry index:", maybe_index.value())
        ```
        """
        return self._inner.index_for_name(name)

    def entry(mut self, index: UInt) raises -> Entry:
        """Returns an immutable metadata snapshot for one entry.

        Args:
            index: A zero-based index smaller than [.Archive.len].

        Returns:
            Metadata including the name, sizes, CRC-32, compression method, file kind, and optional
            Unix mode.

        Raises:
            An error if the index is out of range or the native archive is invalid.
        """
        var result = self._inner.entry(index)
        if not result.is_ok():
            raise Error(result.error())
        return result.take()

    def read_entry(mut self, index: UInt) raises -> ZipBytes:
        """Decompresses an entry into a newly allocated byte buffer.

        Directory entries normally produce an empty buffer. For caller-provided storage, use
        [.Archive.read_into] instead.

        Args:
            index: A zero-based index smaller than [.Archive.len].

        Returns:
            The complete uncompressed entry contents.

        Raises:
            An error if the index is out of range, the entry cannot be decompressed, memory cannot
            be reserved, or the native archive is invalid.

        Examples:

        ```mojo
        var index = archive.index_for_name("hello.txt").value()
        var bytes = archive.read_entry(index).to_list()
        print(String(from_utf8=Span(bytes)))
        ```
        """
        var result = self._inner.read_entry(index)
        if not result.is_ok():
            raise Error(result.error())
        return ZipBytes(_from_native=result.take())

    def read_into(mut self, index: UInt, buffer: MutSpan[UInt8, _]) raises -> UInt:
        """Decompresses an entry into an exact-size caller-provided buffer.

        The destination length must equal `Entry.size()` for the selected entry. No partial reads
        are performed.

        Args:
            index: A zero-based index smaller than [.Archive.len].
            buffer: A mutable destination whose length exactly matches the uncompressed entry size.

        Returns:
            The number of bytes written, equal to `len(buffer)` on success.

        Raises:
            An error if the index is invalid, the destination has the wrong length, decompression
            fails, or the native archive is invalid.

        Examples:

        ```mojo
        var entry = archive.entry(index)
        var destination = List[UInt8](unsafe_uninit_length=Int(entry.size()))
        var written = archive.read_into(index, Span(destination))
        ```
        """
        var result = self._inner.read_into(index, buffer)
        if not result.is_ok():
            raise Error(result.error())
        return result.value()

    def comment(self) raises -> ZipBytes:
        """Returns the archive-level comment as raw bytes.

        ZIP comments are not required to be UTF-8. Convert the returned bytes to `String` only when
        the archive's encoding is known.

        Returns:
            The archive comment, or an empty buffer when no comment is present.

        Raises:
            An error if the underlying native archive is no longer valid.
        """
        return ZipBytes(_from_native=self._inner.comment())


struct ZipWriter(Movable):
    """Builds a ZIP archive entirely in memory.

    Add files and directories, optionally set an archive comment, then call [.ZipWriter.finish]
    exactly once.
    Stored and Deflate compression are supported. A finished writer rejects further mutations.

    Examples:

    ```mojo
    var writer = ZipWriter()
    writer.add_directory("docs/")
    writer.add_file(
        "docs/hello.txt",
        "hello from Mojo".as_bytes(),
        Compression_Deflated,
    )
    writer.set_comment("created by ziprs")
    var archive_bytes = writer.finish()
    ```
    """

    var _inner: _native.ZipWriter

    def __init__(out self) raises:
        """Creates an empty in-memory ZIP writer.

        Raises:
            An error if the native writer cannot be initialized.
        """
        self._inner = _native.ZipWriter()

    @doc_hidden
    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    def is_finished(self) raises -> Bool:
        """Checks whether [.ZipWriter.finish] has already consumed the writer output.

        Returns:
            `True` after a successful call to [.ZipWriter.finish], otherwise `False`.

        Raises:
            An error if the underlying native writer is no longer valid.
        """
        return self._inner.is_finished()

    def add_file(
        mut self,
        name: String,
        data: ImmSpan[UInt8, _],
        compression: Compression = Compression_Deflated,
    ) raises:
        """Adds one file entry and copies its data into the archive.

        Args:
            name: The path stored in the ZIP directory, conventionally using `/` separators.
            data: The uncompressed file contents.
            compression: [.Compression_Deflated] by default, or [.Compression_Stored].

        Raises:
            An error if the writer is finished, the compression value is unsupported, or the entry
            cannot be written.

        Examples:

        ```mojo
        var payload = String("important data")
        writer.add_file("data.txt", payload.as_bytes(), Compression_Stored)
        ```
        """
        var result = self._inner.add_file(name, data, compression)
        if not result.is_ok():
            raise Error(result.error())

    def add_directory(mut self, name: String) raises:
        """Adds an explicit directory entry.

        Args:
            name: The directory path to store. A trailing `/` is recommended.

        Raises:
            An error if the writer is finished or the directory entry cannot be written.

        Examples:

        ```mojo
        writer.add_directory("images/")
        ```
        """
        var result = self._inner.add_directory(name)
        if not result.is_ok():
            raise Error(result.error())

    def set_comment(mut self, comment: String) raises:
        """Sets the archive-level UTF-8 comment.

        Calling this method again replaces the previous comment.

        Args:
            comment: The comment text to store.

        Raises:
            An error if the writer is finished or the comment cannot be stored.
        """
        var result = self._inner.set_comment(comment)
        if not result.is_ok():
            raise Error(result.error())

    def finish(mut self) raises -> ZipBytes:
        """Finalizes the central directory and returns the encoded archive.

        This method succeeds only once. Use [.ZipWriter.is_finished] to query the writer state.

        Returns:
            The complete encoded ZIP archive.

        Raises:
            An error if the writer was already finished or finalization fails.

        Examples:

        ```mojo
        var archive_bytes = writer.finish()
        var storage = archive_bytes.to_list()
        with open("example.zip", "w") as output:
            output.write_bytes(Span(storage))
        ```
        """
        var result = self._inner.finish()
        if not result.is_ok():
            raise Error(result.error())
        return ZipBytes(_from_native=result.take())
