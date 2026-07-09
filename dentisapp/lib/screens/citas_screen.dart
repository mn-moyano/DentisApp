import 'package:flutter/material.dart';

class CitasScreen extends StatelessWidget {
  const CitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: const Center(
        child: Text(
          'Listado de citas',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}