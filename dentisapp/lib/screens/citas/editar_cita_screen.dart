import 'package:flutter/material.dart';

class EditarCitaScreen extends StatelessWidget {
  final Map<String, dynamic> cita;

  const EditarCitaScreen({
    super.key,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    final fechaController =
        TextEditingController(text: cita['fecha']);

    final pacienteController =
        TextEditingController(text: cita['paciente']);

    final odontologoController =
        TextEditingController(text: cita['odontologo']);

    final estadoController =
        TextEditingController(text: cita['estado']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cita'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: pacienteController,
              decoration: const InputDecoration(
                labelText: 'Paciente',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: odontologoController,
              decoration: const InputDecoration(
                labelText: 'Odontólogo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: estadoController,
              decoration: const InputDecoration(
                labelText: 'Estado',
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