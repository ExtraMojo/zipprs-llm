// Generated binding source for zip 8.6.0.
// Semantic inputs: binding.toml and this file.
// Generator: rust-to-mojo binding workflow 0.1.0.
// Diplomat: 0.16.1; Diplomat runtime: 0.16.0; Mojo: 1.0.0.

use std::any::Any;
use std::panic::{AssertUnwindSafe, catch_unwind};

fn panic_message(payload: Box<dyn Any + Send>) -> String {
    if let Some(message) = payload.downcast_ref::<&str>() {
        format!("Rust panic: {message}")
    } else if let Some(message) = payload.downcast_ref::<String>() {
        format!("Rust panic: {message}")
    } else {
        "Rust panic with a non-string payload".to_owned()
    }
}

fn ffi_result<T>(operation: impl FnOnce() -> Result<T, String>) -> Result<T, String> {
    match catch_unwind(AssertUnwindSafe(operation)) {
        Ok(result) => result,
        Err(payload) => Err(panic_message(payload)),
    }
}

fn checked_region(address: usize, length: usize) -> Result<(), String> {
    if length == 0 {
        return Ok(());
    }
    if address == 0 {
        return Err("a non-empty byte span has a null address".to_owned());
    }
    if length > isize::MAX as usize {
        return Err("byte span exceeds isize::MAX".to_owned());
    }
    address
        .checked_add(length - 1)
        .ok_or_else(|| "byte span address overflows usize".to_owned())?;
    Ok(())
}

unsafe fn bytes_from_address<'a>(address: usize, length: usize) -> Result<&'a [u8], String> {
    checked_region(address, length)?;
    if length == 0 {
        return Ok(&[]);
    }
    // SAFETY: checked_region rejects null, oversized, and wrapping regions. The
    // generated Mojo wrapper keeps the originating span alive for this call.
    Ok(unsafe { std::slice::from_raw_parts(address as *const u8, length) })
}

unsafe fn bytes_from_address_mut<'a>(
    address: usize,
    length: usize,
) -> Result<&'a mut [u8], String> {
    checked_region(address, length)?;
    if length == 0 {
        return Ok(&mut []);
    }
    // SAFETY: checked_region rejects null, oversized, and wrapping regions. The
    // generated Mojo wrapper supplies a uniquely borrowed mutable span.
    Ok(unsafe { std::slice::from_raw_parts_mut(address as *mut u8, length) })
}

fn utf8_from_address(address: usize, length: usize) -> Result<String, String> {
    // SAFETY: validation and call-scoped ownership are provided by the ABI contract.
    let bytes = unsafe { bytes_from_address(address, length)? };
    std::str::from_utf8(bytes)
        .map(str::to_owned)
        .map_err(|error| format!("expected UTF-8 text: {error}"))
}

fn copy_to_address(source: &[u8], address: usize, length: usize) -> usize {
    let operation = || -> Result<usize, String> {
        // SAFETY: validation and call-scoped ownership are provided by the ABI contract.
        let destination = unsafe { bytes_from_address_mut(address, length)? };
        let count = source.len().min(destination.len());
        destination[..count].copy_from_slice(&source[..count]);
        Ok(count)
    };
    ffi_result(operation).unwrap_or(0)
}

#[diplomat::bridge]
#[diplomat::abi_rename = "rust_mojo__zip__{0}"]
pub mod ffi {
    pub enum Compression {
        Stored,
        Deflated,
    }

    impl Compression {
        fn rust_method(self) -> zip::CompressionMethod {
            match self {
                Self::Stored => zip::CompressionMethod::Stored,
                Self::Deflated => zip::CompressionMethod::Deflated,
            }
        }
    }

    #[diplomat::opaque_mut]
    pub struct Archive {
        inner: zip::ZipArchive<std::io::Cursor<Vec<u8>>>,
    }

    #[diplomat::opaque]
    pub struct Entry {
        name: String,
        enclosed_name: Option<String>,
        comment: String,
        compressed_size: u64,
        size: u64,
        crc32: u32,
        compression_code: u16,
        is_dir: bool,
        is_file: bool,
        is_symlink: bool,
        unix_mode: Option<u32>,
    }

    #[diplomat::opaque]
    pub struct ZipBytes {
        bytes: Vec<u8>,
    }

    #[diplomat::opaque_mut]
    pub struct ZipWriter {
        inner: Option<zip::ZipWriter<std::io::Cursor<Vec<u8>>>>,
    }

    #[diplomat::opaque_mut]
    pub struct ArchiveResult {
        value: Option<Box<Archive>>,
        error: String,
    }

    #[diplomat::opaque_mut]
    pub struct EntryResult {
        value: Option<Box<Entry>>,
        error: String,
    }

    #[diplomat::opaque_mut]
    pub struct BytesResult {
        value: Option<Box<ZipBytes>>,
        error: String,
    }

    #[diplomat::opaque]
    pub struct UnitResult {
        ok: bool,
        error: String,
    }

    #[diplomat::opaque]
    pub struct CountResult {
        value: usize,
        ok: bool,
        error: String,
    }

    fn unit_result(result: Result<(), String>) -> Box<UnitResult> {
        match result {
            Ok(()) => Box::new(UnitResult {
                ok: true,
                error: String::new(),
            }),
            Err(error) => Box::new(UnitResult { ok: false, error }),
        }
    }

    fn entry_result(result: Result<Entry, String>) -> Box<EntryResult> {
        match result {
            Ok(value) => Box::new(EntryResult {
                value: Some(Box::new(value)),
                error: String::new(),
            }),
            Err(error) => Box::new(EntryResult { value: None, error }),
        }
    }

    fn bytes_result(result: Result<Vec<u8>, String>) -> Box<BytesResult> {
        match result {
            Ok(bytes) => Box::new(BytesResult {
                value: Some(Box::new(ZipBytes { bytes })),
                error: String::new(),
            }),
            Err(error) => Box::new(BytesResult { value: None, error }),
        }
    }

    fn copy_string(value: &str, buffer_address: usize, buffer_length: usize) -> usize {
        super::copy_to_address(value.as_bytes(), buffer_address, buffer_length)
    }

    impl Archive {
        pub fn open(data_address: usize, data_length: usize) -> Box<ArchiveResult> {
            let result = super::ffi_result(|| {
                // SAFETY: the generated wrapper supplies a call-scoped byte span.
                let bytes = unsafe { super::bytes_from_address(data_address, data_length)? };
                let cursor = std::io::Cursor::new(bytes.to_vec());
                let inner = zip::ZipArchive::new(cursor).map_err(|error| error.to_string())?;
                Ok(Archive { inner })
            });
            match result {
                Ok(value) => Box::new(ArchiveResult {
                    value: Some(Box::new(value)),
                    error: String::new(),
                }),
                Err(error) => Box::new(ArchiveResult { value: None, error }),
            }
        }

        pub fn len(&self) -> usize {
            super::ffi_result(|| Ok(self.inner.len())).unwrap_or(0)
        }

        pub fn is_empty(&self) -> bool {
            super::ffi_result(|| Ok(self.inner.is_empty())).unwrap_or(false)
        }

        pub fn has_name(&self, name_address: usize, name_length: usize) -> bool {
            super::ffi_result(|| {
                let name = super::utf8_from_address(name_address, name_length)?;
                Ok(self.inner.index_for_name(&name).is_some())
            })
            .unwrap_or(false)
        }

        pub fn index_for_name(&self, name_address: usize, name_length: usize) -> usize {
            super::ffi_result(|| {
                let name = super::utf8_from_address(name_address, name_length)?;
                self.inner
                    .index_for_name(&name)
                    .ok_or_else(|| "entry name was not found".to_owned())
            })
            .unwrap_or(0)
        }

        pub fn entry(&mut self, index: usize) -> Box<EntryResult> {
            entry_result(super::ffi_result(|| {
                let file = self
                    .inner
                    .by_index(index)
                    .map_err(|error| error.to_string())?;
                #[allow(deprecated)]
                let compression_code = file.compression().to_u16();
                Ok(Entry {
                    name: file.name().to_owned(),
                    enclosed_name: file
                        .enclosed_name()
                        .map(|path| path.to_string_lossy().into_owned()),
                    comment: file.comment().to_owned(),
                    compressed_size: file.compressed_size(),
                    size: file.size(),
                    crc32: file.crc32(),
                    compression_code,
                    is_dir: file.is_dir(),
                    is_file: file.is_file(),
                    is_symlink: file.is_symlink(),
                    unix_mode: file.unix_mode(),
                })
            }))
        }

        pub fn read(&mut self, index: usize) -> Box<BytesResult> {
            bytes_result(super::ffi_result(|| {
                let mut file = self
                    .inner
                    .by_index(index)
                    .map_err(|error| error.to_string())?;
                let expected = usize::try_from(file.size())
                    .map_err(|_| "entry is too large for this platform".to_owned())?;
                let mut bytes = Vec::new();
                bytes
                    .try_reserve_exact(expected)
                    .map_err(|error| format!("could not reserve entry buffer: {error}"))?;
                std::io::Read::read_to_end(&mut file, &mut bytes)
                    .map_err(|error| error.to_string())?;
                Ok(bytes)
            }))
        }

        pub fn read_into(
            &mut self,
            index: usize,
            buffer_address: usize,
            buffer_length: usize,
        ) -> Box<CountResult> {
            let result = super::ffi_result(|| {
                let mut file = self
                    .inner
                    .by_index(index)
                    .map_err(|error| error.to_string())?;
                let expected = usize::try_from(file.size())
                    .map_err(|_| "entry is too large for this platform".to_owned())?;
                if expected != buffer_length {
                    return Err(format!(
                        "destination length {buffer_length} does not match entry size {expected}"
                    ));
                }
                // SAFETY: the generated wrapper supplies a uniquely borrowed span.
                let destination =
                    unsafe { super::bytes_from_address_mut(buffer_address, buffer_length)? };
                std::io::Read::read_exact(&mut file, destination)
                    .map_err(|error| error.to_string())?;
                Ok(expected)
            });
            match result {
                Ok(value) => Box::new(CountResult {
                    value,
                    ok: true,
                    error: String::new(),
                }),
                Err(error) => Box::new(CountResult {
                    value: 0,
                    ok: false,
                    error,
                }),
            }
        }

        pub fn comment(&self) -> Box<ZipBytes> {
            Box::new(ZipBytes {
                bytes: self.inner.comment().to_vec(),
            })
        }
    }

    impl Entry {
        pub fn name_utf8_len(&self) -> usize {
            self.name.len()
        }

        pub fn name_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.name, buffer_address, buffer_length)
        }

        pub fn has_enclosed_name(&self) -> bool {
            self.enclosed_name.is_some()
        }

        pub fn enclosed_name_utf8_len(&self) -> usize {
            self.enclosed_name.as_deref().map(str::len).unwrap_or(0)
        }

        pub fn enclosed_name_utf8_copy(
            &self,
            buffer_address: usize,
            buffer_length: usize,
        ) -> usize {
            copy_string(
                self.enclosed_name.as_deref().unwrap_or(""),
                buffer_address,
                buffer_length,
            )
        }

        pub fn comment_utf8_len(&self) -> usize {
            self.comment.len()
        }

        pub fn comment_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.comment, buffer_address, buffer_length)
        }

        pub fn compressed_size(&self) -> u64 {
            self.compressed_size
        }

        pub fn size(&self) -> u64 {
            self.size
        }

        pub fn crc32(&self) -> u32 {
            self.crc32
        }

        pub fn compression_code(&self) -> u16 {
            self.compression_code
        }

        pub fn compression_name_utf8_len(&self) -> usize {
            zip::CompressionMethod::name_from_u16(self.compression_code).len()
        }

        pub fn compression_name_utf8_copy(
            &self,
            buffer_address: usize,
            buffer_length: usize,
        ) -> usize {
            copy_string(
                zip::CompressionMethod::name_from_u16(self.compression_code),
                buffer_address,
                buffer_length,
            )
        }

        pub fn is_dir(&self) -> bool {
            self.is_dir
        }

        pub fn is_file(&self) -> bool {
            self.is_file
        }

        pub fn is_symlink(&self) -> bool {
            self.is_symlink
        }

        pub fn has_unix_mode(&self) -> bool {
            self.unix_mode.is_some()
        }

        pub fn unix_mode(&self) -> u32 {
            self.unix_mode.unwrap_or(0)
        }
    }

    impl ZipBytes {
        pub fn len(&self) -> usize {
            self.bytes.len()
        }

        pub fn fill(&self, buffer_address: usize, buffer_length: usize) -> usize {
            super::copy_to_address(&self.bytes, buffer_address, buffer_length)
        }
    }

    impl ZipWriter {
        pub fn new() -> Box<ZipWriter> {
            Box::new(ZipWriter {
                inner: Some(zip::ZipWriter::new(std::io::Cursor::new(Vec::new()))),
            })
        }

        pub fn is_finished(&self) -> bool {
            self.inner.is_none()
        }

        pub fn add_file(
            &mut self,
            name_address: usize,
            name_length: usize,
            data_address: usize,
            data_length: usize,
            compression: Compression,
        ) -> Box<UnitResult> {
            unit_result(super::ffi_result(|| {
                let name = super::utf8_from_address(name_address, name_length)?;
                // SAFETY: the generated wrapper supplies a call-scoped byte span.
                let data = unsafe { super::bytes_from_address(data_address, data_length)? };
                let writer = self
                    .inner
                    .as_mut()
                    .ok_or_else(|| "writer has already been finished".to_owned())?;
                let options = zip::write::SimpleFileOptions::default()
                    .compression_method(compression.rust_method());
                writer
                    .start_file(name, options)
                    .map_err(|error| error.to_string())?;
                std::io::Write::write_all(writer, data).map_err(|error| error.to_string())?;
                Ok(())
            }))
        }

        pub fn add_directory(
            &mut self,
            name_address: usize,
            name_length: usize,
        ) -> Box<UnitResult> {
            unit_result(super::ffi_result(|| {
                let name = super::utf8_from_address(name_address, name_length)?;
                let writer = self
                    .inner
                    .as_mut()
                    .ok_or_else(|| "writer has already been finished".to_owned())?;
                let options = zip::write::SimpleFileOptions::default()
                    .compression_method(zip::CompressionMethod::Stored);
                writer
                    .add_directory(name, options)
                    .map_err(|error| error.to_string())?;
                Ok(())
            }))
        }

        pub fn set_comment(&mut self, data_address: usize, data_length: usize) -> Box<UnitResult> {
            unit_result(super::ffi_result(|| {
                let comment = super::utf8_from_address(data_address, data_length)?;
                let writer = self
                    .inner
                    .as_mut()
                    .ok_or_else(|| "writer has already been finished".to_owned())?;
                writer
                    .set_comment(comment)
                    .map_err(|error| error.to_string())?;
                Ok(())
            }))
        }

        pub fn finish(&mut self) -> Box<BytesResult> {
            bytes_result(super::ffi_result(|| {
                let writer = self
                    .inner
                    .take()
                    .ok_or_else(|| "writer has already been finished".to_owned())?;
                let cursor = writer.finish().map_err(|error| error.to_string())?;
                Ok(cursor.into_inner())
            }))
        }
    }

    impl ArchiveResult {
        pub fn is_ok(&self) -> bool {
            self.value.is_some()
        }

        pub fn error_utf8_len(&self) -> usize {
            self.error.len()
        }

        pub fn error_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.error, buffer_address, buffer_length)
        }

        pub fn take(&mut self) -> Option<Box<Archive>> {
            self.value.take()
        }
    }

    impl EntryResult {
        pub fn is_ok(&self) -> bool {
            self.value.is_some()
        }

        pub fn error_utf8_len(&self) -> usize {
            self.error.len()
        }

        pub fn error_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.error, buffer_address, buffer_length)
        }

        pub fn take(&mut self) -> Option<Box<Entry>> {
            self.value.take()
        }
    }

    impl BytesResult {
        pub fn is_ok(&self) -> bool {
            self.value.is_some()
        }

        pub fn error_utf8_len(&self) -> usize {
            self.error.len()
        }

        pub fn error_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.error, buffer_address, buffer_length)
        }

        pub fn take(&mut self) -> Option<Box<ZipBytes>> {
            self.value.take()
        }
    }

    impl UnitResult {
        pub fn is_ok(&self) -> bool {
            self.ok
        }

        pub fn error_utf8_len(&self) -> usize {
            self.error.len()
        }

        pub fn error_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.error, buffer_address, buffer_length)
        }
    }

    impl CountResult {
        pub fn is_ok(&self) -> bool {
            self.ok
        }

        pub fn value(&self) -> usize {
            self.value
        }

        pub fn error_utf8_len(&self) -> usize {
            self.error.len()
        }

        pub fn error_utf8_copy(&self, buffer_address: usize, buffer_length: usize) -> usize {
            copy_string(&self.error, buffer_address, buffer_length)
        }
    }
}
