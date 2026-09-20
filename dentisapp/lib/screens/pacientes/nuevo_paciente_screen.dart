import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../models/paciente.dart';
import '../../repositories/paciente_repository.dart';
import '../../services/api_client.dart';
import '../../services/paciente_local_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';
import 'tomar_foto_screen.dart';

/// Pantalla para registrar un nuevo paciente.
class NuevoPacienteScreen extends StatefulWidget {
  const NuevoPacienteScreen({super.key});

  @override
  State<NuevoPacienteScreen> createState() =>
      _NuevoPacienteScreenState();
}

class _NuevoPacienteScreenState
    extends State<NuevoPacienteScreen> {
  final TextEditingController nombreController =
      TextEditingController();

  final TextEditingController apellidoController =
      TextEditingController();

  final TextEditingController cedulaController =
      TextEditingController();

  final TextEditingController fechaNacimientoController =
      TextEditingController();

  final TextEditingController telefonoController =
      TextEditingController();

  final TextEditingController correoController =
      TextEditingController();

  final TextEditingController direccionController =
      TextEditingController();

  final PacienteRepository pacienteRepository =
      PacienteRepository();

  final PacienteLocalService pacienteLocalService =
      PacienteLocalService();

  bool guardando = false;

  String? fotoPath;

  Future<void> tomarFotografia() async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const TomarFotoScreen(),
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    setState(() {
      fotoPath = resultado;
    });
  }

  Future<String> guardarFotoLocalmente(
    String rutaTemporal,
  ) async {
    final directorio =
        await getApplicationDocumentsDirectory();

    final carpetaFotos = Directory(
      path.join(
        directorio.path,
        'pacientes',
      ),
    );

    if (!await carpetaFotos.exists()) {
      await carpetaFotos.create(
        recursive: true,
      );
    }

    final nombreArchivo =
        'paciente_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final destino = path.join(
      carpetaFotos.path,
      nombreArchivo,
    );

    final archivoOriginal = File(rutaTemporal);

    final archivoGuardado =
        await archivoOriginal.copy(destino);

    return archivoGuardado.path;
  }

  /// Guarda el paciente utilizando el Repository.
  ///
  /// El Repository decide si la operación se realiza
  /// contra el servidor o se almacena localmente para
  /// sincronizarla posteriormente.
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

      if (fechaNacimientoController.text
          .trim()
          .isNotEmpty) {
        fechaNacimiento = DateTime.tryParse(
          fechaNacimientoController.text.trim(),
        );
      }

      final paciente = Paciente(
        nombres: nombreController.text.trim(),
        apellidos: apellidoController.text.trim(),
        cedula: cedulaController.text.trim(),
        fechaNacimiento: fechaNacimiento,
        telefono:
            telefonoController.text.trim().isEmpty
                ? null
                : telefonoController.text.trim(),
        correo:
            correoController.text.trim().isEmpty
                ? null
                : correoController.text.trim(),
        direccion:
            direccionController.text.trim().isEmpty
                ? null
                : direccionController.text.trim(),
      );

      final pacienteCreado =
          await pacienteRepository.crearPaciente(
        paciente,
      );

      if (pacienteCreado != null &&
          fotoPath != null) {
        final fotoLocal =
            await guardarFotoLocalmente(fotoPath!);

        await pacienteLocalService
            .guardarFotoPorCedula(
          cedula: paciente.cedula,
          fotoPath: fotoLocal,
        );
      }

      if (!mounted) {
        return;
      }

      if (pacienteCreado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Paciente registrado correctamente.',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo registrar el paciente.',
            ),
          ),
        );
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      final errores = error.errors;

      String mensaje = error.message;

      if (errores != null && errores.isNotEmpty) {
        final mensajesCampos = errores.entries
            .expand(
              (entry) => (entry.value as List<dynamic>)
                  .map(
                    (mensajeCampo) =>
                        '${entry.key}: $mensajeCampo',
                  ),
            )
            .join('\n');

        mensaje = '$mensaje\n$mensajesCampos';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          duration: const Duration(seconds: 5),
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
            Center(
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline,
                      ),
                    ),
                    child: fotoPath == null
                        ? const Icon(
                            Icons.person,
                            size: 70,
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(12),
                            child: Image.file(
                              File(fotoPath!),
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed:
                        guardando
                            ? null
                            : tomarFotografia,
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    label: Text(
                      fotoPath == null
                          ? 'Tomar fotografía'
                          : 'Tomar otra fotografía',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
              keyboardType:
                  TextInputType.emailAddress,
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
              onPressed:
                  guardando ? null : guardarPaciente,
            ),
          ],
        ),
      ),
    );
  }
}