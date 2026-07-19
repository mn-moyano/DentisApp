import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

/// Pantalla para registrar un nuevo paciente.
class NuevoPacienteScreen extends StatelessWidget {
  NuevoPacienteScreen({super.key});

  /// Controladores de los campos del formulario.
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Paciente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            CustomTextField(
              controller: nombreController,
              label: 'Nombres',
            ),

            CustomTextField(
              controller: apellidoController,
              label: 'Apellidos',
            ),

            CustomTextField(
              controller: cedulaController,
              label: 'Cédula',
              keyboardType: TextInputType.number,
            ),

            CustomDatePicker(
              controller: fechaNacimientoController,
              label: 'Fecha de nacimiento',
            ),

            CustomTextField(
              controller: telefonoController,
              label: 'Teléfono',
              keyboardType: TextInputType.phone,
            ),

            CustomTextField(
              controller: correoController,
              label: 'Correo electrónico',
              keyboardType: TextInputType.emailAddress,
            ),

            CustomTextField(
              controller: direccionController,
              label: 'Dirección',
            ),

            const SizedBox(height: 20),

            /// Botón para guardar la información del nuevo paciente.
            CustomButton(
              texto: 'Guardar Paciente',
              icono: Icons.save,
              onPressed: () {
                // Aquí luego se integrará la lógica con el servicio de pacientes.
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}