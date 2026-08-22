import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.label,
  });

  Future<void> _seleccionarFecha(
    BuildContext context,
  ) async {
    final DateTime ahora = DateTime.now();

    final DateTime? fechaSeleccionada =
        await showDatePicker(
      context: context,
      initialDate: ahora,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    final TimeOfDay? horaSeleccionada =
        await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: ahora.hour,
        minute: ahora.minute,
      ),
    );

    if (horaSeleccionada == null) {
      return;
    }

    final DateTime fechaHora = DateTime(
      fechaSeleccionada.year,
      fechaSeleccionada.month,
      fechaSeleccionada.day,
      horaSeleccionada.hour,
      horaSeleccionada.minute,
    );

    controller.text = fechaHora.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _seleccionarFecha(context),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(
            Icons.calendar_month,
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}