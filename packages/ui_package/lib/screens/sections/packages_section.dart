import 'package:flutter/material.dart';
import '../../widgets/form_section.dart';
import '../../widgets/info_tooltip.dart';

/// Section for selecting and adding packages to the project.
class PackagesSection extends StatelessWidget {
  final Map<String, String> popularPackages;
  final Set<String> selectedPackages;
  final List<String> customPackages;
  final ValueChanged<String> onTogglePackage;
  final ValueChanged<String> onRemoveCustom;
  final ValueChanged<String> onAddCustom;

  const PackagesSection({
    super.key,
    required this.popularPackages,
    required this.selectedPackages,
    required this.customPackages,
    required this.onTogglePackage,
    required this.onRemoveCustom,
    required this.onAddCustom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          children: popularPackages.entries.map((entry) {
            final selected = selectedPackages.contains(entry.key);
            return FilterChip(
              label: Text(entry.key, style: const TextStyle(fontSize: 12)),
              tooltip: entry.value,
              selected: selected,
              onSelected: (v) => onTogglePackage(entry.key),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
        if (customPackages.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text('Paquetes personalizados:'),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: customPackages
                .map(
                  (p) => Chip(
                    label: Text(p),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => onRemoveCustom(p),
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
                decoration: InputDecoration(
                  label: const LabelWithInfo(
                    label: 'Añadir paquete personalizado',
                    tooltip:
                        'Nombre de un paquete Dart/Flutter de pub.dev que quieras instalar en el proyecto.',
                  ),
                  hintText: 'ej: package_name',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.add_box),
                ),
                onSubmitted: (v) {
                  final pkg = v.trim();
                  if (pkg.isNotEmpty) onAddCustom(pkg);
                },
              ),
            ),
          ],
        ),
        if (selectedPackages.isNotEmpty || customPackages.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '${selectedPackages.length + customPackages.length} paquete(s) serán instalados con flutter pub add',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}
