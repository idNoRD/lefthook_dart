# lefthook-dart

A Dart wrapper for [Lefthook](https://github.com/evilmartians/lefthook) — the fast and powerful Git hooks manager.

## About this project

This is a community-maintained continuation of the original [project-cemetery/lefthook](https://github.com/project-cemetery/lefthook) package, which served as a simple Dart CLI wrapper around the Lefthook binary.

The original repository is no longer maintained. This fork updates the tool for modern Dart/Flutter projects, ensuring compatibility, reliability, and ease of use.

For detailed usage and configuration options, refer to the official [Lefthook documentation](https://github.com/evilmartians/lefthook).

## Installation

```sh
pub global activate lefthook-dart
```

Change `lefthook.yml` in root of your project, add description of hooks, and start using it.

## Examples

### Flutter

For project based on Flutter, you can run formatter before every commit and run tests and static analysis before push.

```yml
# lefthook.yml

pre-push:
  parallel: true
  commands:
    tests:
      run: flutter test
    linter:
      run: flutter analyze lib

pre-commit:
  commands:
    prettify:
      glob: "*.dart"
      run: dart format {staged_files}
```
