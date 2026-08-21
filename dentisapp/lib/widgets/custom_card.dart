import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Tarjeta reutilizable de DentisApp.
///
/// El contenido se recibe mediante [child], lo que permite utilizar
/// el componente en diferentes módulos de la aplicación sin acoplarlo
/// a una entidad o pantalla específica.
class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppRadius.md,
        ),
      ),
      child: child,
    );
  }
}