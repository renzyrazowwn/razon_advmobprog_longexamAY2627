import 'package:flutter/material.dart';

/// A reusable placeholder widget for empty, loading, and error states.
///
/// Used anywhere a screen needs to tell the user "there's nothing here
/// yet" or "something went wrong" without re-writing the same icon +
/// message + optional retry-button layout in every screen.
class CustomInfo extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const CustomInfo({
    super.key,
    this.icon = Icons.info_outline,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.all(24),
  });

  /// Convenience constructor for an empty-state message
  /// (e.g. "No posts yet.").
  const CustomInfo.empty({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.padding = const EdgeInsets.all(24),
  })  : actionLabel = null,
        onAction = null;

  /// Convenience constructor for an error state with an optional
  /// retry action.
  const CustomInfo.error({
    super.key,
    required this.message,
    this.actionLabel = 'Retry',
    required this.onAction,
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 45,
              color: Theme.of(context)
                  .iconTheme
                  .color
                  ?.withOpacity(0.6),
            ),

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
            ),

            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
