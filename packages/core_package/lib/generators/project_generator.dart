import 'dart:io';
import '../core/file_system.dart';
import '../core/template_engine.dart';
import '../models/project_config.dart';
import '../templates/template_registry.dart';

/// Genera un proyecto Flutter completo usando una plantilla.
///
/// Orquesta el proceso en 4 pasos:
/// 1. Ejecuta `flutter create --empty` para la base
/// 2. Crea la estructura de directorios según el template
/// 3. Genera los archivos core (main, app, router, theme, etc.)
/// 4. Genera la feature "bio" de ejemplo
class ProjectGenerator {
  final FileSystem fileSystem;
  final TemplateEngine templateEngine;

  ProjectGenerator({
    required this.fileSystem,
    required this.templateEngine,
  });

  /// Genera el proyecto completo a partir de la configuración.
  Future<void> generate(ProjectConfig config) async {
    final engine = templateEngine.merge({
      'projectName': config.projectName,
      'className': config.className,
      'description': config.description,
      'organization': config.organization,
    });

    final projectDir = '${config.outputPath}/${config.folderName}';

    // Obtener el template según la configuración
    final template = TemplateRegistry().getTemplate(config.templateType);

    print(
        '🚀 Ejecutando flutter create --empty para "${config.projectName}"...');
    print('📐 Template: ${template.name} - ${template.description}');

    // 1. Ejecutar flutter create --empty para generar el proyecto base
    final result = await Process.run(
      'flutter',
      [
        'create',
        '--empty',
        '--project-name',
        config.folderName,
        '--org',
        config.organization,
        projectDir,
      ],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      throw Exception('Error al ejecutar flutter create:\n'
          '${result.stderr}');
    }

    print('✅ Proyecto Flutter base creado.');
    print('🔧 Aplicando estructura ${template.name}...');

    // 2. Crear directorios definidos por el template
    for (final dir in template.directories(projectDir)) {
      await fileSystem.createDirectories(dir);
    }

    // 3. Generar archivos core según el template
    await template.generateCore(projectDir, fileSystem, engine);

    // 4. Generar feature de ejemplo según el template
    await template.generateInitialFeature(projectDir, fileSystem, engine);

    print('✅ Proyecto "${config.projectName}" creado con template ${template.name}.');
  }
}