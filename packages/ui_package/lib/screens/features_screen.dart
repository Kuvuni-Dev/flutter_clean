import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';
import '../widgets/form_section.dart';
import '../widgets/entity_chip.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  final _featureNameCtrl = TextEditingController();
  String _projectPath = '.';
  final _entityCtrl = TextEditingController();
  final _entities = <String>[];
  bool _includeDataLayer = true;
  bool _includePresentation = true;

  bool _creating = false;
  String? _result;
  String? _error;

  @override
  void dispose() {
    _featureNameCtrl.dispose();
    _entityCtrl.dispose();
    super.dispose();
  }

  void _addEntity() {
    final name = _entityCtrl.text.trim();
    if (name.isNotEmpty && !_entities.contains(name)) {
      setState(() {
        _entities.add(name);
        _entityCtrl.clear();
      });
    }
  }

  Future<void> _pickProjectDir() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar carpeta del proyecto Flutter Clean',
    );
    if (path != null) setState(() => _projectPath = path);
  }

  Future<void> _createFeature() async {
    final name = _featureNameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'El nombre de la feature es obligatorio');
      return;
    }

    setState(() {
      _creating = true;
      _error = null;
      _result = null;
    });

    try {
      final fs = FileSystem();
      final engine = const TemplateEngine();
      final generator = FeatureGenerator(
        fileSystem: fs,
        templateEngine: engine,
      );

      await generator.generate(
        _projectPath,
        FeatureConfig(
          featureName: name,
          entities: List.from(_entities),
          includeDataLayer: _includeDataLayer,
          includePresentationLayer: _includePresentation,
        ),
      );

      if (mounted) {
        setState(() {
          _result = 'Feature "$name" añadida exitosamente.';
          _creating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _creating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: _buildContent(theme),
              ),
            ),
          ),
        ),
        if (_result != null || _error != null) _buildResultBar(theme),
      ],
    );
  }

  Widget _buildResultBar(ThemeData theme) {
    final isError = _error != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: isError
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isError ? _error! : _result!,
              style: TextStyle(
                color: isError
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() {
              _error = null;
              _result = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return FormSection(
      title: 'Añadir Nueva Feature',
      icon: Icons.widgets,
      children: [
        TextField(
          controller: _featureNameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre de la feature *',
            hintText: 'ej: auth',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.label),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ruta del proyecto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder),
                ),
                child: Text(_projectPath, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickProjectDir,
              icon: const Icon(Icons.folder),
              tooltip: 'Seleccionar carpeta del proyecto',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _entityCtrl,
                decoration: const InputDecoration(
                  labelText: 'Entidad',
                  hintText: 'user',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.data_object),
                ),
                onSubmitted: (_) => _addEntity(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addEntity,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (_entities.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _entities
                .map(
                  (e) => EntityChip(
                    label: e,
                    onDelete: () => setState(() => _entities.remove(e)),
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Incluir capa de datos'),
          subtitle: const Text('Modelos y repositorio con fromJson/toJson'),
          value: _includeDataLayer,
          onChanged: (v) => setState(() => _includeDataLayer = v!),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Incluir capa de presentación'),
          subtitle: const Text('Página Flutter básica de la feature'),
          value: _includePresentation,
          onChanged: (v) => setState(() => _includePresentation = v!),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: _creating ? null : _createFeature,
            icon: _creating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_box),
            label: Text(_creating ? 'Creando...' : 'Añadir Feature'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: _pickProjectDir,
            icon: const Icon(Icons.folder_open),
            label: const Text('Cambiar carpeta del proyecto'),
          ),
        ),
      ],
    );
  }
}
