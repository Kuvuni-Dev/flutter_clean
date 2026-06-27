/// Configuración para generar una feature
class FeatureConfig {
  final String featureName;
  final List<String> entities;
  final bool includeDataLayer;
  final bool includePresentationLayer;

  const FeatureConfig({
    required this.featureName,
    this.entities = const [],
    this.includeDataLayer = true,
    this.includePresentationLayer = true,
  });

  /// Nombre en PascalCase para las clases (ej: AuthUser)
  String get className => _toPascalCase(featureName);

  /// Nombre en snake_case para carpetas (ej: auth)
  String get folderName => featureName.toLowerCase().replaceAll(' ', '_');

  String _toPascalCase(String name) {
    return name
        .split(RegExp(r'[ _-]'))
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join();
  }
}
