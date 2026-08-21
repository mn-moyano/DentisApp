import 'package:flutter/material.dart';

import '../../models/paciente.dart';
import '../../services/paciente_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

/// Pantalla para editar un paciente existente.
class EditarPacienteScreen extends StatefulWidget {
  final Paciente paciente;

  const EditarPacienteScreen({
    super.key,
    required this.paciente,
  });

  @override
  State<EditarPacienteScreen> createState() =>
      _EditarPacienteScreenState();
}

class _EditarPacienteScreenState
    extends State<EditarPacienteScreen> {
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController cedulaController;
  late TextEditingController fechaNacimientoController;
  late TextEditingController telefonoController;
  late TextEditingController correoController;
  late TextEditingController direccionController;

  final PacienteApiService pacienteApiService =
      PacienteApiService();

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    nombreController = TextEditingController(
      text: widget.paciente.nombres,
    );

    apellidoController = TextEditingController(
      text: widget.paciente.apellidos,
    );

    cedulaController = TextEditingController(
      text: widget.paciente.cedula,
    );

    fechaNacimientoController = TextEditingController(
      text: widget.paciente.fechaNacimiento != null
          ? _formatearFecha(
              widget.paciente.fechaNacimiento!,
            )
          : '',
    );

    telefonoController = TextEditingController(
      text: widget.paciente.telefono ?? '',
    );

    correoController = TextEditingController(
      text: widget.paciente.correo ?? '',
    );

    direccionController = TextEditingController(
      text: widget.paciente.direccion ?? '',
    );
  }

  /// Convierte DateTime a YYYY-MM-DD.
  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '${fecha.year}-$mes-$dia';
  }

  /// Guarda los cambios del paciente.
  Future<void> guardarCambios() async {
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

      if (fechaNacimientoController.text
          .trim()
          .isNotEmpty) {
        fechaNacimiento = DateTime.tryParse(
          fechaNacimientoController.text.trim(),
        );
      }

      final pacienteActualizado = Paciente(
        // Mantener el ID original.
        idPaciente: widget.paciente.idPaciente,

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

      final resultado =
          await pacienteApiService.actualizarPaciente(
        pacienteActualizado,
      );

      if (!mounted) return;

      if (resultado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Paciente actualizado correctamente.',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo actualizar el paciente.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al actualizar paciente: $e',
          ),
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
        title: const Text('Editar Paciente'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            TextFormField(
              initialValue:
                  widget.paciente.idPaciente?.toString() ?? '',
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'ID Paciente',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

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
                  : 'Guardar Cambios',
              icono: Icons.save,
              onPressed: guardando
                  ? null
                  : guardarCambios,
            ),
          ],
        ),
      ),
    );
  }
}