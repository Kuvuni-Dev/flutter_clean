/// Motor de templates simple basado en reemplazo de strings.
class TemplateEngine {
  /// Conjunto de pares clave-valor para reemplazar en las plantillas.
  final Map<String, String> variables;

  const TemplateEngine({this.variables = const {}});

  /// Renderiza un template reemplazando {{variable}} por su valor.
  /// Ejemplo: "class {{className}} {" → "class MiProyecto {"
  String render(String template) {
    String result = template;
    for (final entry in variables.entries) {
      result = result.replaceAll('{{${entry.key}}}', entry.value);
    }
    return result;
  }

  /// Renderiza múltiples templates y devuelve una lista con los resultados.
  List<String> renderAll(List<String> templates) {
    return templates.map(render).toList();
  }

  /// Crea una nueva instancia con variables adicionales.
  TemplateEngine merge(Map<String, String> extraVariables) {
    return TemplateEngine(
      variables: {...variables, ...extraVariables},
    );
  }
}
