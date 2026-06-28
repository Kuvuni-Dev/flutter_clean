import 'dart:io';
import 'package:args/args.dart';
import 'package:core_package/core_package.dart';

/// Comando `create` - Crea un nuevo proyecto Flutter con la plantilla seleccionada.
class CreateProjectCommand {
  void run(List<String> args) {
    // Obtener lista de templates disponibles para el mensaje de ayuda
    final templates = TemplateRegistry().allTemplates;
    final templateOptions = templates.map((t) => '${t.type.slug} (${t.name})').join(', ');

    final parser = ArgParser()
      ..addOption('name',
          abbr: 'n', help: 'Nombre del proyecto', mandatory: true)
      ..addOption('description',
          abbr: 'd', help: 'Descripción del proyecto', defaultsTo: '')
      ..addOption('output',
          abbr: 'o', help: 'Directorio de salida', defaultsTo: '.')
      ..addOption('organization',
          abbr: 'g',
          help: 'Organización (ej: com.example)',
          defaultsTo: 'com.kuvuni')
      ..addOption('template',
          abbr: 't',
          help: 'Plantilla a usar: $templateOptions',
          defaultsTo: 'clean');

    ArgResults? parsed;
    try {
      parsed = parser.parse(args);
    } catch (e) {
      print('Error: $e');
      print('Uso: flutter_clean create --name <nombre> '
          '[--description <desc>] [--output <dir>] '
          '[--organization <org>] [--template <plantilla>]');
      print('');
      print('Plantillas disponibles:');
      for (final t in templates) {
        print('  ${t.type.slug.padRight(12)} ${t.name} - ${t.description}');
      }
      exitCode = 1;
      return;
    }

    final templateSlug = parsed['template'] as String;
    TemplateType templateType;
    try {
      templateType = TemplateTypeDisplay.fromSlug(templateSlug);
    } catch (e) {
      print('❌ Plantilla no válida: "$templateSlug"');
      print('Plantillas disponibles:');
      for (final t in templates) {
        print('  ${t.type.slug.padRight(12)} ${t.name}');
      }
      exitCode = 1;
      return;
    }

    final config = ProjectConfig(
      projectName: parsed['name'] as String,
      description: parsed['description'] as String,
      outputPath: parsed['output'] as String,
      organization: parsed['organization'] as String,
      templateType: templateType,
    );

    final template = TemplateRegistry().getTemplate(templateType);

    print(
        '🎯 Creando proyecto "${config.projectName}" en ${config.outputPath}/${config.folderName}...');
    print('📐 Template: ${template.name}');

    final generator = ProjectGenerator(
      fileSystem: FileSystem(),
      templateEngine: const TemplateEngine(),
    );

    generator.generate(config).then((_) {
      print('✅ Proyecto "${config.projectName}" creado exitosamente.');
      print('📁 Ruta: ${config.outputPath}/${config.folderName}');
      print('📐 Template: ${template.name}');
      print('');
      print('Para añadir una feature:');
      print('  cd ${config.outputPath}/${config.folderName}');
      print('  flutter_clean make:feature --name <feature_name>');
    }).catchError((error) {
      print('❌ Error al crear el proyecto: $error');
      exitCode = 1;
    });
  }
}
