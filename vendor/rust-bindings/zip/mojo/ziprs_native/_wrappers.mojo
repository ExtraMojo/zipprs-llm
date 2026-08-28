# GENERATED FILE — DO NOT EDIT DIRECTLY
# Source crate: zip =8.6.0
# Binding manifest: binding.toml
# Generator: rust-mojo-wrapper-generator 0.1.0 (projection 0.1.0)
# Diplomat: 0.16.1
# Diplomat core: 0.16.1
# Diplomat runtime: 0.16.0
# Mojo compiler: 1.0.0

from std.collections import ImmSpan, MutSpan, Span
from std.ffi import OwnedDLHandle
from std.os import abort
import ziprs_native._ffi as _ffi
import ziprs_native._runtime as _runtime
import ziprs_native._types as _types

struct Archive(Movable):
    var _handle: _ffi.ArchiveOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.ArchiveHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.ArchiveHandle:
        if not self._handle:
            raise Error("Archive was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].Archive_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    @staticmethod
    def open(data: ImmSpan[UInt8, _]) raises -> ArchiveResult:
        var _call = _runtime._functions()[].Archive_open_abi
        var _ffi_call_result = _call(UInt(Int(data.unsafe_ptr())), UInt(len(data)))
        _ = len(data)
        return ArchiveResult(_from_abi=_ffi_call_result)

    def len(self) raises -> UInt:
        var _call = _runtime._functions()[].Archive_len_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def is_empty(self) raises -> Bool:
        var _call = _runtime._functions()[].Archive_is_empty_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def index_for_name(self, name: String) raises -> Optional[UInt]:
        var _call = _runtime._functions()[].Archive_index_for_name_abi
        var _bytes_name = name.as_bytes()
        var _has_call = _runtime._functions()[].Archive_has_name_abi
        var _has = _has_call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_bytes_name.unsafe_ptr())), UInt(len(_bytes_name)))
        if not _has:
            _ = len(_bytes_name)
            return None
        var _value = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_bytes_name.unsafe_ptr())), UInt(len(_bytes_name)))
        _ = len(_bytes_name)
        return _value

    def entry(mut self, index: UInt) raises -> EntryResult:
        var _call = _runtime._functions()[].Archive_entry_abi
        return EntryResult(_from_abi=_call(self._require_handle(), index))

    def read_entry(mut self, index: UInt) raises -> BytesResult:
        var _call = _runtime._functions()[].Archive_read__abi
        return BytesResult(_from_abi=_call(self._require_handle(), index))

    def read_into(mut self, index: UInt, buffer: MutSpan[UInt8, _]) raises -> CountResult:
        var _call = _runtime._functions()[].Archive_read_into_abi
        var _ffi_call_result = _call(self._require_handle(), index, UInt(Int(buffer.unsafe_ptr())), UInt(len(buffer)))
        _ = len(buffer)
        return CountResult(_from_abi=_ffi_call_result)

    def comment(self) raises -> ZipBytes:
        var _call = _runtime._functions()[].Archive_comment_abi
        return ZipBytes(_from_abi=_call(self._require_handle().unsafe_mut_cast[False]()))

struct ArchiveResult(Movable):
    var _handle: _ffi.ArchiveResultOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.ArchiveResultHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.ArchiveResultHandle:
        if not self._handle:
            raise Error("ArchiveResult was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].ArchiveResult_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def is_ok(self) raises -> Bool:
        var _call = _runtime._functions()[].ArchiveResult_is_ok_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def error(self) raises -> String:
        var _call = _runtime._functions()[].ArchiveResult_error_utf8_copy_abi
        var _len_call = _runtime._functions()[].ArchiveResult_error_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in error")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def take(mut self) raises -> Archive:
        var _call = _runtime._functions()[].ArchiveResult_take_abi
        var _result = _call(self._require_handle())
        if not _result:
            raise Error("ArchiveResult has no archive value")
        return Archive(_from_abi=_result.unsafe_value())

struct BytesResult(Movable):
    var _handle: _ffi.BytesResultOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.BytesResultHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.BytesResultHandle:
        if not self._handle:
            raise Error("BytesResult was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].BytesResult_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def is_ok(self) raises -> Bool:
        var _call = _runtime._functions()[].BytesResult_is_ok_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def error(self) raises -> String:
        var _call = _runtime._functions()[].BytesResult_error_utf8_copy_abi
        var _len_call = _runtime._functions()[].BytesResult_error_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in error")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def take(mut self) raises -> ZipBytes:
        var _call = _runtime._functions()[].BytesResult_take_abi
        var _result = _call(self._require_handle())
        if not _result:
            raise Error("BytesResult has no byte value")
        return ZipBytes(_from_abi=_result.unsafe_value())

struct CountResult(Movable):
    var _handle: _ffi.CountResultOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.CountResultHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.CountResultHandle:
        if not self._handle:
            raise Error("CountResult was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].CountResult_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def is_ok(self) raises -> Bool:
        var _call = _runtime._functions()[].CountResult_is_ok_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def value(self) raises -> UInt:
        var _call = _runtime._functions()[].CountResult_value_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def error(self) raises -> String:
        var _call = _runtime._functions()[].CountResult_error_utf8_copy_abi
        var _len_call = _runtime._functions()[].CountResult_error_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in error")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

struct Entry(Movable):
    var _handle: _ffi.EntryOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.EntryHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.EntryHandle:
        if not self._handle:
            raise Error("Entry was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].Entry_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def name(self) raises -> String:
        var _call = _runtime._functions()[].Entry_name_utf8_copy_abi
        var _len_call = _runtime._functions()[].Entry_name_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in name")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def enclosed_name(self) raises -> Optional[String]:
        var _call = _runtime._functions()[].Entry_enclosed_name_utf8_copy_abi
        var _has_call = _runtime._functions()[].Entry_has_enclosed_name_abi
        var _has = _has_call(self._require_handle().unsafe_mut_cast[False]())
        if not _has:
            return None
        var _len_call = _runtime._functions()[].Entry_enclosed_name_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in enclosed_name")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def comment(self) raises -> String:
        var _call = _runtime._functions()[].Entry_comment_utf8_copy_abi
        var _len_call = _runtime._functions()[].Entry_comment_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in comment")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def compressed_size(self) raises -> UInt64:
        var _call = _runtime._functions()[].Entry_compressed_size_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def size(self) raises -> UInt64:
        var _call = _runtime._functions()[].Entry_size_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def crc32(self) raises -> UInt32:
        var _call = _runtime._functions()[].Entry_crc32_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def compression_code(self) raises -> UInt16:
        var _call = _runtime._functions()[].Entry_compression_code_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def compression_name(self) raises -> String:
        var _call = _runtime._functions()[].Entry_compression_name_utf8_copy_abi
        var _len_call = _runtime._functions()[].Entry_compression_name_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in compression_name")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def is_dir(self) raises -> Bool:
        var _call = _runtime._functions()[].Entry_is_dir_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def is_file(self) raises -> Bool:
        var _call = _runtime._functions()[].Entry_is_file_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def is_symlink(self) raises -> Bool:
        var _call = _runtime._functions()[].Entry_is_symlink_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def unix_mode(self) raises -> Optional[UInt32]:
        var _call = _runtime._functions()[].Entry_unix_mode_abi
        var _has_call = _runtime._functions()[].Entry_has_unix_mode_abi
        var _has = _has_call(self._require_handle().unsafe_mut_cast[False]())
        if not _has:
            return None
        var _value = _call(self._require_handle().unsafe_mut_cast[False]())
        return _value

struct EntryResult(Movable):
    var _handle: _ffi.EntryResultOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.EntryResultHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.EntryResultHandle:
        if not self._handle:
            raise Error("EntryResult was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].EntryResult_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def is_ok(self) raises -> Bool:
        var _call = _runtime._functions()[].EntryResult_is_ok_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def error(self) raises -> String:
        var _call = _runtime._functions()[].EntryResult_error_utf8_copy_abi
        var _len_call = _runtime._functions()[].EntryResult_error_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in error")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

    def take(mut self) raises -> Entry:
        var _call = _runtime._functions()[].EntryResult_take_abi
        var _result = _call(self._require_handle())
        if not _result:
            raise Error("EntryResult has no entry value")
        return Entry(_from_abi=_result.unsafe_value())

struct UnitResult(Movable):
    var _handle: _ffi.UnitResultOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.UnitResultHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.UnitResultHandle:
        if not self._handle:
            raise Error("UnitResult was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].UnitResult_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def is_ok(self) raises -> Bool:
        var _call = _runtime._functions()[].UnitResult_is_ok_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def error(self) raises -> String:
        var _call = _runtime._functions()[].UnitResult_error_utf8_copy_abi
        var _len_call = _runtime._functions()[].UnitResult_error_utf8_len_abi
        var _expected_len = _len_call(self._require_handle().unsafe_mut_cast[False]())
        var _out_bytes = List[UInt8](unsafe_uninit_length=Int(_expected_len))
        var _out_span = Span(_out_bytes)
        var _written = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(_out_span.unsafe_ptr())), UInt(len(_out_span)))
        _ = len(_out_bytes)
        if _written != _expected_len:
            raise Error("FFI string copy length mismatch in error")
        var _out_string = String(from_utf8=Span(_out_bytes))
        return _out_string^

struct ZipBytes(Movable):
    var _handle: _ffi.ZipBytesOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.ZipBytesHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.ZipBytesHandle:
        if not self._handle:
            raise Error("ZipBytes was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].ZipBytes_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def len(self) raises -> UInt:
        var _call = _runtime._functions()[].ZipBytes_len_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def fill(self, buffer: MutSpan[UInt8, _]) raises -> UInt:
        var _call = _runtime._functions()[].ZipBytes_fill_abi
        var _ffi_call_result = _call(self._require_handle().unsafe_mut_cast[False](), UInt(Int(buffer.unsafe_ptr())), UInt(len(buffer)))
        _ = len(buffer)
        return _ffi_call_result

struct ZipWriter(Movable):
    var _handle: _ffi.ZipWriterOptionalHandle

    def __init__(out self, *, _from_abi: _ffi.ZipWriterHandle):
        self._handle = _from_abi

    def __init__(out self, *, deinit move: Self):
        self._handle = move._handle^

    def _require_handle(self) raises -> _ffi.ZipWriterHandle:
        if not self._handle:
            raise Error("ZipWriter was moved or destroyed")
        return self._handle.unsafe_value()

    def __deinit__(deinit self):
        if self._handle:
            try:
                var _destroy = _runtime._functions()[].ZipWriter_destroy_abi
                _destroy(self._handle.unsafe_value())
            except:
                abort()

    def __init__(out self) raises:
        var _call = _runtime._functions()[].ZipWriter_new_abi
        self._handle = _call()

    def is_finished(self) raises -> Bool:
        var _call = _runtime._functions()[].ZipWriter_is_finished_abi
        return _call(self._require_handle().unsafe_mut_cast[False]())

    def add_file(mut self, name: String, data: ImmSpan[UInt8, _], compression: _types.Compression) raises -> UnitResult:
        var _call = _runtime._functions()[].ZipWriter_add_file_abi
        var _bytes_name = name.as_bytes()
        _types._validate_Compression(compression)
        var _ffi_call_result = _call(self._require_handle(), UInt(Int(_bytes_name.unsafe_ptr())), UInt(len(_bytes_name)), UInt(Int(data.unsafe_ptr())), UInt(len(data)), compression)
        _ = len(_bytes_name)
        _ = len(data)
        return UnitResult(_from_abi=_ffi_call_result)

    def add_directory(mut self, name: String) raises -> UnitResult:
        var _call = _runtime._functions()[].ZipWriter_add_directory_abi
        var _bytes_name = name.as_bytes()
        var _ffi_call_result = _call(self._require_handle(), UInt(Int(_bytes_name.unsafe_ptr())), UInt(len(_bytes_name)))
        _ = len(_bytes_name)
        return UnitResult(_from_abi=_ffi_call_result)

    def set_comment(mut self, comment: String) raises -> UnitResult:
        var _call = _runtime._functions()[].ZipWriter_set_comment_abi
        var _bytes_comment = comment.as_bytes()
        var _ffi_call_result = _call(self._require_handle(), UInt(Int(_bytes_comment.unsafe_ptr())), UInt(len(_bytes_comment)))
        _ = len(_bytes_comment)
        return UnitResult(_from_abi=_ffi_call_result)

    def finish(mut self) raises -> BytesResult:
        var _call = _runtime._functions()[].ZipWriter_finish_abi
        return BytesResult(_from_abi=_call(self._require_handle()))
