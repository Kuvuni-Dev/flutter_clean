import 'package:flutter/material.dart';
import '../../widgets/form_section.dart';
import '../../widgets/entity_chip.dart';
import '../../widgets/info_tooltip.dart';

/// Form section for creating a new feature.
class FeatureFormSection extends StatelessWidget {
  final TextEditingController featureNameCtrl;
  final String projectPath;
  final TextEditingController entityCtrl;
  final List<String> entities;
  final bool includeDataLayer;
  final bool includePresentation;
  final bool creating;
  final VoidCallback onPickProjectDir;
  final VoidCallback onAddEntity;
  final ValueChanged<String> onRemoveEntity;
  final ValueChanged<bool> onToggleDataLayer;
  final ValueChanged<bool> onTogglePresentation;
  final VoidCallback onCreateFeature;

  const FeatureFormSection({
    super.key,
    required this.featureNameCtrl,
    required this.projectPath,
    required this.entityCtrl,
    required this.entities,
    required this.includeDataLayer,
    required this.includePresentation,
    required this.creating,
    required this.onPickProjectDir,
    required this.onAddEntity,
    required this.onRemoveEntity,
    required this.onToggleDataLayer,
    required this.onTogglePresentation,
    required this.onCreateFeature,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormSection(
      title: 'Añadir Nueva Feature',
      icon: Icons.widgets,
      children: [
        TextField(
          controller: featureNameCtrl,
          decoration: InputDecoration(
            labelText: 'Nombre de la feature *',
            hintText: 'ej: auth',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(Icons.label),
            suffixIcon: infoSuffixIcon(
              context,
              'Nombre de la feature',
              'Nombre del módulo o funcionalidad (ej: auth, users, products). Se usará para crear las carpetas y archivos.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Ruta del proyecto',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder),
                  suffixIcon: infoSuffixIcon(
                    context,
                    'Ruta del proyecto',
                    'Carpeta raíz del proyecto Flutter Clean donde se añadirá la nueva feature.',
                  ),
                ),
                child: Text(projectPath, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onPickProjectDir,
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
                controller: entityCtrl,
                decoration: InputDecoration(
                  labelText: 'Entidad',
                  hintText: 'user',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.data_object),
                  suffixIcon: infoSuffixIcon(
                    context,
                    'Entidad',
                    'Nombre de la entidad/modelo principal de la feature (ej: user, product, order). Se generarán sus archivos de modelo y repositorio.',
                  ),
                ),
                onSubmitted: (_) => onAddEntity(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onAddEntity,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (entities.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: entities
                .map(
                  (e) =>
                      EntityChip(label: e, onDelete: () => onRemoveEntity(e)),
                )
                .toList(),
          ),
        ],
        const SizedBox(height: 12),
        CheckboxListTile(
          title: const Text('Incluir capa de datos'),
          subtitle: const Text('Modelos y repositorio con fromJson/toJson'),
          value: includeDataLayer,
          onChanged: (v) => onToggleDataLayer(v!),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Incluir capa de presentación'),
          subtitle: const Text('Página Flutter básica de la feature'),
          value: includePresentation,
          onChanged: (v) => onTogglePresentation(v!),
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: creating ? null : onCreateFeature,
            icon: creating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_box),
            label: Text(creating ? 'Creando...' : 'Añadir Feature'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onPickProjectDir,
            icon: const Icon(Icons.folder_open),
            label: const Text('Cambiar carpeta del proyecto'),
          ),
        ),
      ],
    );
  }
}
