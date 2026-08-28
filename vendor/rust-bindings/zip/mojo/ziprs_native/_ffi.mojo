# GENERATED FILE — DO NOT EDIT DIRECTLY
# Source crate: zip =8.6.0
# Binding manifest: binding.toml
# Generator: rust-mojo-wrapper-generator 0.1.0 (projection 0.1.0)
# Diplomat: 0.16.1
# Diplomat core: 0.16.1
# Diplomat runtime: 0.16.0
# Mojo compiler: 1.0.0
# ABI backend: diplomat-gen-mojo 0.1.0
# ABI backend Diplomat core: 0.16.1
# ABI model SHA-256: 639a8abd29b406d03dd964236c50c38f83f59eeb04cf0a201abd47fe5f9d99df

comptime Compression = Int32
comptime Compression_Stored: Compression = 0
comptime Compression_Deflated: Compression = 1

comptime ArchiveHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime ArchiveRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime ArchiveMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime ArchiveOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ArchiveOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime ArchiveOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime Archive_destroy_abi = def(ArchiveHandle) thin abi("C") -> None
# symbol Archive_destroy_abi = "rust_mojo__zip__Archive_destroy"

comptime ArchiveResultHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime ArchiveResultRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime ArchiveResultMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime ArchiveResultOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ArchiveResultOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime ArchiveResultOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ArchiveResult_destroy_abi = def(ArchiveResultHandle) thin abi("C") -> None
# symbol ArchiveResult_destroy_abi = "rust_mojo__zip__ArchiveResult_destroy"

comptime BytesResultHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime BytesResultRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime BytesResultMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime BytesResultOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime BytesResultOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime BytesResultOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime BytesResult_destroy_abi = def(BytesResultHandle) thin abi("C") -> None
# symbol BytesResult_destroy_abi = "rust_mojo__zip__BytesResult_destroy"

comptime CountResultHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime CountResultRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime CountResultMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime CountResultOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime CountResultOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime CountResultOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime CountResult_destroy_abi = def(CountResultHandle) thin abi("C") -> None
# symbol CountResult_destroy_abi = "rust_mojo__zip__CountResult_destroy"

comptime EntryHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime EntryRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime EntryMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime EntryOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime EntryOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime EntryOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime Entry_destroy_abi = def(EntryHandle) thin abi("C") -> None
# symbol Entry_destroy_abi = "rust_mojo__zip__Entry_destroy"

comptime EntryResultHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime EntryResultRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime EntryResultMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime EntryResultOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime EntryResultOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime EntryResultOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime EntryResult_destroy_abi = def(EntryResultHandle) thin abi("C") -> None
# symbol EntryResult_destroy_abi = "rust_mojo__zip__EntryResult_destroy"

comptime UnitResultHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime UnitResultRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime UnitResultMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime UnitResultOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime UnitResultOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime UnitResultOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime UnitResult_destroy_abi = def(UnitResultHandle) thin abi("C") -> None
# symbol UnitResult_destroy_abi = "rust_mojo__zip__UnitResult_destroy"

comptime ZipBytesHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime ZipBytesRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime ZipBytesMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime ZipBytesOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ZipBytesOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime ZipBytesOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ZipBytes_destroy_abi = def(ZipBytesHandle) thin abi("C") -> None
# symbol ZipBytes_destroy_abi = "rust_mojo__zip__ZipBytes_destroy"

comptime ZipWriterHandle = Pointer[UInt8, MutUntrackedOrigin]
comptime ZipWriterRef = Pointer[UInt8, ImmUntrackedOrigin]
comptime ZipWriterMutRef = Pointer[UInt8, MutUntrackedOrigin]
comptime ZipWriterOptionalHandle = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ZipWriterOptionalRef = OptionalPointer[UInt8, ImmUntrackedOrigin]
comptime ZipWriterOptionalMutRef = OptionalPointer[UInt8, MutUntrackedOrigin]
comptime ZipWriter_destroy_abi = def(ZipWriterHandle) thin abi("C") -> None
# symbol ZipWriter_destroy_abi = "rust_mojo__zip__ZipWriter_destroy"

comptime Archive_open_abi = def(UInt, UInt) thin abi("C") -> ArchiveResultHandle
# symbol Archive_open_abi = "rust_mojo__zip__Archive_open"
comptime Archive_len_abi = def(ArchiveRef) thin abi("C") -> UInt
# symbol Archive_len_abi = "rust_mojo__zip__Archive_len"
comptime Archive_is_empty_abi = def(ArchiveRef) thin abi("C") -> Bool
# symbol Archive_is_empty_abi = "rust_mojo__zip__Archive_is_empty"
comptime Archive_has_name_abi = def(ArchiveRef, UInt, UInt) thin abi("C") -> Bool
# symbol Archive_has_name_abi = "rust_mojo__zip__Archive_has_name"
comptime Archive_index_for_name_abi = def(ArchiveRef, UInt, UInt) thin abi("C") -> UInt
# symbol Archive_index_for_name_abi = "rust_mojo__zip__Archive_index_for_name"
comptime Archive_entry_abi = def(ArchiveMutRef, UInt) thin abi("C") -> EntryResultHandle
# symbol Archive_entry_abi = "rust_mojo__zip__Archive_entry"
comptime Archive_read__abi = def(ArchiveMutRef, UInt) thin abi("C") -> BytesResultHandle
# symbol Archive_read__abi = "rust_mojo__zip__Archive_read"
comptime Archive_read_into_abi = def(ArchiveMutRef, UInt, UInt, UInt) thin abi("C") -> CountResultHandle
# symbol Archive_read_into_abi = "rust_mojo__zip__Archive_read_into"
comptime Archive_comment_abi = def(ArchiveRef) thin abi("C") -> ZipBytesHandle
# symbol Archive_comment_abi = "rust_mojo__zip__Archive_comment"
comptime ArchiveResult_is_ok_abi = def(ArchiveResultRef) thin abi("C") -> Bool
# symbol ArchiveResult_is_ok_abi = "rust_mojo__zip__ArchiveResult_is_ok"
comptime ArchiveResult_error_utf8_len_abi = def(ArchiveResultRef) thin abi("C") -> UInt
# symbol ArchiveResult_error_utf8_len_abi = "rust_mojo__zip__ArchiveResult_error_utf8_len"
comptime ArchiveResult_error_utf8_copy_abi = def(ArchiveResultRef, UInt, UInt) thin abi("C") -> UInt
# symbol ArchiveResult_error_utf8_copy_abi = "rust_mojo__zip__ArchiveResult_error_utf8_copy"
comptime ArchiveResult_take_abi = def(ArchiveResultMutRef) thin abi("C") -> ArchiveOptionalHandle
# symbol ArchiveResult_take_abi = "rust_mojo__zip__ArchiveResult_take"
comptime BytesResult_is_ok_abi = def(BytesResultRef) thin abi("C") -> Bool
# symbol BytesResult_is_ok_abi = "rust_mojo__zip__BytesResult_is_ok"
comptime BytesResult_error_utf8_len_abi = def(BytesResultRef) thin abi("C") -> UInt
# symbol BytesResult_error_utf8_len_abi = "rust_mojo__zip__BytesResult_error_utf8_len"
comptime BytesResult_error_utf8_copy_abi = def(BytesResultRef, UInt, UInt) thin abi("C") -> UInt
# symbol BytesResult_error_utf8_copy_abi = "rust_mojo__zip__BytesResult_error_utf8_copy"
comptime BytesResult_take_abi = def(BytesResultMutRef) thin abi("C") -> ZipBytesOptionalHandle
# symbol BytesResult_take_abi = "rust_mojo__zip__BytesResult_take"
comptime CountResult_is_ok_abi = def(CountResultRef) thin abi("C") -> Bool
# symbol CountResult_is_ok_abi = "rust_mojo__zip__CountResult_is_ok"
comptime CountResult_value_abi = def(CountResultRef) thin abi("C") -> UInt
# symbol CountResult_value_abi = "rust_mojo__zip__CountResult_value"
comptime CountResult_error_utf8_len_abi = def(CountResultRef) thin abi("C") -> UInt
# symbol CountResult_error_utf8_len_abi = "rust_mojo__zip__CountResult_error_utf8_len"
comptime CountResult_error_utf8_copy_abi = def(CountResultRef, UInt, UInt) thin abi("C") -> UInt
# symbol CountResult_error_utf8_copy_abi = "rust_mojo__zip__CountResult_error_utf8_copy"
comptime Entry_name_utf8_len_abi = def(EntryRef) thin abi("C") -> UInt
# symbol Entry_name_utf8_len_abi = "rust_mojo__zip__Entry_name_utf8_len"
comptime Entry_name_utf8_copy_abi = def(EntryRef, UInt, UInt) thin abi("C") -> UInt
# symbol Entry_name_utf8_copy_abi = "rust_mojo__zip__Entry_name_utf8_copy"
comptime Entry_has_enclosed_name_abi = def(EntryRef) thin abi("C") -> Bool
# symbol Entry_has_enclosed_name_abi = "rust_mojo__zip__Entry_has_enclosed_name"
comptime Entry_enclosed_name_utf8_len_abi = def(EntryRef) thin abi("C") -> UInt
# symbol Entry_enclosed_name_utf8_len_abi = "rust_mojo__zip__Entry_enclosed_name_utf8_len"
comptime Entry_enclosed_name_utf8_copy_abi = def(EntryRef, UInt, UInt) thin abi("C") -> UInt
# symbol Entry_enclosed_name_utf8_copy_abi = "rust_mojo__zip__Entry_enclosed_name_utf8_copy"
comptime Entry_comment_utf8_len_abi = def(EntryRef) thin abi("C") -> UInt
# symbol Entry_comment_utf8_len_abi = "rust_mojo__zip__Entry_comment_utf8_len"
comptime Entry_comment_utf8_copy_abi = def(EntryRef, UInt, UInt) thin abi("C") -> UInt
# symbol Entry_comment_utf8_copy_abi = "rust_mojo__zip__Entry_comment_utf8_copy"
comptime Entry_compressed_size_abi = def(EntryRef) thin abi("C") -> UInt64
# symbol Entry_compressed_size_abi = "rust_mojo__zip__Entry_compressed_size"
comptime Entry_size_abi = def(EntryRef) thin abi("C") -> UInt64
# symbol Entry_size_abi = "rust_mojo__zip__Entry_size"
comptime Entry_crc32_abi = def(EntryRef) thin abi("C") -> UInt32
# symbol Entry_crc32_abi = "rust_mojo__zip__Entry_crc32"
comptime Entry_compression_code_abi = def(EntryRef) thin abi("C") -> UInt16
# symbol Entry_compression_code_abi = "rust_mojo__zip__Entry_compression_code"
comptime Entry_compression_name_utf8_len_abi = def(EntryRef) thin abi("C") -> UInt
# symbol Entry_compression_name_utf8_len_abi = "rust_mojo__zip__Entry_compression_name_utf8_len"
comptime Entry_compression_name_utf8_copy_abi = def(EntryRef, UInt, UInt) thin abi("C") -> UInt
# symbol Entry_compression_name_utf8_copy_abi = "rust_mojo__zip__Entry_compression_name_utf8_copy"
comptime Entry_is_dir_abi = def(EntryRef) thin abi("C") -> Bool
# symbol Entry_is_dir_abi = "rust_mojo__zip__Entry_is_dir"
comptime Entry_is_file_abi = def(EntryRef) thin abi("C") -> Bool
# symbol Entry_is_file_abi = "rust_mojo__zip__Entry_is_file"
comptime Entry_is_symlink_abi = def(EntryRef) thin abi("C") -> Bool
# symbol Entry_is_symlink_abi = "rust_mojo__zip__Entry_is_symlink"
comptime Entry_has_unix_mode_abi = def(EntryRef) thin abi("C") -> Bool
# symbol Entry_has_unix_mode_abi = "rust_mojo__zip__Entry_has_unix_mode"
comptime Entry_unix_mode_abi = def(EntryRef) thin abi("C") -> UInt32
# symbol Entry_unix_mode_abi = "rust_mojo__zip__Entry_unix_mode"
comptime EntryResult_is_ok_abi = def(EntryResultRef) thin abi("C") -> Bool
# symbol EntryResult_is_ok_abi = "rust_mojo__zip__EntryResult_is_ok"
comptime EntryResult_error_utf8_len_abi = def(EntryResultRef) thin abi("C") -> UInt
# symbol EntryResult_error_utf8_len_abi = "rust_mojo__zip__EntryResult_error_utf8_len"
comptime EntryResult_error_utf8_copy_abi = def(EntryResultRef, UInt, UInt) thin abi("C") -> UInt
# symbol EntryResult_error_utf8_copy_abi = "rust_mojo__zip__EntryResult_error_utf8_copy"
comptime EntryResult_take_abi = def(EntryResultMutRef) thin abi("C") -> EntryOptionalHandle
# symbol EntryResult_take_abi = "rust_mojo__zip__EntryResult_take"
comptime UnitResult_is_ok_abi = def(UnitResultRef) thin abi("C") -> Bool
# symbol UnitResult_is_ok_abi = "rust_mojo__zip__UnitResult_is_ok"
comptime UnitResult_error_utf8_len_abi = def(UnitResultRef) thin abi("C") -> UInt
# symbol UnitResult_error_utf8_len_abi = "rust_mojo__zip__UnitResult_error_utf8_len"
comptime UnitResult_error_utf8_copy_abi = def(UnitResultRef, UInt, UInt) thin abi("C") -> UInt
# symbol UnitResult_error_utf8_copy_abi = "rust_mojo__zip__UnitResult_error_utf8_copy"
comptime ZipBytes_len_abi = def(ZipBytesRef) thin abi("C") -> UInt
# symbol ZipBytes_len_abi = "rust_mojo__zip__ZipBytes_len"
comptime ZipBytes_fill_abi = def(ZipBytesRef, UInt, UInt) thin abi("C") -> UInt
# symbol ZipBytes_fill_abi = "rust_mojo__zip__ZipBytes_fill"
comptime ZipWriter_new_abi = def() thin abi("C") -> ZipWriterHandle
# symbol ZipWriter_new_abi = "rust_mojo__zip__ZipWriter_new"
comptime ZipWriter_is_finished_abi = def(ZipWriterRef) thin abi("C") -> Bool
# symbol ZipWriter_is_finished_abi = "rust_mojo__zip__ZipWriter_is_finished"
comptime ZipWriter_add_file_abi = def(ZipWriterMutRef, UInt, UInt, UInt, UInt, Compression) thin abi("C") -> UnitResultHandle
# symbol ZipWriter_add_file_abi = "rust_mojo__zip__ZipWriter_add_file"
comptime ZipWriter_add_directory_abi = def(ZipWriterMutRef, UInt, UInt) thin abi("C") -> UnitResultHandle
# symbol ZipWriter_add_directory_abi = "rust_mojo__zip__ZipWriter_add_directory"
comptime ZipWriter_set_comment_abi = def(ZipWriterMutRef, UInt, UInt) thin abi("C") -> UnitResultHandle
# symbol ZipWriter_set_comment_abi = "rust_mojo__zip__ZipWriter_set_comment"
comptime ZipWriter_finish_abi = def(ZipWriterMutRef) thin abi("C") -> BytesResultHandle
# symbol ZipWriter_finish_abi = "rust_mojo__zip__ZipWriter_finish"
