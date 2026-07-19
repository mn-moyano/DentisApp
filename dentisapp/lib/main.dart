import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
      theme: ThemeData(
        // Se define el esquema de colores principal de la aplicación.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
