import 'package:flutter/material.dart';

import 'screens/auth/session_gate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DentisApp());
}

class DentisApp extends StatelessWidget {
  const DentisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DentisApp',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),

      home: const SessionGate(),
    );
  }
}