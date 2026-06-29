import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../main.dart';
import '../widgets/settings_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _defaultOutputPath = '.';
  final _orgCtrl = TextEditingController(text: 'com.kuvuni');

  @override
  void dispose() {
    _orgCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDefaultOutput() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Seleccionar directorio de salida por defecto',
    );
    if (path != null) setState(() => _defaultOutputPath = path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppearanceCard(theme),
              _buildDefaultsCard(theme),
              _buildInfoCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppearanceCard(ThemeData theme) {
    return SettingsCard(
      icon: Icons.palette_outlined,
      title: 'Apariencia',
      children: [
        Row(
          children: [
            const Text('Tema de la aplicación'),
            const Spacer(),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Claro'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Oscuro'),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.settings_brightness),
                  label: Text('Sistema'),
                ),
              ],
              selected: {themeModeNotifier.value},
              onSelectionChanged: (value) {
                themeModeNotifier.value = value.first;
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefaultsCard(ThemeData theme) {
    return SettingsCard(
      icon: Icons.tune_outlined,
      title: 'Valores por defecto',
      children: [
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Directorio de salida por defecto',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder_open),
                ),
                child: Text(
                  _defaultOutputPath,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _pickDefaultOutput,
              icon: const Icon(Icons.folder),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _orgCtrl,
          decoration: const InputDecoration(
            labelText: 'Organización por defecto',
            hintText: 'com.kuvuni',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return SettingsCard(
      icon: Icons.info_outline,
      title: 'Información',
      children: [
        _buildInfoRow('Versión', '0.1.0'),
        const SizedBox(height: 8),
        _buildInfoRow('SDK requerido', 'Dart ≥3.12.0'),
        const SizedBox(height: 8),
        _buildInfoRow('Flutter requerido', '≥3.0.0'),
        const SizedBox(height: 8),
        _buildInfoRow('Plataformas', 'Windows, macOS, Linux'),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Text(
          'Flutter Clean Generator te permite crear proyectos Flutter con Clean Architecture de forma visual.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          '✅ Creado con Dart y Flutter como herramienta educativa.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    );
  }
}
