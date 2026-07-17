import 'package:flutter/material.dart';

class EditarPagoScreen extends StatelessWidget {
  final Map<String, dynamic> pago;

  const EditarPagoScreen({
    super.key,
    required this.pago,
  });

  @override
  Widget build(BuildContext context) {

    final fechaController =
        TextEditingController(
      text: pago['fecha_pago'],
    );

    final montoController =
        TextEditingController(
      text: pago['monto'].toString(),
    );

    final metodoController =
        TextEditingController(
      text: pago['metodo_pago'],
    );

    final citaController =
        TextEditingController(
      text: pago['id_cita'].toString(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Pago'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [

            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha de pago',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: metodoController,
              decoration: const InputDecoration(
                labelText: 'Método de pago',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: citaController,
              decoration: const InputDecoration(
                labelText: 'ID de la cita',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}