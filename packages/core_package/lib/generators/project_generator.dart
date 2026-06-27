import 'dart:io';
import '../core/file_system.dart';
import '../core/template_engine.dart';
import '../models/project_config.dart';

/// Genera un proyecto Flutter completo con Clean Architecture.
class ProjectGenerator {
  final FileSystem fileSystem;
  final TemplateEngine templateEngine;

  ProjectGenerator({
    required this.fileSystem,
    required this.templateEngine,
  });

  /// Genera el proyecto completo a partir de la configuración.
  /// Primero ejecuta `flutter create --empty` para generar la base,
  /// luego superpone la estructura Clean Architecture.
  Future<void> generate(ProjectConfig config) async {
    final engine = templateEngine.merge({
      'projectName': config.projectName,
      'className': config.className,
      'description': config.description,
      'organization': config.organization,
    });

    final projectDir = '${config.outputPath}/${config.folderName}';

    print(
        '🚀 Ejecutando flutter create --empty para "${config.projectName}"...');

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
        projectDir
      ],
      runInShell: true,
    );

    if (result.exitCode != 0) {
      throw Exception('Error al ejecutar flutter create:\n'
          '${result.stderr}');
    }

    print('✅ Proyecto Flutter base creado.');
    print('🔧 Aplicando estructura Clean Architecture...');

    // 2. Crear directorios extra de Clean Architecture
    await _createCleanArchDirs(projectDir);

    // 3. Sobrescribir main.dart con versión Clean Architecture
    await _generateMainFile(projectDir, engine);

    // 4. Generar un ejemplo de feature inicial
    await _generateInitialFeature(projectDir, engine);
  }

  Future<void> _createCleanArchDirs(String basePath) async {
    final dirs = [
      '$basePath/lib/core',
      '$basePath/lib/data/datasources',
      '$basePath/lib/data/models',
      '$basePath/lib/data/repositories',
      '$basePath/lib/domain/entities',
      '$basePath/lib/domain/repositories',
      '$basePath/lib/domain/usecases',
      '$basePath/lib/presentation/pages',
      '$basePath/lib/presentation/widgets',
      '$basePath/lib/presentation/providers',
      // Features dir - cada feature será autocontenida
      '$basePath/lib/features',
    ];

    for (final dir in dirs) {
      await fileSystem.createDirectories(dir);
    }
  }

  Future<void> _generateMainFile(String basePath, TemplateEngine engine) async {
    await fileSystem.writeFile(
      '$basePath/lib/main.dart',
      engine.render('''
import 'package:flutter/material.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const {{className}}App());
}

class {{className}}App extends StatelessWidget {
  const {{className}}App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '{{projectName}}',
      home: const HomePage(),
    );
  }
}
'''),
    );

    // home_page.dart básico
    await fileSystem.writeFile(
      '$basePath/lib/presentation/pages/home_page.dart',
      engine.render('''
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('{{projectName}}')),
      body: const Center(
        child: Text('Clean Architecture Project'),
      ),
    );
  }
}
'''),
    );
  }

  Future<void> _generateInitialFeature(
      String basePath, TemplateEngine engine) async {
    final featureName = 'auth';
    final folderName = 'auth';
    final className = 'Auth';

    final featureEngine = engine.merge({
      'featureName': featureName,
      'className': className,
      'folderName': folderName,
    });

    final featurePath = '$basePath/lib/features/$folderName';

    // Crear estructura de directorios de la feature
    final dirs = [
      '$featurePath/domain/entities',
      '$featurePath/domain/repositories',
      '$featurePath/domain/usecases',
      '$featurePath/data/models',
      '$featurePath/data/repositories',
      '$featurePath/presentation/pages',
    ];
    for (final dir in dirs) {
      await fileSystem.createDirectories(dir);
    }

    // Entidad
    await fileSystem.writeFile(
      '$featurePath/domain/entities/${folderName}_user.dart',
      featureEngine.render('''
class {{className}}User {
  final String id;
  final String email;

  const {{className}}User({required this.id, required this.email});
}
'''),
    );

    // Repositorio abstracto
    await fileSystem.writeFile(
      '$featurePath/domain/repositories/${folderName}_repository.dart',
      featureEngine.render('''
import '../entities/${folderName}_user.dart';

abstract class {{className}}Repository {
  Future<{{className}}User> login(String email, String password);
}
'''),
    );

    // Use case
    await fileSystem.writeFile(
      '$featurePath/domain/usecases/login_${folderName}_usecase.dart',
      featureEngine.render('''
import '../repositories/${folderName}_repository.dart';

class Login{{className}}UseCase {
  final {{className}}Repository repository;

  Login{{className}}UseCase({required this.repository});

  Future<{{className}}User> call(String email, String password) {
    return repository.login(email, password);
  }
}
'''),
    );

    // Modelo
    await fileSystem.writeFile(
      '$featurePath/data/models/${folderName}_model.dart',
      featureEngine.render('''
class {{className}}Model {
  final String id;
  final String email;

  const {{className}}Model({required this.id, required this.email});

  factory {{className}}Model.fromJson(Map<String, dynamic> json) {
    return {{className}}Model(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
'''),
    );

    // Repositorio impl
    await fileSystem.writeFile(
      '$featurePath/data/repositories/${folderName}_repository_impl.dart',
      featureEngine.render('''
import '../../domain/entities/${folderName}_user.dart';
import '../../domain/repositories/${folderName}_repository.dart';

class {{className}}RepositoryImpl implements {{className}}Repository {
  @override
  Future<{{className}}User> login(String email, String password) async {
    // TODO: implementar llamada a API
    return {{className}}User(id: '1', email: email);
  }
}
'''),
    );

    // Página básica
    await fileSystem.writeFile(
      '$featurePath/presentation/pages/${folderName}_page.dart',
      featureEngine.render('''
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
}
