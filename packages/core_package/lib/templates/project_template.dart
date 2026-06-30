import '../core/file_system.dart';
import '../core/template_engine.dart';

/// Tipo de arquitectura que define la estructura y generación del proyecto.
enum TemplateType {
  cleanArchitecture,
  mvc,
  mvvm,
  provider,
  riverpod,
  bloc,
  simple,
  custom,
}

/// Extensión para mostrar nombres legibles.
extension TemplateTypeDisplay on TemplateType {
  String get displayName {
    switch (this) {
      case TemplateType.cleanArchitecture:
        return 'Clean Architecture';
      case TemplateType.mvc:
        return 'MVC';
      case TemplateType.mvvm:
        return 'MVVM';
      case TemplateType.provider:
        return 'Provider';
      case TemplateType.riverpod:
        return 'Riverpod';
      case TemplateType.bloc:
        return 'BLoC';
      case TemplateType.simple:
        return 'Simple';
      case TemplateType.custom:
        return 'Custom';
    }
  }

  String get slug {
    switch (this) {
      case TemplateType.cleanArchitecture:
        return 'clean';
      case TemplateType.mvc:
        return 'mvc';
      case TemplateType.mvvm:
        return 'mvvm';
      case TemplateType.provider:
        return 'provider';
      case TemplateType.riverpod:
        return 'riverpod';
      case TemplateType.bloc:
        return 'bloc';
      case TemplateType.simple:
        return 'simple';
      case TemplateType.custom:
        return 'custom';
    }
  }

  static TemplateType fromSlug(String slug) {
    return TemplateType.values.firstWhere(
      (t) => t.slug == slug,
      orElse: () => TemplateType.cleanArchitecture,
    );
  }
}

/// Interfaz que toda plantilla de proyecto debe implementar.
///
/// Cada template define:
/// - [name] y [description] para identificación
/// - [shortDescription] texto breve para selectores y listas
/// - [directories] para la estructura de carpetas
/// - [generateCore] para los archivos base
/// - [generateInitialFeature] para la feature de ejemplo
abstract class ProjectTemplate {
  /// Nombre único del template.
  String get name;

  /// Descripción corta del template (para dropdowns, selects, listas CLI).
  String get shortDescription;

  /// Descripción larga y detallada del template (para info/ayuda).
  String get description;

  /// Tipo de template.
  TemplateType get type;

  /// Directorios a crear en la raíz del proyecto.
  List<String> directories(String basePath);

  /// Genera los archivos principales del proyecto (main, app, tema, router, etc.).
  Future<void> generateCore(
    String basePath,
    FileSystem fileSystem,
    TemplateEngine engine,
  );

  /// Genera una feature de ejemplo.
  Future<void> generateInitialFeature(
    String basePath,
    FileSystem fileSystem,
    TemplateEngine engine,
  );
}
