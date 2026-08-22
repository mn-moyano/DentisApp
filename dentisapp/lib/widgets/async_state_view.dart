import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AsyncStateView extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final bool isEmpty;
  final Widget child;
  final VoidCallback? onRetry;

  const AsyncStateView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.isEmpty,
    required this.child,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: AppSpacing.iconLg,
                color: theme.colorScheme.error,
              ),

              const SizedBox(
                height: AppSpacing.sm,
              ),

              Text(
                error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
            ],
          ),
        ),
      );
    }

    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Text(
            'No hay información disponible.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return child;
  }
}