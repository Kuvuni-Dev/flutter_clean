import 'package:flutter/material.dart';

/// A reusable result/error bar that appears at the bottom of a screen.
/// Shows either an error message or a success message with a close button.
class ResultBar extends StatelessWidget {
  final String? error;
  final String? result;
  final VoidCallback? onDismiss;

  const ResultBar({super.key, this.error, this.result, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    if (error == null && result == null) return const SizedBox.shrink();

    final isError = error != null;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: isError
          ? theme.colorScheme.errorContainer
          : theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError
                ? theme.colorScheme.onErrorContainer
                : theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isError ? error! : result!,
              style: TextStyle(
                color: isError
                    ? theme.colorScheme.onErrorContainer
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onDismiss ?? () {},
          ),
        ],
      ),
    );
  }
}
