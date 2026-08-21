import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class NuevoOdontologoScreen extends StatefulWidget {
  const NuevoOdontologoScreen({super.key});

  @override
  State<NuevoOdontologoScreen> createState() =>
      _NuevoOdontologoScreenState();
}

class _NuevoOdontologoScreenState
    extends State<NuevoOdontologoScreen> {
  final TextEditingController nombreController =
      TextEditingController();

  final TextEditingController especialidadController =
      TextEditingController();

  final TextEditingController telefonoController =
      TextEditingController();

  final TextEditingController correoController =
      TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    especialidadController.dispose();
    telefonoController.dispose();
    correoController.dispose();

    super.dispose();
  }

  void guardarOdontologo() {
    Navigator.pop(context);
  }

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
            CustomTextField(
              controller: nombreController,
              label: 'Nombre',
            ),

            CustomTextField(
              controller: especialidadController,
              label: 'Especialidad',
            ),

            CustomTextField(
              controller: telefonoController,
              label: 'Teléfono',
              keyboardType: TextInputType.phone,
            ),

            CustomTextField(
              controller: correoController,
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            CustomButton(
              texto: 'Guardar Odontólogo',
              icono: Icons.save,
              onPressed: guardarOdontologo,
            ),
          ],
        ),
      ),
    );
  }
}