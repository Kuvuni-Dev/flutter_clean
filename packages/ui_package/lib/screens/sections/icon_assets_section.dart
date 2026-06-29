import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/form_section.dart';

/// Section for configuring app icon and assets.
class IconAssetsSection extends StatelessWidget {
  final String? iconPath;
  final List<String> assets;
  final VoidCallback onPickIcon;
  final VoidCallback onClearIcon;
  final VoidCallback onPickAssetFolder;
  final ValueChanged<String> onRemoveAsset;

  const IconAssetsSection({
    super.key,
    this.iconPath,
    required this.assets,
    required this.onPickIcon,
    required this.onClearIcon,
    required this.onPickAssetFolder,
    required this.onRemoveAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  iconPath?.split(Platform.pathSeparator).last ?? 'Ninguno',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onPickIcon,
              icon: const Icon(Icons.image_search),
              tooltip: 'Seleccionar icono',
            ),
            if (iconPath != null)
              IconButton(
                onPressed: onClearIcon,
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
                  assets.isNotEmpty
                      ? '${assets.length} carpeta(s) seleccionada(s)'
                      : 'Ninguno',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onPickAssetFolder,
              icon: const Icon(Icons.add),
              tooltip: 'Añadir carpeta de assets',
            ),
          ],
        ),
        if (assets.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: assets
                .map(
                  (a) => Chip(
                    label: Text(a, style: const TextStyle(fontSize: 12)),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onRemoveAsset(a),
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
}
