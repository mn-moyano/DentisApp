import 'package:flutter/material.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),
      body: const Center(
        child: Text(
          'Listado de pacientes',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}