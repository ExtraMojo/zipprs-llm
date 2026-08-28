// Generated Rust integration tests for the zip 8.6.0 semantic bridge.
// Generator: rust-to-mojo binding workflow 0.1.0.

use ziprs_zip_ffi::ffi::{Archive, Compression, ZipWriter};

fn region(bytes: &[u8]) -> (usize, usize) {
    (bytes.as_ptr() as usize, bytes.len())
}

fn successful_unit(result: &ziprs_zip_ffi::ffi::UnitResult) {
    assert!(result.is_ok());
}

fn build_archive() -> Vec<u8> {
    let mut writer = ZipWriter::new();
    let directory = b"safe/";
    let (directory_address, directory_length) = region(directory);
    successful_unit(&writer.add_directory(directory_address, directory_length));

    let stored_name = b"safe/stored.txt";
    let stored_data = b"stored payload";
    let (stored_name_address, stored_name_length) = region(stored_name);
    let (stored_data_address, stored_data_length) = region(stored_data);
    successful_unit(&writer.add_file(
        stored_name_address,
        stored_name_length,
        stored_data_address,
        stored_data_length,
        Compression::Stored,
    ));

    let deflated_name = b"safe/deflated.txt";
    let deflated_data = b"deflated payload deflated payload deflated payload";
    let (deflated_name_address, deflated_name_length) = region(deflated_name);
    let (deflated_data_address, deflated_data_length) = region(deflated_data);
    successful_unit(&writer.add_file(
        deflated_name_address,
        deflated_name_length,
        deflated_data_address,
        deflated_data_length,
        Compression::Deflated,
    ));

    let unsafe_name = b"../escape.txt";
    let unsafe_data = b"do not extract blindly";
    let (unsafe_name_address, unsafe_name_length) = region(unsafe_name);
    let (unsafe_data_address, unsafe_data_length) = region(unsafe_data);
    successful_unit(&writer.add_file(
        unsafe_name_address,
        unsafe_name_length,
        unsafe_data_address,
        unsafe_data_length,
        Compression::Stored,
    ));

    let comment = b"ziprs test archive";
    let (comment_address, comment_length) = region(comment);
    successful_unit(&writer.set_comment(comment_address, comment_length));

    let mut result = writer.finish();
    assert!(result.is_ok());
    let bytes = result.take().expect("finished bytes");
    let mut output = vec![0; bytes.len()];
    assert_eq!(
        bytes.fill(output.as_mut_ptr() as usize, output.len()),
        output.len()
    );
    output
}

#[test]
fn writer_and_archive_round_trip_stored_and_deflated_entries() {
    let bytes = build_archive();
    let (address, length) = region(&bytes);
    let mut result = Archive::open(address, length);
    assert!(result.is_ok());
    let mut archive = result.take().expect("archive");
    assert_eq!(archive.len(), 4);
    assert!(!archive.is_empty());

    let name = b"safe/deflated.txt";
    let (name_address, name_length) = region(name);
    assert!(archive.has_name(name_address, name_length));
    let index = archive.index_for_name(name_address, name_length);

    let mut entry_result = archive.entry(index);
    assert!(entry_result.is_ok());
    let entry = entry_result.take().expect("entry");
    assert_eq!(entry.size(), 50);
    assert!(entry.is_file());
    assert!(!entry.is_dir());
    assert_eq!(entry.compression_code(), 8);
    let mut copied_name = vec![0; entry.name_utf8_len()];
    assert_eq!(
        entry.name_utf8_copy(copied_name.as_mut_ptr() as usize, copied_name.len()),
        copied_name.len()
    );
    assert_eq!(copied_name, b"safe/deflated.txt");

    let mut read_result = archive.read(index);
    assert!(read_result.is_ok());
    let contents = read_result.take().expect("contents");
    let mut output = vec![0; contents.len()];
    assert_eq!(
        contents.fill(output.as_mut_ptr() as usize, output.len()),
        output.len()
    );
    assert_eq!(
        output,
        b"deflated payload deflated payload deflated payload"
    );
}

#[test]
fn read_into_requires_an_exact_destination_and_preserves_path_safety() {
    let bytes = build_archive();
    let (address, length) = region(&bytes);
    let mut open = Archive::open(address, length);
    let mut archive = open.take().expect("archive");

    let unsafe_name = b"../escape.txt";
    let (name_address, name_length) = region(unsafe_name);
    let index = archive.index_for_name(name_address, name_length);
    let mut entry_result = archive.entry(index);
    let entry = entry_result.take().expect("entry");
    assert!(!entry.has_enclosed_name());

    let mut too_small = vec![0; entry.size() as usize - 1];
    let failed = archive.read_into(index, too_small.as_mut_ptr() as usize, too_small.len());
    assert!(!failed.is_ok());

    let mut exact = vec![0; entry.size() as usize];
    let copied = archive.read_into(index, exact.as_mut_ptr() as usize, exact.len());
    assert!(copied.is_ok());
    assert_eq!(copied.value(), exact.len());
    assert_eq!(exact, b"do not extract blindly");
}

#[test]
fn invalid_archives_report_dynamic_errors() {
    let bytes = b"not a zip archive";
    let (address, length) = region(bytes);
    let result = Archive::open(address, length);
    assert!(!result.is_ok());
    assert!(result.error_utf8_len() > 0);
}
