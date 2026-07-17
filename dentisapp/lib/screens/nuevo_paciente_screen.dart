import 'package:flutter/material.dart';

class NuevoPacienteScreen extends StatelessWidget {
  const NuevoPacienteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            TextField(
              decoration: InputDecoration(
                labelText: 'ID del paciente',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Nombres',
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Cédula',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Fecha de nacimiento',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30.0),

            TextField(
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 30.0),
            
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              }, // Aquí puedes agregar la lógica para guardar el paciente
              child: Text('Guardar Paciente'),
            )
          ],
        ),
      ),
    );
  }
}