import '../templates/project_template.dart';

class ProjectConfig {
  final String projectName;
  final String description;
  final String outputPath;
  final String organization; // ej: com.example
  final TemplateType templateType; // Tipo de plantilla a usar

  const ProjectConfig({
    required this.projectName,
    this.description = '',
    this.outputPath = '.',
    this.organization = 'com.kuvuni',
    this.templateType = TemplateType.cleanArchitecture,
  });

  // Getter útil: nombre en formato CamelCase para clases
  String get className => _toPascalCase(projectName);

  // Getter útil: nombre en snake_case para carpetas
  String get folderName => projectName.toLowerCase().replaceAll(' ', '_');

  String _toPascalCase(String name) {
    return name
        .split(RegExp(r'[ _-]'))
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join();
  }
}
