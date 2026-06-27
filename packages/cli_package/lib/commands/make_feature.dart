import 'dart:io';
import 'package:args/args.dart';
import 'package:core_package/core_package.dart';

/// Comando `make:feature` - Añade una feature con Clean Architecture a un proyecto existente.
class MakeFeatureCommand {
  void run(List<String> args) {
    final parser = ArgParser()
      ..addOption('name',
          abbr: 'n', help: 'Nombre de la feature', mandatory: true)
      ..addOption('project',
          abbr: 'p', help: 'Ruta del proyecto Flutter Clean', defaultsTo: '.')
      ..addOption('entities',
          abbr: 'e',
          help: 'Lista de entidades separadas por coma (ej: user,post,comment)',
          defaultsTo: '')
      ..addFlag('no-data',
          help: 'No incluir capa de datos', defaultsTo: false, negatable: false)
      ..addFlag('no-presentation',
          help: 'No incluir capa de presentación',
          defaultsTo: false,
          negatable: false);

    ArgResults? parsed;
    try {
      parsed = parser.parse(args);
    } catch (e) {
      print('Error: $e');
      print(
          'Uso: flutter_clean make:feature --name <feature> [--project <ruta>] [--entities <e1,e2>] [--no-data] [--no-presentation]');
      exitCode = 1;
      return;
    }

    final entitiesStr = parsed['entities'] as String;
    final entities = entitiesStr.isNotEmpty
        ? entitiesStr
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList()
        : <String>[];

    final config = FeatureConfig(
      featureName: parsed['name'] as String,
      entities: entities,
      includeDataLayer: !(parsed['no-data'] as bool),
      includePresentationLayer: !(parsed['no-presentation'] as bool),
    );

    final projectPath = parsed['project'] as String;

    // Verificar que el directorio del proyecto existe
    if (!Directory(projectPath).existsSync()) {
      print('❌ El directorio del proyecto no existe: $projectPath');
      exitCode = 1;
      return;
    }

    print(
        '🎯 Añadiendo feature "${config.featureName}" al proyecto en $projectPath...');

    if (entities.isNotEmpty) {
      print('📦 Entidades: ${entities.join(', ')}');
    }

    if (!config.includeDataLayer) {
      print('ℹ️  Capa de datos no incluida.');
    }

    if (!config.includePresentationLayer) {
      print('ℹ️  Capa de presentación no incluida.');
    }

    final generator = FeatureGenerator(
      fileSystem: FileSystem(),
      templateEngine: const TemplateEngine(),
    );

    generator.generate(projectPath, config).then((_) {
      print('✅ Feature "${config.featureName}" creada exitosamente.');
      print('📁 Añadido en $projectPath/lib/domain/');
      if (config.includeDataLayer) {
        print('📁 Añadido en $projectPath/lib/data/');
      }
      if (config.includePresentationLayer) {
        print('📁 Añadido en $projectPath/lib/presentation/');
      }
    }).catchError((error) {
      print('❌ Error al crear la feature: $error');
      exitCode = 1;
    });
  }
}
