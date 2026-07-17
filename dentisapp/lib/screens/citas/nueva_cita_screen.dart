import 'package:flutter/material.dart';

class NuevaCitaScreen extends StatelessWidget {
  const NuevaCitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cita'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [

            TextField(
              decoration: InputDecoration(
                labelText: 'Fecha',
                hintText: 'DD/MM/YYYY HH:MM',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              decoration: InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              decoration: InputDecoration(
                labelText: 'Odontólogo',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            TextField(
              decoration: InputDecoration(
                labelText: 'Estado',
                hintText: 'Programada',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: null,
              child: Text('Guardar Cita'),
            ),
          ],
        ),
      ),
    );
  }
}