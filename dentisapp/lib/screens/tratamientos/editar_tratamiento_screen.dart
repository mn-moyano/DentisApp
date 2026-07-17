import 'package:flutter/material.dart';

class EditarTratamientoScreen extends StatelessWidget {

  final Map<String, dynamic> tratamiento;

  const EditarTratamientoScreen({
    super.key,
    required this.tratamiento,
  });

  @override
  Widget build(BuildContext context) {

    final descripcionController = TextEditingController(
      text: tratamiento['descripcion'],
    );

    final costoController = TextEditingController(
      text: tratamiento['costo'].toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tratamiento'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_services),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: costoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Costo',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}