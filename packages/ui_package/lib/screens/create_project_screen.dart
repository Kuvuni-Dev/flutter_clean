import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:core_package/core_package.dart';
import '../services/project_service.dart';
import '../widgets/result_bar.dart';
import 'sections/project_info_section.dart';
import 'sections/icon_assets_section.dart';
import 'sections/packages_section.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _projectService = ProjectService();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _orgCtrl = TextEditingController(text: 'com.kuvuni');
  String _outputPath = '.';
  TemplateType _selectedTemplate = TemplateType.cleanArchitecture;

  // Icon
  String? _iconPath;

  // Assets
  final _assets = <String>[];

  // Packages
  static const _popularPackages = {
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
    super.dispose();
  }

  Future<void> _createProject() async {
    final result = await _projectService.createProject(
      name: _nameCtrl.text,
      description: _descCtrl.text,
      outputPath: _outputPath,
      organization: _orgCtrl.text,
      templateType: _selectedTemplate,
      iconPath: _iconPath,
      assets: List.from(_assets),
      selectedPackages: List.from(_selectedPackages),
      customPackages: List.from(_customPackages),
    );

    if (mounted) {
      setState(() {
        _creating = false;
        if (result.isSuccess) {
          _result = result.message;
        } else {
          _error = result.error;
        }
      });
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
        if (_result != null || _error != null)
          ResultBar(
            error: _error,
            result: _result,
            onDismiss: () => setState(() {
              _error = null;
              _result = null;
            }),
          ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      children: [
        ProjectInfoSection(
          nameCtrl: _nameCtrl,
          descCtrl: _descCtrl,
          outputPath: _outputPath,
          orgCtrl: _orgCtrl,
          selectedTemplate: _selectedTemplate,
          creating: _creating,
          onPickOutputDir: () async {
            final path = await ProjectService.pickDirectory(
              title: 'Seleccionar directorio de salida',
            );
            if (path != null) setState(() => _outputPath = path);
          },
          onTemplateChanged: (v) => setState(() => _selectedTemplate = v),
          onCreateProject: () {
            setState(() {
              _creating = true;
              _error = null;
              _result = null;
            });
            _createProject();
          },
        ),
        const SizedBox(height: 16),
        IconAssetsSection(
          iconPath: _iconPath,
          assets: _assets,
          onPickIcon: () async {
            final path = await ProjectService.pickImage(
              title: 'Seleccionar icono de la aplicación',
            );
            if (path != null) setState(() => _iconPath = path);
          },
          onClearIcon: () => setState(() => _iconPath = null),
          onPickAssetFolder: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Seleccionar carpeta de assets',
            );
            if (path != null) {
              final folderName = path.split(Platform.pathSeparator).last;
              setState(() => _assets.add('assets/$folderName/'));
            }
          },
          onRemoveAsset: (a) => setState(() => _assets.remove(a)),
        ),
        const SizedBox(height: 16),
        PackagesSection(
          popularPackages: _popularPackages,
          selectedPackages: _selectedPackages,
          customPackages: _customPackages,
          onTogglePackage: (key) {
            setState(() {
              if (_selectedPackages.contains(key)) {
                _selectedPackages.remove(key);
              } else {
                _selectedPackages.add(key);
              }
            });
          },
          onRemoveCustom: (p) => setState(() => _customPackages.remove(p)),
          onAddCustom: (pkg) {
            if (!_customPackages.contains(pkg)) {
              setState(() => _customPackages.add(pkg));
            }
          },
        ),
      ],
    );
  }
}
