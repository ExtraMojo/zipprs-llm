# GENERATED FILE — DO NOT EDIT DIRECTLY
# Source crate: zip =8.6.0
# Binding manifest: binding.toml
# Generator: rust-mojo-wrapper-generator 0.1.0 (projection 0.1.0)
# Diplomat: 0.16.1
# Diplomat core: 0.16.1
# Diplomat runtime: 0.16.0
# Mojo compiler: 1.0.0

from std.ffi import OwnedDLHandle, _Global, external_call
from std.os import getenv
from std.os.path import dirname, join, realpath
from std.sys import CompilationTarget, argv

import ziprs_native._ffi as _ffi


def _library_filename() -> String:
    comptime if CompilationTarget.is_linux():
        return "libziprs_zip_ffi.so"
    elif CompilationTarget.is_macos():
        return "libziprs_zip_ffi.dylib"
    else:
        return ""


def _macos_executable_path() raises -> String:
    comptime if CompilationTarget.is_macos():
        # _NSGetExecutablePath reports the required NUL-terminated buffer size
        # when the supplied buffer is too small. realpath then resolves any
        # symlink or relative components returned by dyld.
        var size = UInt32(1)
        var buffer = String(unsafe_uninit_length=1)
        var status = external_call["_NSGetExecutablePath", Int32](
            buffer.unsafe_as_bytes_mut().unsafe_ptr(), Pointer(to=size)
        )
        if status == 0:
            return realpath(
                String(unsafe_from_utf8_ptr=buffer.as_bytes().unsafe_ptr())
            )
        if size <= 1:
            raise Error("_NSGetExecutablePath did not report a buffer size")
        buffer = String(unsafe_uninit_length=Int(size))
        status = external_call["_NSGetExecutablePath", Int32](
            buffer.unsafe_as_bytes_mut().unsafe_ptr(), Pointer(to=size)
        )
        if status != 0:
            raise Error("_NSGetExecutablePath failed")
        return realpath(
            String(unsafe_from_utf8_ptr=buffer.as_bytes().unsafe_ptr())
        )
    else:
        raise Error("_NSGetExecutablePath is available only on macOS")


def _argv_executable_path() raises -> String:
    var arguments = argv()
    if len(arguments) == 0 or arguments[0] == "":
        raise Error("process executable path is unavailable")
    var invoked = String(arguments[0])
    if invoked.rfind("/") >= 0:
        return realpath(invoked)
    var search_path = getenv("PATH")
    for component in search_path.split(":"):
        var directory = String(component)
        if directory == "":
            directory = "."
        try:
            return realpath(join(directory, invoked))
        except:
            pass
    raise Error("cannot resolve executable from argv[0] and PATH")


def _executable_path() raises -> String:
    comptime if CompilationTarget.is_linux():
        try:
            return realpath("/proc/self/exe")
        except:
            pass
    elif CompilationTarget.is_macos():
        try:
            return _macos_executable_path()
        except:
            pass
    return _argv_executable_path()


def _open_library() raises -> OwnedDLHandle:
    comptime if not (CompilationTarget.is_linux() or CompilationTarget.is_macos()):
        raise Error("ziprs_native supports Linux and macOS in binding schema v1")
    var filename = _library_filename()
    var override = getenv("RUST_MOJO_ZIP_LIBRARY")
    if override != "":
        return OwnedDLHandle(override)
    try:
        var executable_relative = join(
            dirname(_executable_path()), "..", "lib", filename
        )
        return OwnedDLHandle(executable_relative)
    except:
        pass
    var prefix = getenv("CONDA_PREFIX")
    if prefix != "":
        try:
            return OwnedDLHandle(join(prefix, "lib", filename))
        except:
            pass
    return OwnedDLHandle(filename)


def _null_fn[T: TrivialRegisterPassable]() -> T:
    var zero: UInt = 0
    return Pointer(to=zero).unsafe_bitcast[T]()[]


# The shared library is opened once per process and kept in a named
# compiler-runtime global, following the pattern std.python uses for the
# CPython interpreter handle. Every C function pointer is resolved exactly
# once when the global initializes, so a wrapper call costs one global
# lookup plus a field read (no per-call dlsym or allocation).
struct _RuntimeState(Movable):
    var handle: Optional[OwnedDLHandle]
    var load_error: String
    var ArchiveResult_destroy_abi: _ffi.ArchiveResult_destroy_abi
    var ArchiveResult_error_utf8_copy_abi: _ffi.ArchiveResult_error_utf8_copy_abi
    var ArchiveResult_error_utf8_len_abi: _ffi.ArchiveResult_error_utf8_len_abi
    var ArchiveResult_is_ok_abi: _ffi.ArchiveResult_is_ok_abi
    var ArchiveResult_take_abi: _ffi.ArchiveResult_take_abi
    var Archive_comment_abi: _ffi.Archive_comment_abi
    var Archive_destroy_abi: _ffi.Archive_destroy_abi
    var Archive_entry_abi: _ffi.Archive_entry_abi
    var Archive_has_name_abi: _ffi.Archive_has_name_abi
    var Archive_index_for_name_abi: _ffi.Archive_index_for_name_abi
    var Archive_is_empty_abi: _ffi.Archive_is_empty_abi
    var Archive_len_abi: _ffi.Archive_len_abi
    var Archive_open_abi: _ffi.Archive_open_abi
    var Archive_read__abi: _ffi.Archive_read__abi
    var Archive_read_into_abi: _ffi.Archive_read_into_abi
    var BytesResult_destroy_abi: _ffi.BytesResult_destroy_abi
    var BytesResult_error_utf8_copy_abi: _ffi.BytesResult_error_utf8_copy_abi
    var BytesResult_error_utf8_len_abi: _ffi.BytesResult_error_utf8_len_abi
    var BytesResult_is_ok_abi: _ffi.BytesResult_is_ok_abi
    var BytesResult_take_abi: _ffi.BytesResult_take_abi
    var CountResult_destroy_abi: _ffi.CountResult_destroy_abi
    var CountResult_error_utf8_copy_abi: _ffi.CountResult_error_utf8_copy_abi
    var CountResult_error_utf8_len_abi: _ffi.CountResult_error_utf8_len_abi
    var CountResult_is_ok_abi: _ffi.CountResult_is_ok_abi
    var CountResult_value_abi: _ffi.CountResult_value_abi
    var EntryResult_destroy_abi: _ffi.EntryResult_destroy_abi
    var EntryResult_error_utf8_copy_abi: _ffi.EntryResult_error_utf8_copy_abi
    var EntryResult_error_utf8_len_abi: _ffi.EntryResult_error_utf8_len_abi
    var EntryResult_is_ok_abi: _ffi.EntryResult_is_ok_abi
    var EntryResult_take_abi: _ffi.EntryResult_take_abi
    var Entry_comment_utf8_copy_abi: _ffi.Entry_comment_utf8_copy_abi
    var Entry_comment_utf8_len_abi: _ffi.Entry_comment_utf8_len_abi
    var Entry_compressed_size_abi: _ffi.Entry_compressed_size_abi
    var Entry_compression_code_abi: _ffi.Entry_compression_code_abi
    var Entry_compression_name_utf8_copy_abi: _ffi.Entry_compression_name_utf8_copy_abi
    var Entry_compression_name_utf8_len_abi: _ffi.Entry_compression_name_utf8_len_abi
    var Entry_crc32_abi: _ffi.Entry_crc32_abi
    var Entry_destroy_abi: _ffi.Entry_destroy_abi
    var Entry_enclosed_name_utf8_copy_abi: _ffi.Entry_enclosed_name_utf8_copy_abi
    var Entry_enclosed_name_utf8_len_abi: _ffi.Entry_enclosed_name_utf8_len_abi
    var Entry_has_enclosed_name_abi: _ffi.Entry_has_enclosed_name_abi
    var Entry_has_unix_mode_abi: _ffi.Entry_has_unix_mode_abi
    var Entry_is_dir_abi: _ffi.Entry_is_dir_abi
    var Entry_is_file_abi: _ffi.Entry_is_file_abi
    var Entry_is_symlink_abi: _ffi.Entry_is_symlink_abi
    var Entry_name_utf8_copy_abi: _ffi.Entry_name_utf8_copy_abi
    var Entry_name_utf8_len_abi: _ffi.Entry_name_utf8_len_abi
    var Entry_size_abi: _ffi.Entry_size_abi
    var Entry_unix_mode_abi: _ffi.Entry_unix_mode_abi
    var UnitResult_destroy_abi: _ffi.UnitResult_destroy_abi
    var UnitResult_error_utf8_copy_abi: _ffi.UnitResult_error_utf8_copy_abi
    var UnitResult_error_utf8_len_abi: _ffi.UnitResult_error_utf8_len_abi
    var UnitResult_is_ok_abi: _ffi.UnitResult_is_ok_abi
    var ZipBytes_destroy_abi: _ffi.ZipBytes_destroy_abi
    var ZipBytes_fill_abi: _ffi.ZipBytes_fill_abi
    var ZipBytes_len_abi: _ffi.ZipBytes_len_abi
    var ZipWriter_add_directory_abi: _ffi.ZipWriter_add_directory_abi
    var ZipWriter_add_file_abi: _ffi.ZipWriter_add_file_abi
    var ZipWriter_destroy_abi: _ffi.ZipWriter_destroy_abi
    var ZipWriter_finish_abi: _ffi.ZipWriter_finish_abi
    var ZipWriter_is_finished_abi: _ffi.ZipWriter_is_finished_abi
    var ZipWriter_new_abi: _ffi.ZipWriter_new_abi
    var ZipWriter_set_comment_abi: _ffi.ZipWriter_set_comment_abi

    def __init__(out self):
        self.load_error = String("")
        var handle: Optional[OwnedDLHandle] = None
        try:
            handle = _open_library()
        except open_error:
            self.load_error = String(open_error)
        self.ArchiveResult_destroy_abi = _null_fn[_ffi.ArchiveResult_destroy_abi]()
        self.ArchiveResult_error_utf8_copy_abi = _null_fn[_ffi.ArchiveResult_error_utf8_copy_abi]()
        self.ArchiveResult_error_utf8_len_abi = _null_fn[_ffi.ArchiveResult_error_utf8_len_abi]()
        self.ArchiveResult_is_ok_abi = _null_fn[_ffi.ArchiveResult_is_ok_abi]()
        self.ArchiveResult_take_abi = _null_fn[_ffi.ArchiveResult_take_abi]()
        self.Archive_comment_abi = _null_fn[_ffi.Archive_comment_abi]()
        self.Archive_destroy_abi = _null_fn[_ffi.Archive_destroy_abi]()
        self.Archive_entry_abi = _null_fn[_ffi.Archive_entry_abi]()
        self.Archive_has_name_abi = _null_fn[_ffi.Archive_has_name_abi]()
        self.Archive_index_for_name_abi = _null_fn[_ffi.Archive_index_for_name_abi]()
        self.Archive_is_empty_abi = _null_fn[_ffi.Archive_is_empty_abi]()
        self.Archive_len_abi = _null_fn[_ffi.Archive_len_abi]()
        self.Archive_open_abi = _null_fn[_ffi.Archive_open_abi]()
        self.Archive_read__abi = _null_fn[_ffi.Archive_read__abi]()
        self.Archive_read_into_abi = _null_fn[_ffi.Archive_read_into_abi]()
        self.BytesResult_destroy_abi = _null_fn[_ffi.BytesResult_destroy_abi]()
        self.BytesResult_error_utf8_copy_abi = _null_fn[_ffi.BytesResult_error_utf8_copy_abi]()
        self.BytesResult_error_utf8_len_abi = _null_fn[_ffi.BytesResult_error_utf8_len_abi]()
        self.BytesResult_is_ok_abi = _null_fn[_ffi.BytesResult_is_ok_abi]()
        self.BytesResult_take_abi = _null_fn[_ffi.BytesResult_take_abi]()
        self.CountResult_destroy_abi = _null_fn[_ffi.CountResult_destroy_abi]()
        self.CountResult_error_utf8_copy_abi = _null_fn[_ffi.CountResult_error_utf8_copy_abi]()
        self.CountResult_error_utf8_len_abi = _null_fn[_ffi.CountResult_error_utf8_len_abi]()
        self.CountResult_is_ok_abi = _null_fn[_ffi.CountResult_is_ok_abi]()
        self.CountResult_value_abi = _null_fn[_ffi.CountResult_value_abi]()
        self.EntryResult_destroy_abi = _null_fn[_ffi.EntryResult_destroy_abi]()
        self.EntryResult_error_utf8_copy_abi = _null_fn[_ffi.EntryResult_error_utf8_copy_abi]()
        self.EntryResult_error_utf8_len_abi = _null_fn[_ffi.EntryResult_error_utf8_len_abi]()
        self.EntryResult_is_ok_abi = _null_fn[_ffi.EntryResult_is_ok_abi]()
        self.EntryResult_take_abi = _null_fn[_ffi.EntryResult_take_abi]()
        self.Entry_comment_utf8_copy_abi = _null_fn[_ffi.Entry_comment_utf8_copy_abi]()
        self.Entry_comment_utf8_len_abi = _null_fn[_ffi.Entry_comment_utf8_len_abi]()
        self.Entry_compressed_size_abi = _null_fn[_ffi.Entry_compressed_size_abi]()
        self.Entry_compression_code_abi = _null_fn[_ffi.Entry_compression_code_abi]()
        self.Entry_compression_name_utf8_copy_abi = _null_fn[_ffi.Entry_compression_name_utf8_copy_abi]()
        self.Entry_compression_name_utf8_len_abi = _null_fn[_ffi.Entry_compression_name_utf8_len_abi]()
        self.Entry_crc32_abi = _null_fn[_ffi.Entry_crc32_abi]()
        self.Entry_destroy_abi = _null_fn[_ffi.Entry_destroy_abi]()
        self.Entry_enclosed_name_utf8_copy_abi = _null_fn[_ffi.Entry_enclosed_name_utf8_copy_abi]()
        self.Entry_enclosed_name_utf8_len_abi = _null_fn[_ffi.Entry_enclosed_name_utf8_len_abi]()
        self.Entry_has_enclosed_name_abi = _null_fn[_ffi.Entry_has_enclosed_name_abi]()
        self.Entry_has_unix_mode_abi = _null_fn[_ffi.Entry_has_unix_mode_abi]()
        self.Entry_is_dir_abi = _null_fn[_ffi.Entry_is_dir_abi]()
        self.Entry_is_file_abi = _null_fn[_ffi.Entry_is_file_abi]()
        self.Entry_is_symlink_abi = _null_fn[_ffi.Entry_is_symlink_abi]()
        self.Entry_name_utf8_copy_abi = _null_fn[_ffi.Entry_name_utf8_copy_abi]()
        self.Entry_name_utf8_len_abi = _null_fn[_ffi.Entry_name_utf8_len_abi]()
        self.Entry_size_abi = _null_fn[_ffi.Entry_size_abi]()
        self.Entry_unix_mode_abi = _null_fn[_ffi.Entry_unix_mode_abi]()
        self.UnitResult_destroy_abi = _null_fn[_ffi.UnitResult_destroy_abi]()
        self.UnitResult_error_utf8_copy_abi = _null_fn[_ffi.UnitResult_error_utf8_copy_abi]()
        self.UnitResult_error_utf8_len_abi = _null_fn[_ffi.UnitResult_error_utf8_len_abi]()
        self.UnitResult_is_ok_abi = _null_fn[_ffi.UnitResult_is_ok_abi]()
        self.ZipBytes_destroy_abi = _null_fn[_ffi.ZipBytes_destroy_abi]()
        self.ZipBytes_fill_abi = _null_fn[_ffi.ZipBytes_fill_abi]()
        self.ZipBytes_len_abi = _null_fn[_ffi.ZipBytes_len_abi]()
        self.ZipWriter_add_directory_abi = _null_fn[_ffi.ZipWriter_add_directory_abi]()
        self.ZipWriter_add_file_abi = _null_fn[_ffi.ZipWriter_add_file_abi]()
        self.ZipWriter_destroy_abi = _null_fn[_ffi.ZipWriter_destroy_abi]()
        self.ZipWriter_finish_abi = _null_fn[_ffi.ZipWriter_finish_abi]()
        self.ZipWriter_is_finished_abi = _null_fn[_ffi.ZipWriter_is_finished_abi]()
        self.ZipWriter_new_abi = _null_fn[_ffi.ZipWriter_new_abi]()
        self.ZipWriter_set_comment_abi = _null_fn[_ffi.ZipWriter_set_comment_abi]()
        if handle:
            ref lib = handle.value()
            self.ArchiveResult_destroy_abi = lib._get_function["rust_mojo__zip__ArchiveResult_destroy", _ffi.ArchiveResult_destroy_abi]()
            self.ArchiveResult_error_utf8_copy_abi = lib._get_function["rust_mojo__zip__ArchiveResult_error_utf8_copy", _ffi.ArchiveResult_error_utf8_copy_abi]()
            self.ArchiveResult_error_utf8_len_abi = lib._get_function["rust_mojo__zip__ArchiveResult_error_utf8_len", _ffi.ArchiveResult_error_utf8_len_abi]()
            self.ArchiveResult_is_ok_abi = lib._get_function["rust_mojo__zip__ArchiveResult_is_ok", _ffi.ArchiveResult_is_ok_abi]()
            self.ArchiveResult_take_abi = lib._get_function["rust_mojo__zip__ArchiveResult_take", _ffi.ArchiveResult_take_abi]()
            self.Archive_comment_abi = lib._get_function["rust_mojo__zip__Archive_comment", _ffi.Archive_comment_abi]()
            self.Archive_destroy_abi = lib._get_function["rust_mojo__zip__Archive_destroy", _ffi.Archive_destroy_abi]()
            self.Archive_entry_abi = lib._get_function["rust_mojo__zip__Archive_entry", _ffi.Archive_entry_abi]()
            self.Archive_has_name_abi = lib._get_function["rust_mojo__zip__Archive_has_name", _ffi.Archive_has_name_abi]()
            self.Archive_index_for_name_abi = lib._get_function["rust_mojo__zip__Archive_index_for_name", _ffi.Archive_index_for_name_abi]()
            self.Archive_is_empty_abi = lib._get_function["rust_mojo__zip__Archive_is_empty", _ffi.Archive_is_empty_abi]()
            self.Archive_len_abi = lib._get_function["rust_mojo__zip__Archive_len", _ffi.Archive_len_abi]()
            self.Archive_open_abi = lib._get_function["rust_mojo__zip__Archive_open", _ffi.Archive_open_abi]()
            self.Archive_read__abi = lib._get_function["rust_mojo__zip__Archive_read", _ffi.Archive_read__abi]()
            self.Archive_read_into_abi = lib._get_function["rust_mojo__zip__Archive_read_into", _ffi.Archive_read_into_abi]()
            self.BytesResult_destroy_abi = lib._get_function["rust_mojo__zip__BytesResult_destroy", _ffi.BytesResult_destroy_abi]()
            self.BytesResult_error_utf8_copy_abi = lib._get_function["rust_mojo__zip__BytesResult_error_utf8_copy", _ffi.BytesResult_error_utf8_copy_abi]()
            self.BytesResult_error_utf8_len_abi = lib._get_function["rust_mojo__zip__BytesResult_error_utf8_len", _ffi.BytesResult_error_utf8_len_abi]()
            self.BytesResult_is_ok_abi = lib._get_function["rust_mojo__zip__BytesResult_is_ok", _ffi.BytesResult_is_ok_abi]()
            self.BytesResult_take_abi = lib._get_function["rust_mojo__zip__BytesResult_take", _ffi.BytesResult_take_abi]()
            self.CountResult_destroy_abi = lib._get_function["rust_mojo__zip__CountResult_destroy", _ffi.CountResult_destroy_abi]()
            self.CountResult_error_utf8_copy_abi = lib._get_function["rust_mojo__zip__CountResult_error_utf8_copy", _ffi.CountResult_error_utf8_copy_abi]()
            self.CountResult_error_utf8_len_abi = lib._get_function["rust_mojo__zip__CountResult_error_utf8_len", _ffi.CountResult_error_utf8_len_abi]()
            self.CountResult_is_ok_abi = lib._get_function["rust_mojo__zip__CountResult_is_ok", _ffi.CountResult_is_ok_abi]()
            self.CountResult_value_abi = lib._get_function["rust_mojo__zip__CountResult_value", _ffi.CountResult_value_abi]()
            self.EntryResult_destroy_abi = lib._get_function["rust_mojo__zip__EntryResult_destroy", _ffi.EntryResult_destroy_abi]()
            self.EntryResult_error_utf8_copy_abi = lib._get_function["rust_mojo__zip__EntryResult_error_utf8_copy", _ffi.EntryResult_error_utf8_copy_abi]()
            self.EntryResult_error_utf8_len_abi = lib._get_function["rust_mojo__zip__EntryResult_error_utf8_len", _ffi.EntryResult_error_utf8_len_abi]()
            self.EntryResult_is_ok_abi = lib._get_function["rust_mojo__zip__EntryResult_is_ok", _ffi.EntryResult_is_ok_abi]()
            self.EntryResult_take_abi = lib._get_function["rust_mojo__zip__EntryResult_take", _ffi.EntryResult_take_abi]()
            self.Entry_comment_utf8_copy_abi = lib._get_function["rust_mojo__zip__Entry_comment_utf8_copy", _ffi.Entry_comment_utf8_copy_abi]()
            self.Entry_comment_utf8_len_abi = lib._get_function["rust_mojo__zip__Entry_comment_utf8_len", _ffi.Entry_comment_utf8_len_abi]()
            self.Entry_compressed_size_abi = lib._get_function["rust_mojo__zip__Entry_compressed_size", _ffi.Entry_compressed_size_abi]()
            self.Entry_compression_code_abi = lib._get_function["rust_mojo__zip__Entry_compression_code", _ffi.Entry_compression_code_abi]()
            self.Entry_compression_name_utf8_copy_abi = lib._get_function["rust_mojo__zip__Entry_compression_name_utf8_copy", _ffi.Entry_compression_name_utf8_copy_abi]()
            self.Entry_compression_name_utf8_len_abi = lib._get_function["rust_mojo__zip__Entry_compression_name_utf8_len", _ffi.Entry_compression_name_utf8_len_abi]()
            self.Entry_crc32_abi = lib._get_function["rust_mojo__zip__Entry_crc32", _ffi.Entry_crc32_abi]()
            self.Entry_destroy_abi = lib._get_function["rust_mojo__zip__Entry_destroy", _ffi.Entry_destroy_abi]()
            self.Entry_enclosed_name_utf8_copy_abi = lib._get_function["rust_mojo__zip__Entry_enclosed_name_utf8_copy", _ffi.Entry_enclosed_name_utf8_copy_abi]()
            self.Entry_enclosed_name_utf8_len_abi = lib._get_function["rust_mojo__zip__Entry_enclosed_name_utf8_len", _ffi.Entry_enclosed_name_utf8_len_abi]()
            self.Entry_has_enclosed_name_abi = lib._get_function["rust_mojo__zip__Entry_has_enclosed_name", _ffi.Entry_has_enclosed_name_abi]()
            self.Entry_has_unix_mode_abi = lib._get_function["rust_mojo__zip__Entry_has_unix_mode", _ffi.Entry_has_unix_mode_abi]()
            self.Entry_is_dir_abi = lib._get_function["rust_mojo__zip__Entry_is_dir", _ffi.Entry_is_dir_abi]()
            self.Entry_is_file_abi = lib._get_function["rust_mojo__zip__Entry_is_file", _ffi.Entry_is_file_abi]()
            self.Entry_is_symlink_abi = lib._get_function["rust_mojo__zip__Entry_is_symlink", _ffi.Entry_is_symlink_abi]()
            self.Entry_name_utf8_copy_abi = lib._get_function["rust_mojo__zip__Entry_name_utf8_copy", _ffi.Entry_name_utf8_copy_abi]()
            self.Entry_name_utf8_len_abi = lib._get_function["rust_mojo__zip__Entry_name_utf8_len", _ffi.Entry_name_utf8_len_abi]()
            self.Entry_size_abi = lib._get_function["rust_mojo__zip__Entry_size", _ffi.Entry_size_abi]()
            self.Entry_unix_mode_abi = lib._get_function["rust_mojo__zip__Entry_unix_mode", _ffi.Entry_unix_mode_abi]()
            self.UnitResult_destroy_abi = lib._get_function["rust_mojo__zip__UnitResult_destroy", _ffi.UnitResult_destroy_abi]()
            self.UnitResult_error_utf8_copy_abi = lib._get_function["rust_mojo__zip__UnitResult_error_utf8_copy", _ffi.UnitResult_error_utf8_copy_abi]()
            self.UnitResult_error_utf8_len_abi = lib._get_function["rust_mojo__zip__UnitResult_error_utf8_len", _ffi.UnitResult_error_utf8_len_abi]()
            self.UnitResult_is_ok_abi = lib._get_function["rust_mojo__zip__UnitResult_is_ok", _ffi.UnitResult_is_ok_abi]()
            self.ZipBytes_destroy_abi = lib._get_function["rust_mojo__zip__ZipBytes_destroy", _ffi.ZipBytes_destroy_abi]()
            self.ZipBytes_fill_abi = lib._get_function["rust_mojo__zip__ZipBytes_fill", _ffi.ZipBytes_fill_abi]()
            self.ZipBytes_len_abi = lib._get_function["rust_mojo__zip__ZipBytes_len", _ffi.ZipBytes_len_abi]()
            self.ZipWriter_add_directory_abi = lib._get_function["rust_mojo__zip__ZipWriter_add_directory", _ffi.ZipWriter_add_directory_abi]()
            self.ZipWriter_add_file_abi = lib._get_function["rust_mojo__zip__ZipWriter_add_file", _ffi.ZipWriter_add_file_abi]()
            self.ZipWriter_destroy_abi = lib._get_function["rust_mojo__zip__ZipWriter_destroy", _ffi.ZipWriter_destroy_abi]()
            self.ZipWriter_finish_abi = lib._get_function["rust_mojo__zip__ZipWriter_finish", _ffi.ZipWriter_finish_abi]()
            self.ZipWriter_is_finished_abi = lib._get_function["rust_mojo__zip__ZipWriter_is_finished", _ffi.ZipWriter_is_finished_abi]()
            self.ZipWriter_new_abi = lib._get_function["rust_mojo__zip__ZipWriter_new", _ffi.ZipWriter_new_abi]()
            self.ZipWriter_set_comment_abi = lib._get_function["rust_mojo__zip__ZipWriter_set_comment", _ffi.ZipWriter_set_comment_abi]()
        self.handle = handle^


comptime _LIBRARY_GLOBAL = _Global[
    StorageType=_RuntimeState,
    name="rust-mojo-binding/zip",
    init_fn=_RuntimeState.__init__,
]


def _functions() raises -> Pointer[_RuntimeState, MutUntrackedOrigin]:
    var state = _LIBRARY_GLOBAL.get_or_create_ptr()
    if state[].load_error != "":
        raise Error(state[].load_error)
    return state
