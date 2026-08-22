import 'package:flutter/material.dart';

import '../../models/odontologo.dart';
import '../../services/odontologo_api_service.dart';
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
  final nombresController =
      TextEditingController();

  final apellidosController =
      TextEditingController();

  final especialidadController =
      TextEditingController();

  final telefonoController =
      TextEditingController();

  final correoController =
      TextEditingController();

  final OdontologoApiService apiService =
      OdontologoApiService();

  bool guardando = false;

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    especialidadController.dispose();
    telefonoController.dispose();
    correoController.dispose();

    super.dispose();
  }

  Future<void> guardarOdontologo() async {
    if (nombresController.text.trim().isEmpty ||
        apellidosController.text.trim().isEmpty ||
        especialidadController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa los campos obligatorios.',
          ),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    final odontologo = Odontologo(
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
      estado: 'Activo',
    );

    final resultado =
        await apiService.crearOdontologo(
      odontologo,
    );

    if (!mounted) return;

    setState(() {
      guardando = false;
    });

    if (resultado != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Odontólogo registrado correctamente.',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo registrar el odontólogo.',
          ),
        ),
      );
    }
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
                  : 'Guardar Odontólogo',
              icono: Icons.save,
              onPressed:
                  guardando
                      ? null
                      : guardarOdontologo,
            ),
          ],
        ),
      ),
    );
  }
}