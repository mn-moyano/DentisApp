import 'package:flutter/material.dart';

import '../../models/odontologo.dart';
import '../../services/odontologo_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditarOdontologoScreen extends StatefulWidget {
  final Odontologo odontologo;

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
  late TextEditingController nombresController;
  late TextEditingController apellidosController;
  late TextEditingController especialidadController;
  late TextEditingController telefonoController;
  late TextEditingController correoController;

  final OdontologoApiService apiService =
      OdontologoApiService();

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    nombresController = TextEditingController(
      text: widget.odontologo.nombres,
    );

    apellidosController = TextEditingController(
      text: widget.odontologo.apellidos,
    );

    especialidadController =
        TextEditingController(
      text: widget.odontologo.especialidad,
    );

    telefonoController = TextEditingController(
      text: widget.odontologo.telefono ?? '',
    );

    correoController = TextEditingController(
      text: widget.odontologo.correo ?? '',
    );
  }

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    especialidadController.dispose();
    telefonoController.dispose();
    correoController.dispose();

    super.dispose();
  }

  Future<void> guardarCambios() async {
    setState(() {
      guardando = true;
    });

    final odontologoActualizado = Odontologo(
      idOdontologo:
          widget.odontologo.idOdontologo,
      nombres: nombresController.text.trim(),
      apellidos: apellidosController.text.trim(),
      especialidad:
          especialidadController.text.trim(),
      telefono:
          telefonoController.text.trim().isEmpty
              ? null
              : telefonoController.text.trim(),
      correo:
          correoController.text.trim().isEmpty
              ? null
              : correoController.text.trim(),
      estado: widget.odontologo.estado,
    );

    final resultado =
        await apiService.actualizarOdontologo(
      odontologoActualizado,
    );

    if (!mounted) return;

    setState(() {
      guardando = false;
    });

    if (resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Odontólogo actualizado correctamente.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo actualizar el odontólogo.',
          ),
        ),
      );
    }
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
              controller: nombresController,
              label: 'Nombres',
            ),

            CustomTextField(
              controller: apellidosController,
              label: 'Apellidos',
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
              keyboardType:
                  TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            CustomButton(
              texto: guardando
                  ? 'Guardando...'
                  : 'Guardar Cambios',
              icono: Icons.save,
              onPressed:
                  guardando
                      ? null
                      : guardarCambios,
            ),
          ],
        ),
      ),
    );
  }
}