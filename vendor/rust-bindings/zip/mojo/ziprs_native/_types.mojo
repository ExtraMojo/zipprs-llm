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
import ziprs_native._ffi as _ffi
import ziprs_native._runtime as _runtime

comptime Compression = _ffi.Compression
comptime Compression_Stored: Compression = _ffi.Compression_Stored
comptime Compression_Deflated: Compression = _ffi.Compression_Deflated

def _validate_Compression(value: Compression) raises:
    if value == Compression_Stored:
        return
    if value == Compression_Deflated:
        return
    raise Error("invalid Compression discriminant")
