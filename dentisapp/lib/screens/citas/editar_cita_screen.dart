import 'package:flutter/material.dart';

import '../../models/cita.dart';
import '../../services/cita_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_textfield.dart';

class EditarCitaScreen extends StatefulWidget {
  final Cita cita;

  const EditarCitaScreen({
    super.key,
    required this.cita,
  });

  @override
  State<EditarCitaScreen> createState() =>
      _EditarCitaScreenState();
}

class _EditarCitaScreenState extends State<EditarCitaScreen> {
  final CitaApiService _apiService = CitaApiService();

  late TextEditingController fechaHoraController;
  late TextEditingController motivoController;
  late TextEditingController pacienteController;
  late TextEditingController odontologoController;

  String estadoSeleccionado = 'Programada';

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    fechaHoraController = TextEditingController(
      text: _formatearFecha(widget.cita.fechaHora),
    );

    motivoController = TextEditingController(
      text: widget.cita.motivo,
    );

    pacienteController = TextEditingController(
      text: widget.cita.idPaciente.toString(),
    );

    odontologoController = TextEditingController(
      text: widget.cita.idOdontologo.toString(),
    );

    estadoSeleccionado = widget.cita.estado;
  }

  @override
  void dispose() {
    fechaHoraController.dispose();
    motivoController.dispose();
    pacienteController.dispose();
    odontologoController.dispose();

    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    return '$anio-$mes-$dia';
  }

  Future<void> guardarCambios() async {
    if (fechaHoraController.text.trim().isEmpty ||
        motivoController.text.trim().isEmpty ||
        pacienteController.text.trim().isEmpty ||
        odontologoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos.'),
        ),
      );
      return;
    }

    final fechaHora = DateTime.tryParse(
      fechaHoraController.text.trim(),
    );

    if (fechaHora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha no tiene un formato válido.'),
        ),
      );
      return;
    }

    final idPaciente = int.tryParse(
      pacienteController.text.trim(),
    );

    final idOdontologo = int.tryParse(
      odontologoController.text.trim(),
    );

    if (idPaciente == null || idOdontologo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Los IDs de paciente y odontólogo deben ser números.',
          ),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    final citaActualizada = Cita(
      idCita: widget.cita.idCita,
      fechaHora: fechaHora,
      motivo: motivoController.text.trim(),
      estado: estadoSeleccionado,
      idPaciente: idPaciente,
      idOdontologo: idOdontologo,
    );

    try {
      final resultado =
          await _apiService.actualizarCita(citaActualizada);

      if (!mounted) return;

      if (resultado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cita actualizada correctamente.',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo actualizar la cita.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al actualizar la cita: $e',
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
              controller: fechaHoraController,
              label: 'Fecha de la Cita',
            ),

            CustomTextField(
              controller: motivoController,
              label: 'Motivo',
              maxLines: 3,
            ),

            CustomTextField(
              controller: pacienteController,
              label: 'Paciente',
              keyboardType: TextInputType.number,
            ),

            CustomTextField(
              controller: odontologoController,
              label: 'Odontólogo',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 5),

            DropdownButtonFormField<String>(
              value: estadoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Programada',
                  child: Text('Programada'),
                ),
                DropdownMenuItem(
                  value: 'Atendida',
                  child: Text('Atendida'),
                ),
                DropdownMenuItem(
                  value: 'Cancelada',
                  child: Text('Cancelada'),
                ),
                DropdownMenuItem(
                  value: 'Reprogramada',
                  child: Text('Reprogramada'),
                ),
              ],
              onChanged: guardando
                  ? null
                  : (valor) {
                      if (valor != null) {
                        setState(() {
                          estadoSeleccionado = valor;
                        });
                      }
                    },
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