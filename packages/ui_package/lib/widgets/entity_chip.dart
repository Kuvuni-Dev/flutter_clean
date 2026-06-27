import 'package:flutter/material.dart';

class EntityChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const EntityChip({super.key, required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDelete,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
