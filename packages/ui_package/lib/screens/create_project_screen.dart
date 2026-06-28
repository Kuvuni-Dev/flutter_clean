import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';
import '../widgets/form_section.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _orgCtrl = TextEditingController(text: 'com.kuvuni');
  String _outputPath = '.';
  TemplateType _selectedTemplate = TemplateType.cleanArchitecture;

  // Icono de la app
  String? _iconPath;

  // Assets
  final _assets = <String>[];
  final _assetFolderCtrl = TextEditingController();

  // Paquetes populares
  final _popularPackages = {
    'dio': 'Cliente HTTP',
    'riverpod': 'Manejo de estado',
    'go_router': 'Navegación',
    'shared_preferences': 'Preferencias locales',
    'flutter_secure_storage': 'Almacenamiento seguro',
    'hive': 'Base de datos local',
    'freezed': 'Clases inmutables',
    'json_annotation': 'Serialización JSON',
    'flutter_local_notifications': 'Notificaciones',
    'cached_network_image': 'Imágenes en caché',
    'firebase_core': 'Firebase core',
    'firebase_auth': 'Firebase Auth',
    'cloud_firestore': 'Firestore DB',
    'firebase_storage': 'Firebase Storage',
    'intl': 'Internacionalización',
    'equatable': 'Comparación de objetos',
  };
  final _selectedPackages = <String>{};
  final _customPackages = <String>[];

  bool _creating = false;
  String? _result;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _orgCtrl.dispose();
    _assetFolderCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickOutputDir() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar directorio de salida',
    );
    if (path != null) setState(() => _outputPath = path);
  }

  Future<void> _pickAppIcon() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Seleccionar icono de la aplicación',
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _iconPath = result.files.single.path);
    }
  }

  Future<void> _pickAssetFolder() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar carpeta de assets',
    );
    if (path != null) {
      final folderName = path.split(Platform.pathSeparator).last;
      setState(() => _assets.add('assets/$folderName/'));
    }
  }

  Future<void> _createProject() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'El nombre del proyecto es obligatorio');
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
      final generator = ProjectGenerator(
        fileSystem: fs,
        templateEngine: engine,
      );

      await generator.generate(
        ProjectConfig(
          projectName: name,
          description: _descCtrl.text.trim(),
          outputPath: _outputPath,
          organization: _orgCtrl.text.trim(),
          templateType: _selectedTemplate,
        ),
      );

      final projectFolder =
          '$_outputPath/${name.toLowerCase().replaceAll(' ', '_')}';

      // Copiar icono si se seleccionó
      if (_iconPath != null) {
        final dest = '$projectFolder/lib/assets/icon.png';
        await fs.createDirectories('$projectFolder/lib/assets');
        await fs.copyFile(_iconPath!, dest);
      }

      // Añadir assets al pubspec.yaml si hay
      if (_assets.isNotEmpty) {
        final pubspecPath = '$projectFolder/pubspec.yaml';
        final pubspec = await fs.readFile(pubspecPath);
        final assetsList = _assets.map((a) => '    - $a').join('\n');
        final updated = pubspec.replaceFirst(
          'uses-material-design: true',
          'uses-material-design: true\n  assets:\n$assetsList',
        );
        await fs.writeFile(pubspecPath, updated);
      }

      // Añadir paquetes seleccionados
      final allPackages = [..._selectedPackages, ..._customPackages];
      if (allPackages.isNotEmpty) {
        for (final pkg in allPackages) {
          await Process.run(
            'flutter',
            ['pub', 'add', pkg],
            workingDirectory: projectFolder,
            runInShell: true,
          );
        }
      }

      if (mounted) {
        setState(() {
          _result =
              'Proyecto "$name" creado exitosamente.\n'
              '📁 $projectFolder\n'
              '${_iconPath != null ? "🖼️ Icono añadido\n" : ""}'
              '${_assets.isNotEmpty ? "📦 ${_assets.length} asset(s) configurados\n" : ""}'
              '${allPackages.isNotEmpty ? "📦 ${allPackages.length} paquete(s) instalados" : ""}';
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
                constraints: const BoxConstraints(maxWidth: 800),
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
    return Column(
      children: [
        _buildProjectInfoForm(theme),
        const SizedBox(height: 16),
        _buildIconAndAssetsForm(theme),
        const SizedBox(height: 16),
        _buildPackagesForm(theme),
      ],
    );
  }

  Widget _buildProjectInfoForm(ThemeData theme) {
    return FormSection(
      title: 'Información del Proyecto',
      icon: Icons.info_outline,
      children: [
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            labelText: 'Nombre del proyecto *',
            hintText: 'ej: mi_app',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descCtrl,
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
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Directorio de salida',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_open),
                ),
                child: Text(_outputPath, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickOutputDir,
              icon: const Icon(Icons.folder),
              tooltip: 'Seleccionar carpeta',
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _orgCtrl,
          decoration: const InputDecoration(
            labelText: 'Organización',
            hintText: 'com.kuvuni',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TemplateType>(
          initialValue: _selectedTemplate,
          decoration: const InputDecoration(
            labelText: 'Plantilla / Arquitectura',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.category),
          ),
          items: TemplateRegistry().allTemplates.map((t) {
            return DropdownMenuItem(
              value: t.type,
              child: Text('${t.name} - ${t.description}'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedTemplate = value);
            }
          },
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
                : const Icon(Icons.rocket_launch),
            label: Text(_creating ? 'Creando...' : 'Crear Proyecto'),
          ),
        ),
      ],
    );
  }

  Widget _buildIconAndAssetsForm(ThemeData theme) {
    return FormSection(
      title: 'Icono y Assets',
      icon: Icons.image_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Icono de la app (PNG)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                ),
                child: Text(
                  _iconPath?.split(Platform.pathSeparator).last ?? 'Ninguno',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickAppIcon,
              icon: const Icon(Icons.image_search),
              tooltip: 'Seleccionar icono',
            ),
            if (_iconPath != null)
              IconButton(
                onPressed: () => setState(() => _iconPath = null),
                icon: const Icon(Icons.clear),
                tooltip: 'Quitar icono',
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Assets (carpetas)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_special),
                ),
                child: Text(
                  _assets.isNotEmpty
                      ? '${_assets.length} carpeta(s) seleccionada(s)'
                      : 'Ninguno',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickAssetFolder,
              icon: const Icon(Icons.add),
              tooltip: 'Añadir carpeta de assets',
            ),
          ],
        ),
        if (_assets.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _assets
                .map(
                  (a) => Chip(
                    label: Text(a, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _assets.remove(a)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          'El icono se copiará en lib/assets/ y los assets se añadirán al pubspec.yaml automáticamente.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesForm(ThemeData theme) {
    return FormSection(
      title: 'Paquetes Populares',
      icon: Icons.inventory_2_outlined,
      children: [
        Text(
          'Selecciona los paquetes que quieras pre-instalar en el proyecto:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _popularPackages.entries.map((entry) {
            final selected = _selectedPackages.contains(entry.key);
            return FilterChip(
              label: Text(entry.key, style: const TextStyle(fontSize: 12)),
              tooltip: entry.value,
              selected: selected,
              onSelected: (v) {
                setState(() {
                  if (v) {
                    _selectedPackages.add(entry.key);
                  } else {
                    _selectedPackages.remove(entry.key);
                  }
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        if (_customPackages.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Paquetes personalizados:'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _customPackages
                .map(
                  (p) => Chip(
                    label: Text(p),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _customPackages.remove(p)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Añadir paquete personalizado',
                  hintText: 'ej: package_name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_box),
                ),
                onSubmitted: (v) {
                  final pkg = v.trim();
                  if (pkg.isNotEmpty && !_customPackages.contains(pkg)) {
                    setState(() => _customPackages.add(pkg));
                  }
                },
              ),
            ),
          ],
        ),
        if (_selectedPackages.isNotEmpty || _customPackages.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${_selectedPackages.length + _customPackages.length} paquete(s) serán instalados con flutter pub add',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}
