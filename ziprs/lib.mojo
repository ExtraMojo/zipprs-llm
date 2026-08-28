from std.collections import ImmSpan, MutSpan, Span

import ziprs_native as _native

comptime Compression = _native.Compression
comptime Compression_Stored: Compression = _native.Compression_Stored
comptime Compression_Deflated: Compression = _native.Compression_Deflated
comptime Entry = _native.Entry


struct ZipBytes(Movable):
    var _inner: _native.ZipBytes

    def __init__(out self, *, var _from_native: _native.ZipBytes):
        self._inner = _from_native^

    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    def len(self) raises -> UInt:
        return self._inner.len()

    def fill(self, buffer: MutSpan[UInt8, _]) raises -> UInt:
        return self._inner.fill(buffer)

    def to_list(self) raises -> List[UInt8]:
        var output = List[UInt8](unsafe_uninit_length=Int(self.len()))
        var written = self.fill(Span(output))
        if written != UInt(len(output)):
            raise Error("zip byte copy length mismatch")
        return output^


struct Archive(Movable):
    var _inner: _native.Archive

    def __init__(out self, data: ImmSpan[UInt8, _]) raises:
        var result = _native.Archive.open(data)
        if not result.is_ok():
            raise Error(result.error())
        self._inner = result.take()

    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    @staticmethod
    def open(data: ImmSpan[UInt8, _]) raises -> Self:
        return Self(data)

    def len(self) raises -> UInt:
        return self._inner.len()

    def is_empty(self) raises -> Bool:
        return self._inner.is_empty()

    def index_for_name(self, name: String) raises -> Optional[UInt]:
        return self._inner.index_for_name(name)

    def entry(mut self, index: UInt) raises -> Entry:
        var result = self._inner.entry(index)
        if not result.is_ok():
            raise Error(result.error())
        return result.take()

    def read_entry(mut self, index: UInt) raises -> ZipBytes:
        var result = self._inner.read_entry(index)
        if not result.is_ok():
            raise Error(result.error())
        return ZipBytes(_from_native=result.take())

    def read_into(mut self, index: UInt, buffer: MutSpan[UInt8, _]) raises -> UInt:
        var result = self._inner.read_into(index, buffer)
        if not result.is_ok():
            raise Error(result.error())
        return result.value()

    def comment(self) raises -> ZipBytes:
        return ZipBytes(_from_native=self._inner.comment())


struct ZipWriter(Movable):
    var _inner: _native.ZipWriter

    def __init__(out self) raises:
        self._inner = _native.ZipWriter()

    def __init__(out self, *, deinit move: Self):
        self._inner = move._inner^

    def is_finished(self) raises -> Bool:
        return self._inner.is_finished()

    def add_file(
        mut self,
        name: String,
        data: ImmSpan[UInt8, _],
        compression: Compression = Compression_Deflated,
    ) raises:
        var result = self._inner.add_file(name, data, compression)
        if not result.is_ok():
            raise Error(result.error())

    def add_directory(mut self, name: String) raises:
        var result = self._inner.add_directory(name)
        if not result.is_ok():
            raise Error(result.error())

    def set_comment(mut self, comment: String) raises:
        var result = self._inner.set_comment(comment)
        if not result.is_ok():
            raise Error(result.error())

    def finish(mut self) raises -> ZipBytes:
        var result = self._inner.finish()
        if not result.is_ok():
            raise Error(result.error())
        return ZipBytes(_from_native=result.take())
