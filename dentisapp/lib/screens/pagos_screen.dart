import 'package:flutter/material.dart';

class PagosScreen extends StatelessWidget {
  const PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
      ),
      body: const Center(
        child: Text(
          'Listado de pagos',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}