import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';
import '../widgets/form_section.dart';
import '../widgets/entity_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Proyecto ---
  final _projectNameCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _outputPathCtrl = TextEditingController(text: '.');
  final _organizationCtrl = TextEditingController(text: 'com.kuvuni');

  // --- Feature ---
  final _featureNameCtrl = TextEditingController();
  String _projectPath = '.';
  final _entityCtrl = TextEditingController();
  final _entities = <String>[];
  bool _includeDataLayer = true;
  bool _includePresentation = true;

  // --- Estado ---
  bool _creating = false;
  String? _lastOutput;
  String? _error;

  @override
  void dispose() {
    _projectNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _outputPathCtrl.dispose();
    _organizationCtrl.dispose();
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

  Future<void> _createProject() async {
    final name = _projectNameCtrl.text.trim();
    if (name.isEmpty) {
      _showError('El nombre del proyecto es obligatorio');
      return;
    }

    setState(() {
      _creating = true;
      _error = null;
      _lastOutput = null;
    });

    try {
      final fs = FileSystem();
      final engine = const TemplateEngine();
      final generator = ProjectGenerator(
        fileSystem: fs,
        templateEngine: engine,
      );

      await generator.generate(
        ProjectConfig(
          projectName: name,
          description: _descriptionCtrl.text.trim(),
          outputPath: _outputPathCtrl.text,
          organization: _organizationCtrl.text.trim(),
        ),
      );

      if (mounted) {
        setState(() {
          _lastOutput =
              'Proyecto "$name" creado exitosamente en '
              '${_outputPathCtrl.text}/${name.toLowerCase().replaceAll(' ', '_')}';
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

  Future<void> _createFeature() async {
    final name = _featureNameCtrl.text.trim();
    if (name.isEmpty) {
      _showError('El nombre de la feature es obligatorio');
      return;
    }

    setState(() {
      _creating = true;
      _error = null;
      _lastOutput = null;
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
          _lastOutput = 'Feature "$name" añadida exitosamente.';
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

  void _showError(String msg) {
    setState(() => _error = msg);
  }

  Future<void> _pickOutputDirectory() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar directorio de salida',
    );
    if (path != null) {
      _outputPathCtrl.text = path;
    }
  }

  Future<void> _pickProjectDirectory() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar carpeta del proyecto Flutter Clean',
    );
    if (path != null) {
      setState(() => _projectPath = path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Clean Generator'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
                ),
              ),
            ),
          ),
          if (_error != null || _lastOutput != null) _buildResultBar(theme),
        ],
      ),
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
              isError ? _error! : _lastOutput!,
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
              _lastOutput = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildProjectForm()),
        const SizedBox(width: 16),
        Expanded(child: _buildFeatureForm()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildProjectForm(),
        const SizedBox(height: 8),
        _buildFeatureForm(),
      ],
    );
  }

  Widget _buildProjectForm() {
    return FormSection(
      title: 'Crear Proyecto',
      icon: Icons.create_new_folder,
      children: [
        TextField(
          controller: _projectNameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre del proyecto *',
            hintText: 'ej: mi_app',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionCtrl,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            hintText: 'Breve descripción del proyecto',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                child: TextField(
                  controller: _outputPathCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Directorio de salida',
                    hintText: '.',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.folder_open),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickOutputDirectory,
              icon: const Icon(Icons.folder),
              tooltip: 'Seleccionar carpeta',
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _organizationCtrl,
          decoration: const InputDecoration(
            labelText: 'Organización',
            hintText: 'com.kuvuni',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: _creating ? null : _createProject,
            icon: _creating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.play_arrow),
            label: Text(_creating ? 'Creando...' : 'Crear Proyecto'),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureForm() {
    return FormSection(
      title: 'Añadir Feature',
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
                child: Text(
                  _projectPath,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickProjectDirectory,
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
            onPressed: _pickProjectDirectory,
            icon: const Icon(Icons.folder_open),
            label: const Text('Cambiar carpeta del proyecto'),
          ),
        ),
      ],
    );
  }
}
