import 'project_template.dart';
import 'clean_architecture_template.dart';
import 'mvc_template.dart';
import 'mvvm_template.dart';
import 'provider_template.dart';
import 'riverpod_template.dart';
import 'bloc_template.dart';
import 'simple_template.dart';

/// Registro central de todas las plantillas disponibles.
///
/// Permite obtener una plantilla por tipo, listar todas las disponibles,
/// y registrar plantillas personalizadas en tiempo de ejecución.
class TemplateRegistry {
  static final TemplateRegistry _instance = TemplateRegistry._internal();
  factory TemplateRegistry() => _instance;
  TemplateRegistry._internal() {
    _registerBuiltIn();
  }

  final Map<TemplateType, ProjectTemplate> _templates = {};

  void _registerBuiltIn() {
    final builtIn = <ProjectTemplate>[
      CleanArchitectureTemplate(),
      MvcTemplate(),
      MvvmTemplate(),
      ProviderTemplate(),
      RiverpodTemplate(),
      BlocTemplate(),
      SimpleTemplate(),
    ];
    for (final template in builtIn) {
      _templates[template.type] = template;
    }
  }

  /// Obtiene un template por su tipo.
  ProjectTemplate getTemplate(TemplateType type) {
    if (!_templates.containsKey(type)) {
      throw ArgumentError('Template not found: $type');
    }
    return _templates[type]!;
  }

  /// Obtiene un template por su slug.
  ProjectTemplate getTemplateBySlug(String slug) {
    final type = TemplateTypeDisplay.fromSlug(slug);
    return getTemplate(type);
  }

  /// Lista todos los templates registrados.
  List<ProjectTemplate> get allTemplates => _templates.values.toList();

  /// Registra un template personalizado en tiempo de ejecución.
  void register(ProjectTemplate template) {
    _templates[template.type] = template;
  }

  /// Elimina un template registrado.
  void unregister(TemplateType type) {
    _templates.remove(type);
  }
}