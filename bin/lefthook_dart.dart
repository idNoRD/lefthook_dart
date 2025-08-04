import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:system_info3/system_info3.dart';

const lefthookVersion = '1.12.2';
const pubspecVersion = '1.0.7'; // @TODO generate using build runner

void main(List<String> args) async {
  final logger = Logger.standard();

  // if flutter installed using snap it tries to use git from snap that is old and not supported by lefthook
  // as a solution we change PATH to pick git from /usr/bin instead of old git version from snap
  String environmentThatIncludesGit = !Platform.isWindows
      ? '/usr/bin:${Platform.environment['PATH']}'
      : '${Platform.environment['PATH']}';

  final whichGit = await Process.run(
    !Platform.isWindows ? 'which' : 'where',
    ['git'],
    environment: {'PATH': environmentThatIncludesGit},
  );
  logger.stdout('[lefthook_dart] is using git located at ${whichGit.stdout}');

  final gitVersion = await Process.run(
    'git',
    ['version'],
    environment: {'PATH': environmentThatIncludesGit},
  );

  logger.stdout('[lefthook_dart] gitVersion=${gitVersion.stdout}');

  final projectDir = Directory.current.path;
  logger.stdout('[lefthook_dart] DEBUG projectDir=$projectDir');

  final executablePath = Platform.script
      .resolve('../.exec/lefthook')
      .toFilePath();

  logger.stdout(
    'lefthook_dart v$pubspecVersion is using lefthook v$lefthookVersion at: $executablePath',
  );
  await _ensureExecutable(
    executablePath,
    projectDir,
    environmentThatIncludesGit,
  );

  final validateResult = await Process.run(
    executablePath,
    ['validate'],
    workingDirectory: projectDir,
    environment: {'PATH': environmentThatIncludesGit},
  );
  if (validateResult.exitCode == 0) {
    logger.stdout(
      '🎉 lefthook_dart validation passed successfully! Output: ${validateResult.stdout}',
    );
  } else {
    logger.stderr(
      '⚠️ lefthook_dart validation failed.\n'
      'stderr Output:\n${validateResult.stderr}',
    );
    logger.stdout('stdout Output:\n${validateResult.stdout}');
    exit(validateResult.exitCode);
  }

  final result = await Process.run(
    executablePath,
    args,
    workingDirectory: projectDir,
    environment: {'PATH': environmentThatIncludesGit},
    stdoutEncoding: utf8,
    stderrEncoding: utf8,
  );
  if (result.exitCode != 0) {
    logger.stderr(
      '❌ lefthook_dart failed.\n'
      'Details:\n${result.stdout}\n${result.stderr}',
    );
    exit(result.exitCode);
  } else {
    logger.stdout(result.stdout);
  }
}

Future<void> _ensureExecutable(
  String targetPath,
  String projectDir,
  String environmentThatIncludesGit, {
  bool force = false,
}) async {
  Logger logger = Logger.standard();

  final fileAlreadyExist = await _isExecutableExist(targetPath);
  if (fileAlreadyExist && !force) {
    return;
  }

  final url = _resolveDownloadUrl(logger);

  logger.stdout('Download executable for lefthook...');
  logger.stdout(url);

  final file = await _downloadFile(url);

  logger.stdout('Download complete');
  logger.stdout('');
  logger.stdout('Extracting...');

  final extracted = _extractFile(file);

  logger.stdout('Extracted');
  logger.stdout('');
  logger.stdout('Saving executable file...');
  await _saveFile(targetPath, extracted);

  logger.stdout('Saved to $targetPath');
  logger.stdout('');

  await _installLefthook(
    targetPath,
    projectDir,
    environmentThatIncludesGit,
    logger,
  );

  logger.stdout('All done!');
}

String _resolveDownloadUrl(Logger logger) {
  String getOS() {
    if (Platform.isLinux) {
      logger.stdout("Platform: Linux");
      return 'Linux';
    }

    if (Platform.isMacOS) {
      logger.stdout("Platform: MacOS");
      return 'MacOS';
    }

    if (Platform.isWindows) {
      logger.stdout("Platform: Windows");
      return 'Windows';
    }

    throw Error();
  }

  String getArchitecture(Logger logger) {
    final ProcessorArchitecture arch = SysInfo.kernelArchitecture;
    final rawArch = SysInfo.rawKernelArchitecture;

    // Windows does not return x86_64 for some reason,
    // so also check if rawArch is amd64
    if ('x86_64' == arch.name.toLowerCase() ||
        'amd64' == rawArch.toLowerCase()) {
      logger.stdout("Architecture: x86_64");
      return 'x86_64';
    }

    // TODO: check for i386

    throw Error();
  }

  final os = getOS();
  final architecture = getArchitecture(logger);

  return 'https://github.com/Arkweid/lefthook/releases/download/v$lefthookVersion/lefthook_${lefthookVersion}_${os}_$architecture.gz';
}

Future<List<int>> _downloadFile(String url) async {
  HttpClient client = HttpClient();
  final request = await client.getUrl(Uri.parse(url));
  final response = await request.close();

  final downloadData = List<int>.empty(growable: true);
  final completer = Completer();
  response.listen((d) => downloadData.addAll(d), onDone: completer.complete);
  await completer.future;

  return downloadData;
}

List<int> _extractFile(List<int> downloadedData) {
  return GZipDecoder().decodeBytes(downloadedData);
}

Future<void> _saveFile(String targetPath, List<int> data) async {
  Future<void> makeExecutable(File file) async {
    final windowsUser = Platform.isWindows
        ? await Process.run(
            "whoami",
            [],
          ).then((value) => value.stdout.toString().trim())
        : null;

    final result = !Platform.isWindows
        ? await Process.run("chmod", ["u+x", file.path])
        : await Process.run("icacls", [
            file.path,
            "/grant:r",
            "${windowsUser!}:(RX)",
          ]);

    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }
  }

  final executableFile = File(targetPath);
  await executableFile.create(recursive: true);
  await executableFile.writeAsBytes(data);
  await makeExecutable(executableFile);
}

Future<void> _installLefthook(
  String executablePath,
  String projectDir,
  String environmentThatIncludesGit,
  Logger logger,
) async {
  logger.stdout(
    '[lefthook_dart] DEBUG Executing lefthook install in workingDirectory=$projectDir',
  );
  final result = await Process.run(
    executablePath,
    ["install" /*'-f'*/],
    workingDirectory: projectDir,
    environment: {'PATH': environmentThatIncludesGit},
  );

  if (result.exitCode != 0) {
    logger.stderr(result.stderr);
    throw Exception(result.stderr);
  }

  logger.stdout(result.stdout);
}

Future<bool> _isExecutableExist(String executablePath) async {
  return File(executablePath).exists();
}
