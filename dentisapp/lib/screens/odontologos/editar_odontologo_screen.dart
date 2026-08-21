import 'package:flutter/material.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditarOdontologoScreen extends StatefulWidget {
  final Map<String, dynamic> odontologo;

  const EditarOdontologoScreen({
    super.key,
    required this.odontologo,
  });

  @override
  State<EditarOdontologoScreen> createState() =>
      _EditarOdontologoScreenState();
}

class _EditarOdontologoScreenState
    extends State<EditarOdontologoScreen> {
  late TextEditingController nombreController;
  late TextEditingController especialidadController;
  late TextEditingController telefonoController;
  late TextEditingController correoController;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text:
          '${widget.odontologo['nombres'] ?? ''} '
          '${widget.odontologo['apellidos'] ?? ''}',
    );

    especialidadController = TextEditingController(
      text: widget.odontologo['especialidad']?.toString() ?? '',
    );

    telefonoController = TextEditingController(
      text: widget.odontologo['telefono']?.toString() ?? '',
    );

    correoController = TextEditingController(
      text: widget.odontologo['correo']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    especialidadController.dispose();
    telefonoController.dispose();
    correoController.dispose();

    super.dispose();
  }

  void guardarCambios() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Odontólogo'),
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