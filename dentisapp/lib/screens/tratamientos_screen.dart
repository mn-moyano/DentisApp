import 'package:flutter/material.dart';

class TratamientosScreen extends StatelessWidget {
  const TratamientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos'),
      ),
      body: const Center(
        child: Text(
          'Listado de tratamientos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}