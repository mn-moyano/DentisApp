import 'package:flutter/material.dart';
import 'nuevo_tratamiento_screen.dart';
import 'editar_tratamiento_screen.dart';

class TratamientosScreen extends StatelessWidget {
  const TratamientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tratamientos = [
      {
        'id_tratamiento': 1,
        'descripcion': 'Limpieza dental',
        'costo': 35.00,
      },
      {
        'id_tratamiento': 2,
        'descripcion': 'Resina estética',
        'costo': 60.00,
      },
      {
        'id_tratamiento': 3,
        'descripcion': 'Extracción dental',
        'costo': 80.00,
      },
      {
        'id_tratamiento': 4,
        'descripcion': 'Endodoncia',
        'costo': 150.00,
      },
      {
        'id_tratamiento': 5,
        'descripcion': 'Ortodoncia',
        'costo': 500.00,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tratamientos'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar tratamiento...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tratamientos.length,
              itemBuilder: (context, index) {

                final tratamiento = tratamientos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.medical_services),
                    ),

                    title: Text(
                      tratamiento['descripcion'].toString(),
                    ),

                    subtitle: Text(
                      'Costo: \$${tratamiento['costo']}',
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditarTratamientoScreen(
                            tratamiento: tratamiento,
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
              builder: (context) =>
                  const NuevoTratamientoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}