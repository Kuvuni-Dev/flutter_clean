import 'package:flutter/material.dart';

/// Shows an AlertDialog with the given message.
void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
        ],
      ),
      content: SingleChildScrollView(child: Text(message)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}

/// Returns a suffix icon for InputDecoration that shows an AlertDialog with info.
Widget infoSuffixIcon(BuildContext context, String title, String message) {
  return GestureDetector(
    onTap: () => showInfoDialog(context, title, message),
    child: Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(
        Icons.info_outline,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
