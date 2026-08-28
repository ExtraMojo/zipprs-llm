# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- One-command installation from the Git source in the README.
- Modo and Hugo API-documentation generation in CI, with generated artifacts and `gh-pages`
  deployment from `main`.
- Structured API docstrings, task-oriented guides, and executable reading and writing examples.

## [0.1.0] - 2026-08-28

### Added

- Initial AI-generated Mojo bindings for Rust's `zip` 8.6.0 crate.
- Reading, entry lookup, metadata, comments, and exact-size buffer reads through `Archive`.
- ZIP creation through `ZipWriter`, with Stored and Deflate compression.
- Transitive native-library packaging through the `pixi-build-mojo` backend.
- Reading and writing examples.
- Tests for the public Mojo API and a downstream Pixi Git-source consumer.
- GitHub Actions CI for Linux x86-64, Linux ARM64, and macOS ARM64.

[Unreleased]: https://github.com/ExtraMojo/zipprs-llm/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ExtraMojo/zipprs-llm/releases/tag/v0.1.0
