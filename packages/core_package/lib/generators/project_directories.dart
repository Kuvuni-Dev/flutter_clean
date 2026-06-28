import '../core/file_system.dart';

/// Crea toda la estructura de directorios del proyecto Clean Architecture.
Future<void> createCleanArchDirs(String basePath, FileSystem fileSystem) async {
  final dirs = [
    // Assets en la raíz del proyecto
    '$basePath/assets/images',
    '$basePath/assets/fonts',
    '$basePath/assets/icons',
    // Core compartido
    '$basePath/lib/core/constants',
    '$basePath/lib/core/errors',
    '$basePath/lib/core/network',
    '$basePath/lib/core/theme',
    '$basePath/lib/core/router',
    '$basePath/lib/core/utils',
    // App (configuración general)
    '$basePath/lib/app',
    // Features raíz
    '$basePath/lib/features',
  ];

  for (final dir in dirs) {
    await fileSystem.createDirectories(dir);
  }
}

/// Crea los directorios internos de una feature autocontenida.
Future<void> createFeatureDirs(
    String featurePath, FileSystem fileSystem) async {
  final dirs = [
    '$featurePath/data/datasources',
    '$featurePath/data/models',
    '$featurePath/data/repositories',
    '$featurePath/domain/entities',
    '$featurePath/domain/repositories',
    '$featurePath/domain/usecases',
    '$featurePath/presentation/controllers',
    '$featurePath/presentation/pages',
    '$featurePath/presentation/widgets',
  ];

  for (final dir in dirs) {
    await fileSystem.createDirectories(dir);
  }
}
