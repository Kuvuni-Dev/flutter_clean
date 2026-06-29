import 'dart:convert';
import 'dart:io';

/// Result of checking Flutter installation.
class FlutterCheckResult {
  final String? version;
  final String? doctorOutput;
  final String? error;

  const FlutterCheckResult({this.version, this.doctorOutput, this.error});

  bool get isSuccess => error == null;
}

/// Result of installing a package.
class PackageInstallResult {
  final String message;

  const PackageInstallResult(this.message);

  bool get isSuccess => message.startsWith('✅');
}

/// Service for interacting with Flutter CLI tools.
class FlutterToolsService {
  /// Strips ANSI color codes from terminal output.
  String _stripAnsi(String text) {
    return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '');
  }

  /// Decodes raw bytes as UTF-8 safely.
  String _decodeUtf8Safe(List<int> bytes) {
    return utf8.decode(bytes, allowMalformed: true);
  }

  /// Runs flutter --version and flutter doctor.
  Future<FlutterCheckResult> checkFlutterInstallation() async {
    try {
      final versionResult = await Process.run(
        'flutter',
        ['--version', '--no-color'],
        runInShell: true,
        stdoutEncoding: null,
        stderrEncoding: null,
      );

      final doctorResult = await Process.run(
        'flutter',
        ['doctor', '--no-color'],
        runInShell: true,
        stdoutEncoding: null,
        stderrEncoding: null,
      );

      String versionOut = _decodeUtf8Safe(
        (versionResult.stdout as List<int>?) ?? [],
      );
      String doctorOut = _decodeUtf8Safe(
        (doctorResult.stdout as List<int>?) ?? [],
      );

      versionOut = _stripAnsi(versionOut);
      doctorOut = _stripAnsi(doctorOut);

      versionOut = versionOut.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
      doctorOut = doctorOut.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

      return FlutterCheckResult(version: versionOut, doctorOutput: doctorOut);
    } catch (e) {
      return FlutterCheckResult(error: 'Error al ejecutar flutter: $e');
    }
  }

  /// Installs a Flutter package in the given project path.
  Future<PackageInstallResult> installPackage({
    required String package,
    required String projectPath,
  }) async {
    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'add', package],
        workingDirectory: projectPath,
        runInShell: true,
      );

      return PackageInstallResult(
        result.exitCode == 0
            ? '✅ Paquete "$package" instalado correctamente.'
            : '❌ Error: ${result.stderr}',
      );
    } catch (e) {
      return PackageInstallResult('❌ Error: $e');
    }
  }
}
