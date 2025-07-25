# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and uses [Semantic Versioning](https://semver.org/).

---
## [1.0.4] - 2025-07-24

### Added
Example into example/ folder (see example/README.md)
analysis_options.yaml to follow recommended lint rules by pub.dev

## [1.0.3] - 2025-07-24

### Fixed
if flutter installed using snap it tries to use git from snap that is old and not supported by lefthook
as a solution we change PATH to pick git from /usr/bin instead of old git version from snap

## [1.0.2] - 2025-07-24

### Fixed
Use projectDir as workingDir and print git version

## [1.0.1] - 2025-07-22

### Fixed
- Fixed the executables mapping in pubspec.yaml to ensure the lefthook command uses lefthook_dart, the Dart-based wrapper for Lefthook.

## [1.0.0] – 2025-07-21

### Added
- Forked from [project-cemetery/lefthook](https://github.com/project-cemetery/lefthook)
- Dart CLI wrapper for [Lefthook](https://github.com/evilmartians/lefthook)
- Full compatibility with modern Dart and Flutter projects
- Usage examples and documentation
- MIT license retained from original author

### Changed
- Refactored and polished entire codebase for initial release
- Upgraded all dependencies to work with Dart 3 and Flutter 3 (2025)

### Fixed
- Bug with version parsing from `pubspec.yaml`
- Removed unused public API for downloading (now internal)

### Documentation
- Rewrote README for clarity
- Added setup and usage instructions
- Cleaned up pubspec metadata for pub.dev compliance
