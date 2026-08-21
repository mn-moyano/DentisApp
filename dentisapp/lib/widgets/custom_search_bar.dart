import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Barra de búsqueda reutilizable de DentisApp.
///
/// El componente se limita a representar el campo de búsqueda y notificar
/// los cambios de texto. No conoce el backend ni decide cómo se realiza
/// la búsqueda.
class CustomSearchBar extends StatelessWidget {
  /// Controlador utilizado para gestionar el contenido del campo.
  final TextEditingController controller;

  /// Texto mostrado como ayuda dentro del campo.
  final String hint;

  /// Callback ejecutado cuando cambia el texto.
  final ValueChanged<String>? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}