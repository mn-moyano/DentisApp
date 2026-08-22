import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

class EditarCitaScreen extends StatefulWidget {
  final Map<String, dynamic> cita;

  const EditarCitaScreen({
    super.key,
    required this.cita,
  });

  @override
  State<EditarCitaScreen> createState() =>
      _EditarCitaScreenState();
}

class _EditarCitaScreenState
    extends State<EditarCitaScreen> {
  late TextEditingController fechaController;
  late TextEditingController pacienteController;
  late TextEditingController odontologoController;
  late TextEditingController estadoController;

  @override
  void initState() {
    super.initState();

    fechaController = TextEditingController(
      text: widget.cita['fecha']?.toString() ?? '',
    );

    pacienteController = TextEditingController(
      text: widget.cita['paciente']?.toString() ?? '',
    );

    odontologoController = TextEditingController(
      text: widget.cita['odontologo']?.toString() ?? '',
    );

    estadoController = TextEditingController(
      text: widget.cita['estado']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    fechaController.dispose();
    pacienteController.dispose();
    odontologoController.dispose();
    estadoController.dispose();

    super.dispose();
  }

  void guardarCambios() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cita'),
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
              texto: 'Guardar Cambios',
              icono: Icons.save,
              onPressed: guardarCambios,
            ),
          ],
        ),
      ),
    );
  }
}