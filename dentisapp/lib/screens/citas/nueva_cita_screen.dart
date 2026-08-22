import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

class NuevaCitaScreen extends StatefulWidget {
  const NuevaCitaScreen({super.key});

  @override
  State<NuevaCitaScreen> createState() =>
      _NuevaCitaScreenState();
}

class _NuevaCitaScreenState
    extends State<NuevaCitaScreen> {
  final TextEditingController fechaController =
      TextEditingController();

  final TextEditingController pacienteController =
      TextEditingController();

  final TextEditingController odontologoController =
      TextEditingController();

  final TextEditingController estadoController =
      TextEditingController();

  @override
  void dispose() {
    fechaController.dispose();
    pacienteController.dispose();
    odontologoController.dispose();
    estadoController.dispose();

    super.dispose();
  }

  void guardarCita() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cita'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            CustomDatePicker(
              controller: fechaController,
              label: 'Fecha de la Cita',
            ),

            CustomTextField(
              controller: pacienteController,
              label: 'Paciente',
            ),

            CustomTextField(
              controller: odontologoController,
              label: 'Odontólogo',
            ),

            CustomTextField(
              controller: estadoController,
              label: 'Estado',
            ),

            const SizedBox(height: 20),

            CustomButton(
              texto: 'Guardar Cita',
              icono: Icons.save,
              onPressed: guardarCita,
            ),
          ],
        ),
      ),
    );
  }
}