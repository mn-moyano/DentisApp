import 'package:flutter/material.dart';

/// Tokens primitivos de color de DentisApp.
///
/// Estos valores representan los colores base del sistema de diseño.
/// Los componentes no deberían utilizar directamente estos valores;
/// deben consumir los colores semánticos definidos por el ThemeData.
class AppColors {
  AppColors._();

  // Colores principales de la identidad visual
  // Azul petróleo
  static const Color purple900 = Color(0xFF0F4C5C);

  // Turquesa
  static const Color purple700 = Color(0xFF2A9D8F);

  // Turquesa claro
  static const Color purple500 = Color(0xFF4DB6AC);

  // Fondo suave para elementos destacados
  static const Color purple100 = Color(0xFFE0F2F1);

  // Neutros
  static const Color white = Color(0xFFFFFFFF);

  static const Color black = Color(0xFF1A1A1A);

  static const Color gray700 = Color(0xFF4A4A4A);

  static const Color gray500 = Color(0xFF757575);

  static const Color gray200 = Color(0xFFE0E0E0);

  // Fondo general de la aplicación
  static const Color gray100 = Color(0xFFF4F8F9);

  // Estados
  static const Color error = Color(0xFFB3261E);

  static const Color success = Color(0xFF2E7D32);
}