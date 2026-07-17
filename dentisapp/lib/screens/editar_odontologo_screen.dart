import 'package:flutter/material.dart';

class EditarOdontologoScreen extends StatelessWidget {

  final Map<String, dynamic> odontologo;

  const EditarOdontologoScreen({
    super.key,
    required this.odontologo,
  });

  @override
  Widget build(BuildContext context) {

    final nombreController =
        TextEditingController(
            text: odontologo['nombre']);

    final especialidadController =
        TextEditingController(
            text: odontologo['especialidad']);

    final telefonoController =
        TextEditingController(
            text: odontologo['telefono']);

    final correoController =
        TextEditingController(
            text: odontologo['correo']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Odontólogo'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: especialidadController,
              decoration: const InputDecoration(
                labelText: 'Especialidad',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: correoController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}