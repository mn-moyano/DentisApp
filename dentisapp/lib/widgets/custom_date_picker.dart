import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.label,
  });

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (fechaSeleccionada != null) {
      controller.text = "${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}";
    }
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
          suffixIcon: const Icon(Icons.calendar_month),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}