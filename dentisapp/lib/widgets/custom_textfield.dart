import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Campo de texto reutilizable de DentisApp.
///
/// Permite configurar el contenido, tipo de teclado, estado habilitado
/// y cantidad de líneas sin depender de una entidad o pantalla específica.
class CustomTextField extends StatelessWidget {
  /// Controlador utilizado para gestionar el contenido del campo.
  final TextEditingController controller;

  /// Etiqueta descriptiva del campo.
  final String label;

  /// Tipo de teclado que se mostrará al usuario.
  final TextInputType keyboardType;

  /// Determina si el campo permite interacción.
  final bool enabled;

  /// Cantidad máxima de líneas visibles.
  final int maxLines;

  /// Callback opcional cuando cambia el contenido.
  final ValueChanged<String>? onChanged;

  /// Texto de ayuda para tecnologías de asistencia.
  final String? semanticLabel;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
      ),
      child: Semantics(
        label: semanticLabel ?? label,
        textField: true,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ),
    );
  }
}