import 'package:flutter/material.dart';
import 'package:core_package/core_package.dart';
import '../../widgets/form_section.dart';
import '../../widgets/info_tooltip.dart';

/// Section for entering basic project information.
class ProjectInfoSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final String outputPath;
  final TextEditingController orgCtrl;
  final TemplateType selectedTemplate;
  final bool creating;
  final VoidCallback onPickOutputDir;
  final ValueChanged<TemplateType> onTemplateChanged;
  final VoidCallback onCreateProject;

  const ProjectInfoSection({
    super.key,
    required this.nameCtrl,
    required this.descCtrl,
    required this.outputPath,
    required this.orgCtrl,
    required this.selectedTemplate,
    required this.creating,
    required this.onPickOutputDir,
    required this.onTemplateChanged,
    required this.onCreateProject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FormSection(
      title: 'Información del Proyecto',
      icon: Icons.info_outline,
      children: [
        TextField(
          controller: nameCtrl,
          decoration: InputDecoration(
            labelText: 'Nombre del proyecto *',
            hintText: 'ej: mi_app',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.edit),
            suffixIcon: infoSuffixIcon(
              context,
              'Nombre del proyecto',
              'Nombre único para tu proyecto Flutter. Se usará como identificador en pubspec.yaml.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: descCtrl,
          decoration: InputDecoration(
            labelText: 'Descripción',
            hintText: 'Breve descripción del proyecto',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.description),
            suffixIcon: infoSuffixIcon(
              context,
              'Descripción',
              'Breve descripción del propósito de tu proyecto. Aparecerá en el pubspec.yaml.',
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Directorio de salida',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.folder_open),
                  suffixIcon: infoSuffixIcon(
                    context,
                    'Directorio de salida',
                    'Carpeta donde se creará el proyecto. Debe ser una ruta vacía o nueva.',
                  ),
                ),
                child: Text(outputPath, overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onPickOutputDir,
              icon: const Icon(Icons.folder),
              tooltip: 'Seleccionar carpeta',
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: orgCtrl,
          decoration: InputDecoration(
            labelText: 'Organización',
            hintText: 'com.kuvuni',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.business),
            suffixIcon: infoSuffixIcon(
              context,
              'Organización',
              'Identificador de tu organización en formato inverso (ej: com.kuvuni). Se usa para el bundle ID en Android y iOS.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TemplateType>(
          value: selectedTemplate,
          decoration: InputDecoration(
            labelText: 'Plantilla / Arquitectura',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.category),
            suffixIcon: infoSuffixIcon(
              context,
              'Plantilla / Arquitectura',
              'Arquitectura base del proyecto. Clean Architecture es la recomendada para proyectos escalables.',
            ),
          ),
          items: TemplateRegistry().allTemplates.map((t) {
            return DropdownMenuItem(
              value: t.type,
              child: Text('${t.name} - ${t.description}'),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onTemplateChanged(value);
          },
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton.icon(
            onPressed: creating ? null : onCreateProject,
            icon: creating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.rocket_launch),
            label: Text(creating ? 'Creando...' : 'Crear Proyecto'),
          ),
        ),
      ],
    );
  }
}
