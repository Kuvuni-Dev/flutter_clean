import '../core/file_system.dart';
import '../core/template_engine.dart';
import '../models/feature_config.dart';

/// Añade una feature autocontenida dentro de `lib/features/{featureName}/`
/// Cada feature tiene sus propias capas domain, data y presentation.
class FeatureGenerator {
  final FileSystem fileSystem;
  final TemplateEngine templateEngine;

  FeatureGenerator({
    required this.fileSystem,
    required this.templateEngine,
  });

  /// Genera la feature dentro del proyecto en [projectPath] bajo `lib/features/`.
  Future<void> generate(String projectPath, FeatureConfig config) async {
    final engine = templateEngine.merge({
      'featureName': config.featureName,
      'className': config.className,
      'folderName': config.folderName,
    });

    final folderName = config.folderName;
    final className = config.className;
    final featureRoot = '$projectPath/lib/features/$folderName';

    // Crear directorios de la feature
    final dirs = [
      '$featureRoot/domain/entities',
      '$featureRoot/domain/repositories',
      '$featureRoot/domain/usecases',
      '$featureRoot/data/models',
      '$featureRoot/data/repositories',
      '$featureRoot/presentation/pages',
    ];
    for (final dir in dirs) {
      await fileSystem.createDirectories(dir);
    }

    // 1. Capa domain
    await _generateDomainLayer(
        featureRoot, folderName, className, config, engine);

    // 2. Capa data
    if (config.includeDataLayer) {
      await _generateDataLayer(featureRoot, folderName, className, engine);
    }

    // 3. Capa presentation
    if (config.includePresentationLayer) {
      await _generatePresentationLayer(
          featureRoot, folderName, className, engine);
    }
  }

  Future<void> _generateDomainLayer(String featureRoot, String folderName,
      String className, FeatureConfig config, TemplateEngine engine) async {
    final domainPath = '$featureRoot/domain';

    // Entidades
    final entities = config.entities.isNotEmpty
        ? config.entities
        : [
            className
          ]; // Si no hay entidades, usar la feature como entidad por defecto

    for (final entity in entities) {
      final entityEngine = engine.merge({
        'entityName': entity,
        'entityClassName': _toPascalCase(entity),
      });

      await fileSystem.writeFile(
        '$domainPath/entities/${entity.toLowerCase()}.dart',
        entityEngine.render('''
class {{entityClassName}} {
  final String id;

  const {{entityClassName}}({required this.id});
}
'''),
      );
    }

    final firstEntity = entities.first;
    final firstEntityLowerCase = firstEntity.toLowerCase();

    // Repositorio abstracto
    await fileSystem.writeFile(
      '$domainPath/repositories/${folderName}_repository.dart',
      engine.merge({'firstEntity': firstEntityLowerCase}).render('''
import '../entities/{{firstEntity}}.dart';

abstract class {{className}}Repository {
  Future<List<{{className}}>> getAll();
}
'''),
    );

    // Use case
    await fileSystem.writeFile(
      '$domainPath/usecases/get_${folderName}_usecase.dart',
      engine.render('''
import '../repositories/${folderName}_repository.dart';

class Get{{className}}UseCase {
  final {{className}}Repository repository;

  Get{{className}}UseCase({required this.repository});

  Future<List<{{className}}>> call() {
    return repository.getAll();
  }
}
'''),
    );
  }

  Future<void> _generateDataLayer(String featureRoot, String folderName,
      String className, TemplateEngine engine) async {
    final dataPath = '$featureRoot/data';

    // Modelo
    await fileSystem.writeFile(
      '$dataPath/models/${folderName}_model.dart',
      engine.render('''
class {{className}}Model {
  final String id;

  const {{className}}Model({required this.id});

  factory {{className}}Model.fromJson(Map<String, dynamic> json) {
    return {{className}}Model(id: json['id'] as String);
  }

  Map<String, dynamic> toJson() => {'id': id};
}
'''),
    );

    // Repositorio impl
    await fileSystem.writeFile(
      '$dataPath/repositories/${folderName}_repository_impl.dart',
      engine.render('''
import '../../domain/entities/${folderName}.dart';
import '../../domain/repositories/${folderName}_repository.dart';

class {{className}}RepositoryImpl implements {{className}}Repository {
  @override
  Future<List<{{className}}>> getAll() async {
    // TODO: implementar llamada a API o base de datos
    return [];
  }
}
'''),
    );
  }

  Future<void> _generatePresentationLayer(String featureRoot, String folderName,
      String className, TemplateEngine engine) async {
    final presentationPath = '$featureRoot/presentation';

    // Página básica
    await fileSystem.writeFile(
      '$presentationPath/pages/${folderName}_page.dart',
      engine.render('''
import 'package:flutter/material.dart';

class {{className}}Page extends StatelessWidget {
  const {{className}}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{featureName}}')),
      body: const Center(
        child: Text('{{featureName}} Feature'),
      ),
    );
  }
}
'''),
    );
  }

  String _toPascalCase(String name) {
    return name
        .split(RegExp(r'[ _-]'))
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join();
  }
}
