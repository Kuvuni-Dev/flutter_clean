import 'package:flutter/material.dart';
import 'package:core_package/core_package.dart';
import '../../widgets/form_section.dart';

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
          decoration: const InputDecoration(
            labelText: 'Nombre del proyecto *',
            hintText: 'ej: mi_app',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: descCtrl,
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
          decoration: const InputDecoration(
            labelText: 'Organización',
            hintText: 'com.kuvuni',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TemplateType>(
          value: selectedTemplate,
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
