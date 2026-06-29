import 'package:flutter/material.dart';

/// A small info icon that shows a tooltip with the given message.
class InfoTooltip extends StatelessWidget {
  final String message;

  const InfoTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: Icon(
        Icons.info_outline,
        size: 16,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Wraps a label with an optional info tooltip icon.
class LabelWithInfo extends StatelessWidget {
  final String label;
  final String? tooltip;

  const LabelWithInfo({super.key, required this.label, this.tooltip});

  @override
  Widget build(BuildContext context) {
    if (tooltip == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 4),
        InfoTooltip(message: tooltip!),
      ],
    );
  }
}
