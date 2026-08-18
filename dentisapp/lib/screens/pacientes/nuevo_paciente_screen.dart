import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../services/paciente_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

/// Pantalla para registrar un nuevo paciente.
class NuevoPacienteScreen extends StatefulWidget {
  const NuevoPacienteScreen({super.key});

  @override
  State<NuevoPacienteScreen> createState() => _NuevoPacienteScreenState();
}

class _NuevoPacienteScreenState extends State<NuevoPacienteScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController fechaNacimientoController =
      TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();

  final PacienteApiService pacienteApiService = PacienteApiService();

  bool guardando = false;

  /// Guarda el paciente mediante la API.
  Future<void> guardarPaciente() async {
    if (nombreController.text.trim().isEmpty ||
        apellidoController.text.trim().isEmpty ||
        cedulaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nombres, apellidos y cédula son obligatorios.',
          ),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      DateTime? fechaNacimiento;

      if (fechaNacimientoController.text.trim().isNotEmpty) {
        fechaNacimiento = DateTime.tryParse(
          fechaNacimientoController.text.trim(),
        );
      }

      final paciente = Paciente(
        nombres: nombreController.text.trim(),
        apellidos: apellidoController.text.trim(),
        cedula: cedulaController.text.trim(),
        fechaNacimiento: fechaNacimiento,
        telefono: telefonoController.text.trim().isEmpty
            ? null
            : telefonoController.text.trim(),
        correo: correoController.text.trim().isEmpty
            ? null
            : correoController.text.trim(),
        direccion: direccionController.text.trim().isEmpty
            ? null
            : direccionController.text.trim(),
      );

      final pacienteCreado =
          await pacienteApiService.crearPaciente(paciente);

      if (!mounted) return;

      if (pacienteCreado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paciente registrado correctamente.'),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo registrar el paciente.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar paciente: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cedulaController.dispose();
    fechaNacimientoController.dispose();
    telefonoController.dispose();
    correoController.dispose();
    direccionController.dispose();

    super.dispose();
  }

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

            CustomButton(
              texto: guardando
                  ? 'Guardando...'
                  : 'Guardar Paciente',
              icono: Icons.save,
              onPressed: guardando ? () {} : guardarPaciente,
            ),
          ],
        ),
      ),
    );
  }
}