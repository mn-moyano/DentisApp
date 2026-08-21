import 'package:flutter/material.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';

class EditarCitaScreen extends StatelessWidget {
  final Map<String, dynamic> cita;

  const EditarCitaScreen({
    super.key,
    required this.cita,
  });

  @override
  Widget build(BuildContext context) {
    // Los controladores se inicializan con los datos de la cita existente
    final fechaController = TextEditingController(text: cita['fecha']);
    final pacienteController = TextEditingController(text: cita['paciente']);
    final odontologoController = TextEditingController(text: cita['odontologo']);
    final estadoController = TextEditingController(text: cita['estado']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cita'),
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
              texto: 'Guardar Cambios',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}