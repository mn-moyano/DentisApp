import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';

class NuevaCitaScreen extends StatelessWidget {
  const NuevaCitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Declaración de controladores que exige el CustomTextField y CustomDatePicker
    final fechaController = TextEditingController();
    final pacienteController = TextEditingController();
    final odontologoController = TextEditingController();
    final estadoController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            CustomButton(
              texto: 'Guardar Cita',
              onPressed: null, // Habilitar cuando se conecte el backend
            ),
          ],
        ),
      ),
    );
  }
}