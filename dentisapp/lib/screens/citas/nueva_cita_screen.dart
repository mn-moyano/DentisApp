import 'package:flutter/material.dart';

import '../../models/cita.dart';
import '../../services/cita_api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class NuevaCitaScreen extends StatefulWidget {
  const NuevaCitaScreen({super.key});

  @override
  State<NuevaCitaScreen> createState() =>
      _NuevaCitaScreenState();
}

class _NuevaCitaScreenState
    extends State<NuevaCitaScreen> {
  final TextEditingController fechaHoraController =
      TextEditingController();

  final TextEditingController motivoController =
      TextEditingController();

  final TextEditingController pacienteController =
      TextEditingController();

  final TextEditingController odontologoController =
      TextEditingController();

  String estadoSeleccionado = 'Programada';

  final CitaApiService _apiService =
      CitaApiService();

  @override
  void dispose() {
    fechaHoraController.dispose();
    motivoController.dispose();
    pacienteController.dispose();
    odontologoController.dispose();

    super.dispose();
  }

  Future<void> seleccionarFechaHora() async {
    final DateTime? fecha =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (fecha == null || !mounted) return;

    final TimeOfDay? hora =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora == null) return;

    final DateTime fechaHora = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora.hour,
      hora.minute,
    );

    fechaHoraController.text =
        '${fechaHora.day.toString().padLeft(2, '0')}/'
        '${fechaHora.month.toString().padLeft(2, '0')}/'
        '${fechaHora.year} '
        '${fechaHora.hour.toString().padLeft(2, '0')}:'
        '${fechaHora.minute.toString().padLeft(2, '0')}';
  }

  Future<void> guardarCita() async {
    if (fechaHoraController.text.isEmpty ||
        motivoController.text.trim().isEmpty ||
        pacienteController.text.trim().isEmpty ||
        odontologoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Complete todos los campos.',
          ),
        ),
      );

      return;
    }

    try {
      // Por ahora el campo de fecha se encuentra
      // en formato DD/MM/YYYY HH:mm.
      final partes =
          fechaHoraController.text.split(' ');

      final fechaPartes =
          partes[0].split('/');

      final horaPartes =
          partes[1].split(':');

      final fechaHora = DateTime(
        int.parse(fechaPartes[2]),
        int.parse(fechaPartes[1]),
        int.parse(fechaPartes[0]),
        int.parse(horaPartes[0]),
        int.parse(horaPartes[1]),
      );

      final cita = Cita(
        fechaHora: fechaHora,
        motivo: motivoController.text.trim(),
        estado: estadoSeleccionado,
        idPaciente:
            int.parse(pacienteController.text.trim()),
        idOdontologo:
            int.parse(odontologoController.text.trim()),
      );

      final resultado =
          await _apiService.crearCita(cita);

      if (!mounted) return;

      if (resultado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Cita registrada correctamente.',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo registrar la cita.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cita'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            // Fecha y hora
            GestureDetector(
              onTap: seleccionarFechaHora,
              child: AbsorbPointer(
                child: CustomTextField(
                  controller: fechaHoraController,
                  label: 'Fecha y hora',
                ),
              ),
            ),

            // Motivo
            CustomTextField(
              controller: motivoController,
              label: 'Motivo',
              maxLines: 2,
            ),

            // Paciente
            CustomTextField(
              controller: pacienteController,
              label: 'ID del paciente',
              keyboardType: TextInputType.number,
            ),

            // Odontólogo
            CustomTextField(
              controller: odontologoController,
              label: 'ID del odontólogo',
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 10),

            // Estado
            DropdownButtonFormField<String>(
              initialValue: estadoSeleccionado,
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
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    estadoSeleccionado = valor;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            CustomButton(
              texto: 'Guardar Cita',
              icono: Icons.save,
              onPressed: guardarCita,
            ),
          ],
        ),
      ),
    );
  }
}