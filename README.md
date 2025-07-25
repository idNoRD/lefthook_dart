## lefthook_dart
[![pub.dev badge](https://img.shields.io/pub/v/lefthook_dart?logo=dart&logoColor=white)](https://pub.dev/packages/lefthook_dart)
![GitHub Maintained](https://img.shields.io/maintenance/yes/2025)
[![Pub points](https://badgen.net/pub/points/lefthook_dart)](https://pub.dev/packages/lefthook_dart/score)
![GitHub License](https://img.shields.io/github/license/idNoRD/lefthook_dart)
[![Lefthook](https://img.shields.io/badge/Lefthook-1.12.2-blue)](https://github.com/evilmartians/lefthook/releases)

A Dart wrapper for [Lefthook](https://github.com/evilmartians/lefthook) — the fast and powerful Git hooks manager.

### About this project

This is a continuation of the original [project-cemetery/lefthook](https://github.com/project-cemetery/lefthook) package, which served as a simple Dart CLI wrapper around the Lefthook binary.

The original repository is no longer maintained. This fork updates the tool for modern Dart/Flutter projects, ensuring compatibility, reliability, and ease of use.

For detailed usage and configuration options, refer to the official [Lefthook documentation](https://github.com/evilmartians/lefthook).

## Installation

### Step 1: Enable the `lefthook` command to run from any place in your terminal
If you already have the original Lefthook installed, you will need to uninstall it, as it may cause conflicts.
```sh
flutter pub global activate lefthook_dart
```
This will ensure that the `lefthook` command uses `lefthook_dart`, a Dart-based wrapper around original Lefthook.

### Step 2: Create `lefthook.yml` in root of your project.
```yml
# lefthook.yml
pre-commit:
  commands:
    prettify:
      glob: "*.dart"
      run: dart format --line-length 80 {staged_files} && git add {staged_files}
```

### Step 3: Run of `lefthook install`. If it's the first run it will download lefthook and execute `lefthook install`
Run the command below inside the project directory where you want Git hooks to be managed.
```sh
lefthook install
```
This will download the native Lefthook binary for your OS, install Git hooks using lefthook install, and prepare your repo for hook execution.

> Now, every time you run git commit, this hook will automatically format staged Dart files and proceed commit with formatted code.
👉 For a working Flutter example, [see example/README.md](example/README.md)

### Step 4: Test hook manually (optional)
```sh
lefthook run pre-commit
```

### Step 5: To uninstall (optional)
```shell
flutter pub global deactivate lefthook_dart
```

### If you are using [Melos](https://github.com/invertase/melos), you can automate Lefthook setup by adding these scripts to your `melos.yaml`.
```yaml
scripts:
  ###############################################
  ##          GIT HOOK COMMANDS                ##
  ###############################################
  hooks:install:
    run: flutter pub global activate lefthook_dart && lefthook
  
  hooks:uninstall:
    run: flutter pub global deactivate lefthook_dart
  
  hooks:run:
    run: lefthook run pre-commit
```
