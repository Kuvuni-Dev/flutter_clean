import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  bool _checkingFlutter = false;
  String? _flutterVersion;
  String? _flutterDoctor;

  bool _installingPkg = false;
  String? _pkgResult;

  String _modifyProjectPath = '.';

  /// Elimina códigos ANSI de color del output de terminal.
  String _stripAnsi(String text) {
    return text.replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '');
  }

  /// Decodifica bytes crudos como UTF-8, ignorando errores de codificación.
  /// Esto evita que Windows malinterprete los caracteres Unicode usando
  /// la code page del sistema (CP-1252/CP-437).
  String _decodeUtf8Safe(List<int> bytes) {
    return utf8.decode(bytes, allowMalformed: true);
  }

  Future<void> _checkFlutter() async {
    setState(() {
      _checkingFlutter = true;
      _flutterVersion = null;
      _flutterDoctor = null;
    });

    try {
      // Leer bytes crudos (stdoutEncoding: null) para evitar que Windows
      // decodifique con la code page del sistema en lugar de UTF-8.
      final versionResult = await Process.run(
        'flutter',
        ['--version', '--no-color'],
        runInShell: true,
        stdoutEncoding: null,
        stderrEncoding: null,
      );

      final doctorResult = await Process.run(
        'flutter',
        ['doctor', '--no-color'],
        runInShell: true,
        stdoutEncoding: null,
        stderrEncoding: null,
      );

      if (mounted) {
        // Decodificar los bytes crudos explícitamente como UTF-8
        String versionOut = _decodeUtf8Safe(
          (versionResult.stdout as List<int>?) ?? [],
        );
        String doctorOut = _decodeUtf8Safe(
          (doctorResult.stdout as List<int>?) ?? [],
        );

        // Stripear cualquier código ANSI residual
        versionOut = _stripAnsi(versionOut);
        doctorOut = _stripAnsi(doctorOut);

        // Limpiar espacios múltiples
        versionOut = versionOut.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
        doctorOut = doctorOut.replaceAll(RegExp(r'[ \t]+'), ' ').trim();

        setState(() {
          _flutterVersion = versionOut;
          _flutterDoctor = doctorOut;
          _checkingFlutter = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _flutterVersion = null;
          _flutterDoctor = 'Error al ejecutar flutter: $e';
          _checkingFlutter = false;
        });
      }
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
              // --- Verificar Flutter ---
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Verificar instalación de Flutter',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _checkingFlutter ? null : _checkFlutter,
                          icon: _checkingFlutter
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.monitor_heart),
                          label: Text(
                            _checkingFlutter
                                ? 'Verificando...'
                                : 'Ejecutar flutter doctor',
                          ),
                        ),
                      ),
                      if (_flutterVersion != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SelectableText(
                            _flutterVersion!,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                      if (_flutterDoctor != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: SingleChildScrollView(
                            child: SelectableText(
                              _flutterDoctor!,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // --- Instalar paquete ---
              _buildInstallPackageCard(theme),

              // --- Modificar proyecto existente ---
              _buildModifyProjectCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallPackageCard(ThemeData theme) {
    final pkgCtrl = TextEditingController();
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pkgCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del paquete',
                      hintText: 'ej: dio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    onSubmitted: (v) {
                      if (v.trim().isNotEmpty) _installPackage(v.trim());
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Carpeta del proyecto',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.folder),
                    ),
                    child: Text(
                      _modifyProjectPath,
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
                      setState(() => _modifyProjectPath = path);
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
                onPressed: _installingPkg
                    ? null
                    : () {
                        final pkg = pkgCtrl.text.trim();
                        if (pkg.isNotEmpty) _installPackage(pkg);
                      },
                icon: _installingPkg
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  _installingPkg ? 'Instalando...' : 'Instalar paquete',
                ),
              ),
            ),
            if (_pkgResult != null) ...[
              const SizedBox(height: 8),
              Text(
                _pkgResult!,
                style: TextStyle(
                  color: _pkgResult!.contains('Error')
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

  Future<void> _installPackage(String package) async {
    setState(() {
      _installingPkg = true;
      _pkgResult = null;
    });

    try {
      final result = await Process.run(
        'flutter',
        ['pub', 'add', package],
        workingDirectory: _modifyProjectPath,
        runInShell: true,
      );

      if (mounted) {
        setState(() {
          _pkgResult = result.exitCode == 0
              ? '✅ Paquete "$package" instalado correctamente.'
              : '❌ Error: ${result.stderr}';
          _installingPkg = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pkgResult = '❌ Error: $e';
          _installingPkg = false;
        });
      }
    }
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
