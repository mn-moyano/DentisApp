import 'package:flutter/material.dart';
import 'nuevo_pago_screen.dart';
import 'editar_pago_screen.dart';

class PagosScreen extends StatelessWidget {
  const PagosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pagos = [
      {
        'id_pago': 1,
        'fecha_pago': '20/07/2026',
        'monto': 95.00,
        'metodo_pago': 'Tarjeta',
        'id_cita': 1,
      },
      {
        'id_pago': 2,
        'fecha_pago': '21/07/2026',
        'monto': 35.00,
        'metodo_pago': 'Efectivo',
        'id_cita': 2,
      },
      {
        'id_pago': 3,
        'fecha_pago': '22/07/2026',
        'monto': 150.00,
        'metodo_pago': 'Transferencia',
        'id_cita': 3,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar pago...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: pagos.length,
              itemBuilder: (context, index) {

                final pago = pagos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.payment),
                    ),

                    title: Text(
                      '\$${pago['monto']}',
                    ),

                    subtitle: Text(
                      'Fecha: ${pago['fecha_pago']}\n'
                      'Método: ${pago['metodo_pago']}\n'
                      'Cita ID: ${pago['id_cita']}',
                    ),

                    isThreeLine: true,

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPagoScreen(
                            pago: pago,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NuevoPagoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}