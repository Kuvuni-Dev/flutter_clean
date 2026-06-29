import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../widgets/info_tooltip.dart';

/// Card for installing a Flutter package in an existing project.
class InstallPackageSection extends StatefulWidget {
  final String projectPath;
  final ValueChanged<String> onProjectPathChanged;

  const InstallPackageSection({
    super.key,
    required this.projectPath,
    required this.onProjectPathChanged,
  });

  @override
  State<InstallPackageSection> createState() => _InstallPackageSectionState();
}

class _InstallPackageSectionState extends State<InstallPackageSection> {
  final _pkgCtrl = TextEditingController();
  bool _installing = false;
  String? _result;

  @override
  void dispose() {
    _pkgCtrl.dispose();
    super.dispose();
  }

  Future<void> _installPackage() async {
    final package = _pkgCtrl.text.trim();
    if (package.isEmpty) return;

    setState(() {
      _installing = true;
      _result = null;
    });

    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'add', package],
        workingDirectory: widget.projectPath,
        runInShell: true,
      );

      if (mounted) {
        setState(() {
          _result = result.exitCode == 0
              ? '✅ Paquete "$package" instalado correctamente.'
              : '❌ Error: ${result.stderr}';
          _installing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _result = '❌ Error: $e';
          _installing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_box_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Instalar paquete en proyecto existente',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pkgCtrl,
              decoration: InputDecoration(
                labelText: 'Nombre del paquete',
                hintText: 'ej: dio',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_2),
                suffixIcon: infoSuffixIcon(
                  context,
                  'Nombre del paquete',
                  'Nombre exacto del paquete en pub.dev (ej: dio, riverpod, go_router).',
                ),
              ),
              onSubmitted: (_) => _installPackage(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Carpeta del proyecto',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.folder),
                      suffixIcon: infoSuffixIcon(
                        context,
                        'Carpeta del proyecto',
                        'Ruta del proyecto Flutter donde se instalará el paquete.',
                      ),
                    ),
                    child: Text(
                      widget.projectPath,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () async {
                    final path = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: 'Seleccionar carpeta del proyecto',
                    );
                    if (path != null) {
                      widget.onProjectPathChanged(path);
                    }
                  },
                  icon: const Icon(Icons.folder),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _installing ? null : _installPackage,
                icon: _installing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(_installing ? 'Instalando...' : 'Instalar paquete'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 8),
              Text(
                _result!,
                style: TextStyle(
                  color: _result!.contains('Error')
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
