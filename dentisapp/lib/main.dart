import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// Punto de entrada principal de la aplicación DentisApp.
void main() {
  runApp(const DentisApp());
}

/// Widget raíz que configura el tema y la pantalla inicial de la app.
class DentisApp extends StatelessWidget {
  const DentisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DentisApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}