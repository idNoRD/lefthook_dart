# example

## 0. Create the `example/` Folder
```shell
mkdir example
cd example
git init
```

## 1. Create A new Flutter project (Inside `example/`)
```shell
flutter create .
```

## 2. Install lefthook_dart
```shell
flutter pub global activate lefthook_dart
```

## 3. Create `lefthook.yml` in the root of the project (`example/lefthook.yml`)
To enable Lefthook to run Dart formatting automatically before each commit, create `lefthook.yml` file in the root of your example project with the following content:
```shell
pre-commit:
  commands:
    prettify:
      glob: "*.dart"
      run: dart format --line-length 120 {staged_files} && git add {staged_files}
```

## 4. Run lefthook inside `example/` because it will modify example/.git/hooks/... to use lefthook
```shell
lefthook install
```

This configuration tells Lefthook to:
- Look for all staged .dart files before each commit
- Run dart format on them with a line length of 120
- Automatically re-add the formatted files to the Git index
### 4 Run pre-commit (optional)
```shell
lefthook run pre-commit
```

Example of output:
```text
🎉 lefthook-dart validation passed successfully! Output: All good

╭───────────────────────────────────────╮
│ 🥊 lefthook v1.12.2  hook: pre-commit │
╰───────────────────────────────────────╯
┃  prettify ❯ 

Formatted 3 files (0 changed) in 0.40 seconds.

                                      
  ────────────────────────────────────
summary: (done in 0.88 seconds)       
✔️ prettify (0.67 seconds)
```

### 5 📝 Test Pre-commit Hook with Formatting
#### 5.1 Modify a Dart file
Open any .dart file inside the example/lib/ folder and add some badly formatted code, for example:
 ```dart
void main(){print('hello world');}
 ```
### 5.2 Stage the changes
```shell
git add example/lib/main.dart
```
### 5.3 Commit the changes
```shell
git commit -m "Test pre-commit formatting hook"
```

### 5.4 Observe the pre-commit hook
The pre-commit hook will automatically run:
- dart format will reformat the staged Dart file with a line length of 120
- The formatted file will be re-added to the commit automatically
- Continue the commit process seamlessly without pausing
So your code gets formatted before the commit is finalized, ensuring consistent style.
