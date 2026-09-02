import 'package:flutter/material.dart';

class CustomInfo extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  // Enhancement 2
  // base constructor for info message widget
  const CustomInfo({
    super.key,
    this.icon = Icons.info_outline,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.all(24),
  });

  // constructor for empty state message
  const CustomInfo.empty({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.padding = const EdgeInsets.all(24),
  })  : actionLabel = null,
        onAction = null;

  // constructor for error state message
  const CustomInfo.error({
    super.key,
    required this.message,
    this.actionLabel = 'Retry',
    required this.onAction,
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.all(24),
  });

  // builds custom info status widget
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
