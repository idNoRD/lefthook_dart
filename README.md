# lefthook-dart

A Dart wrapper for [Lefthook](https://github.com/evilmartians/lefthook) — the fast and powerful Git hooks manager.

## About this project

This is a community-maintained continuation of the original [project-cemetery/lefthook](https://github.com/project-cemetery/lefthook) package, which served as a simple Dart CLI wrapper around the Lefthook binary.

The original repository is no longer maintained. This fork updates the tool for modern Dart/Flutter projects, ensuring compatibility, reliability, and ease of use.

For detailed usage and configuration options, refer to the official [Lefthook documentation](https://github.com/evilmartians/lefthook).

## Installation

### Step 1: Enable the `lefthook` command to run from any place in your terminal
If you already have the original Lefthook installed, you will need to uninstall it, as it may cause conflicts.
```sh
flutter pub global activate lefthook_dart
```
This will ensure that the `lefthook` command uses `lefthook_dart`, a Dart-based wrapper around original Lefthook.
### Step 2: The first run of `lefthook` will download lefthook and execute `lefthook install` automatically
```sh
lefthook
```

### Step 3: Change `lefthook.yml` in root of your project.
```yml
# lefthook.yml
pre-commit:
  commands:
    prettify:
      glob: "*.dart"
      run: dart format {all_files}
```

### Step 4: Test hook manually (optional)
```sh
lefthook run pre-commit
```
