import 'package:flutter/material.dart';

/// Tokens primitivos de color de DentisApp.
///
/// Estos valores representan los colores base del sistema de diseño.
/// Los componentes no deberían utilizar directamente estos valores;
/// deben consumir los colores semánticos definidos por el ThemeData.
class AppColors {
  AppColors._();

  // Colores primitivos
  static const Color purple900 = Color(0xFF4A148C);
  static const Color purple700 = Color(0xFF6A1B9A);
  static const Color purple500 = Color(0xFF7E57C2);
  static const Color purple100 = Color(0xFFEDE7F6);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);

  static const Color gray700 = Color(0xFF4A4A4A);
  static const Color gray500 = Color(0xFF757575);
  static const Color gray200 = Color(0xFFE0E0E0);
  static const Color gray100 = Color(0xFFF5F5F5);

  static const Color error = Color(0xFFB3261E);
  static const Color success = Color(0xFF2E7D32);
}