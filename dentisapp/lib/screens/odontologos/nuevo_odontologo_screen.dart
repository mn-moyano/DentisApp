import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';


class NuevoOdontologoScreen extends StatelessWidget {
  const NuevoOdontologoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Odontólogo'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            const TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Especialidad',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            CustomButton(
              texto: 'Guardar Odontólogo',
              icono: Icons.save,
              onPressed: () {
              
              // Aquí luego llamaremos al OdontólogoService
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}