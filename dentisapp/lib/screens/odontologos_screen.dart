import 'package:flutter/material.dart';

class OdontologosScreen extends StatelessWidget {
  const OdontologosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odontólogos'),
      ),
      body: const Center(
        child: Text(
          'Listado de odontólogos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}