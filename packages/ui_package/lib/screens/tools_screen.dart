import 'package:flutter/material.dart';
import '../services/flutter_tools_service.dart';
import 'sections/flutter_check_section.dart';
import 'sections/install_package_section.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  final _toolsService = FlutterToolsService();
  bool _checkingFlutter = false;
  String? _flutterVersion;
  String? _flutterDoctor;
  String _modifyProjectPath = '.';

  Future<void> _checkFlutter() async {
    setState(() {
      _checkingFlutter = true;
      _flutterVersion = null;
      _flutterDoctor = null;
    });

    final result = await _toolsService.checkFlutterInstallation();

    if (mounted) {
      setState(() {
        _flutterVersion = result.version;
        _flutterDoctor = result.doctorOutput;
        _checkingFlutter = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlutterCheckSection(
                checkingFlutter: _checkingFlutter,
                flutterVersion: _flutterVersion,
                flutterDoctor: _flutterDoctor,
                onCheckFlutter: _checkFlutter,
              ),
              InstallPackageSection(
                projectPath: _modifyProjectPath,
                onProjectPathChanged: (path) =>
                    setState(() => _modifyProjectPath = path),
              ),
              _buildModifyProjectCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModifyProjectCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.edit_note, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Modificar proyecto existente',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Usa la pestaña "Features" para añadir nuevas funcionalidades con Clean Architecture a tu proyecto.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'También puedes usar la terminal desde esta app:',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const SelectableText(
                '# Navegar al proyecto\ncd ruta/del/proyecto\n\n# Añadir feature\ndart run flutter_clean_cli:flutter_clean make:feature --name auth\n\n# Instalar paquete\nflutter pub add dio',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
