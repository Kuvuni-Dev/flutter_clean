import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';

/// Result of a project creation operation.
class ProjectResult {
  final String? error;
  final String? message;

  const ProjectResult({this.error, this.message});

  bool get isSuccess => error == null && message != null;
  bool get isError => error != null;
}

/// Service that handles project creation logic.
class ProjectService {
  final FileSystem _fs;
  final TemplateEngine _engine;

  ProjectService() : _fs = FileSystem(), _engine = const TemplateEngine();

  /// Creates a new Flutter project with the given configuration.
  Future<ProjectResult> createProject({
    required String name,
    required String description,
    required String outputPath,
    required String organization,
    required TemplateType templateType,
    String? iconPath,
    List<String> assets = const [],
    List<String> selectedPackages = const [],
    List<String> customPackages = const [],
  }) async {
    if (name.trim().isEmpty) {
      return const ProjectResult(
        error: 'El nombre del proyecto es obligatorio',
      );
    }

    try {
      final generator = ProjectGenerator(
        fileSystem: _fs,
        templateEngine: _engine,
      );

      await generator.generate(
        ProjectConfig(
          projectName: name,
          description: description,
          outputPath: outputPath,
          organization: organization,
          templateType: templateType,
        ),
      );

      final projectFolder =
          '$outputPath/${name.toLowerCase().replaceAll(' ', '_')}';

      // Copy icon if selected
      if (iconPath != null) {
        final dest = '$projectFolder/lib/assets/icon.png';
        await _fs.createDirectories('$projectFolder/lib/assets');
        await _fs.copyFile(iconPath, dest);
      }

      // Add assets to pubspec.yaml
      if (assets.isNotEmpty) {
        final pubspecPath = '$projectFolder/pubspec.yaml';
        final pubspec = await _fs.readFile(pubspecPath);
        final assetsList = assets.map((a) => '    - $a').join('\n');
        final updated = pubspec.replaceFirst(
          'uses-material-design: true',
          'uses-material-design: true\n  assets:\n$assetsList',
        );
        await _fs.writeFile(pubspecPath, updated);
      }

      // Install selected packages
      final allPackages = [...selectedPackages, ...customPackages];
      if (allPackages.isNotEmpty) {
        for (final pkg in allPackages) {
          await Process.run(
            'flutter',
            ['pub', 'add', pkg],
            workingDirectory: projectFolder,
            runInShell: true,
          );
        }
      }

      final message = StringBuffer()
        ..writeln('Proyecto "$name" creado exitosamente.')
        ..writeln('📁 $projectFolder');
      if (iconPath != null) message.writeln('🖼️ Icono añadido');
      if (assets.isNotEmpty) {
        message.writeln('📦 ${assets.length} asset(s) configurados');
      }
      if (allPackages.isNotEmpty) {
        message.writeln('📦 ${allPackages.length} paquete(s) instalados');
      }

      return ProjectResult(message: message.toString().trim());
    } catch (e) {
      return ProjectResult(error: e.toString());
    }
  }

  /// Picks a directory using the file picker.
  static Future<String?> pickDirectory({String? title}) async {
    return await FilePicker.platform.getDirectoryPath(
      dialogTitle: title ?? 'Seleccionar directorio',
    );
  }

  /// Picks an image file.
  static Future<String?> pickImage({String? title}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: title ?? 'Seleccionar imagen',
    );
    return result?.files.single.path;
  }
}
