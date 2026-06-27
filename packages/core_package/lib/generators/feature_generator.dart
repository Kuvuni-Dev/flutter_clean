import '../core/file_system.dart';
import '../core/template_engine.dart';
import '../models/feature_config.dart';

/// Añade una feature con Clean Architecture a un proyecto existente.
class FeatureGenerator {
  final FileSystem fileSystem;
  final TemplateEngine templateEngine;

  FeatureGenerator({
    required this.fileSystem,
    required this.templateEngine,
  });

  /// Genera la feature dentro del proyecto en [projectPath].
  Future<void> generate(String projectPath, FeatureConfig config) async {
    final engine = templateEngine.merge({
      'featureName': config.featureName,
      'className': config.className,
      'folderName': config.folderName,
    });

    final featurePath = '$projectPath/lib';
    final folderName = config.folderName;
    final className = config.className;

    // 1. Capa domain: entidad + repositorio abstracto + use case
    await _generateDomainLayer(
        featurePath, folderName, className, config, engine);

    // 2. Capa data: modelo + implementación del repositorio
    if (config.includeDataLayer) {
      await _generateDataLayer(featurePath, folderName, className, engine);
    }

    // 3. Capa presentation: página básica
    if (config.includePresentationLayer) {
      await _generatePresentationLayer(
          featurePath, folderName, className, engine);
    }
  }

  Future<void> _generateDomainLayer(String basePath, String folderName,
      String className, FeatureConfig config, TemplateEngine engine) async {
    final domainPath = '$basePath/domain';

    // Entidad principal de la feature
    final entities = config.entities.isNotEmpty
        ? config.entities
        : [
            config.className
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

    // Determinar el nombre de la primera entidad para las referencias
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

    // Use case base
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

  Future<void> _generateDataLayer(String basePath, String folderName,
      String className, TemplateEngine engine) async {
    final dataPath = '$basePath/data';

    // Modelo (extiende la entidad)
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

    // Implementación del repositorio
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

  Future<void> _generatePresentationLayer(String basePath, String folderName,
      String className, TemplateEngine engine) async {
    final presentationPath = '$basePath/presentation';

    // Página básica de la feature
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
