import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';

/// Result of a feature creation operation.
class FeatureResult {
  final String? error;
  final String? message;

  const FeatureResult({this.error, this.message});

  bool get isSuccess => error == null && message != null;
  bool get isError => error != null;
}

/// Service that handles feature creation logic.
class FeatureService {
  final FileSystem _fs;
  final TemplateEngine _engine;

  FeatureService() : _fs = FileSystem(), _engine = const TemplateEngine();

  /// Creates a new feature in an existing Flutter Generator project.
  Future<FeatureResult> createFeature({
    required String featureName,
    required String projectPath,
    required List<String> entities,
    required bool includeDataLayer,
    required bool includePresentation,
  }) async {
    if (featureName.trim().isEmpty) {
      return const FeatureResult(
        error: 'El nombre de la feature es obligatorio',
      );
    }

    try {
      final generator = FeatureGenerator(
        fileSystem: _fs,
        templateEngine: _engine,
      );

      await generator.generate(
        projectPath,
        FeatureConfig(
          featureName: featureName,
          entities: List.from(entities),
          includeDataLayer: includeDataLayer,
          includePresentationLayer: includePresentation,
        ),
      );

      return FeatureResult(
        message: 'Feature "$featureName" añadida exitosamente.',
      );
    } catch (e) {
      return FeatureResult(error: e.toString());
    }
  }

  /// Picks a project directory using the file picker.
  static Future<String?> pickProjectDirectory({String? title}) async {
    return await FilePicker.platform.getDirectoryPath(
      dialogTitle:
          title ?? 'Seleccionar carpeta del proyecto Flutter Generator',
    );
  }
}
