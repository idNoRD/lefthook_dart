# lefthook_dart

A Dart wrapper for [Lefthook](https://github.com/evilmartians/lefthook) — the fast and powerful Git hooks manager.

## About this project

This is a community-maintained continuation of the original [project-cemetery/lefthook](https://github.com/project-cemetery/lefthook) package, which served as a simple Dart CLI wrapper around the Lefthook binary.

The original repository is no longer maintained. This fork updates the tool for modern Dart/Flutter projects, ensuring compatibility, reliability, and ease of use.

For detailed usage and configuration options, refer to the official [Lefthook documentation](https://github.com/evilmartians/lefthook).

## Installation

### Step 1: Enable the `lefthook` command to run from any place in your terminal
If you already have the original Lefthook installed, you will need to uninstall it, as it may cause conflicts.  
Run the command below inside the project directory where you want Git hooks to be managed.
```sh
flutter pub global activate lefthook_dart
```
This will ensure that the `lefthook` command uses `lefthook_dart`, a Dart-based wrapper around original Lefthook.
### Step 2: The first run of `lefthook` will download lefthook and execute `lefthook install` automatically
```sh
lefthook
```
This will download the native Lefthook binary for your OS, install Git hooks using lefthook install, and prepare your repo for hook execution.

### Step 3: Change `lefthook.yml` in root of your project.
```yml
# lefthook.yml
pre-commit:
  commands:
    prettify:
      glob: "*.dart"
      run: dart format {all_files}
```
> Now, every time you run git commit, this hook will automatically format all your Dart files.  
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
