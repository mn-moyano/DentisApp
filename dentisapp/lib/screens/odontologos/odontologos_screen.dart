import 'package:flutter/material.dart';
import 'nuevo_odontologo_screen.dart';
import 'editar_odontologo_screen.dart';

class OdontologosScreen extends StatelessWidget {
  const OdontologosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final odontologos = [
      {
        'id_odontologo': 1,
        'nombres': 'Andrés',
        'apellidos': 'Morales',
        'especialidad': 'Ortodoncia',
        'telefono': '0991111111',
        'correo': 'amorales@dentisapp.com',
        'estado': 'Activo'
      },
      {
        'id_odontologo': 2,
        'nombres': 'Paola',
        'apellidos': 'Vera',
        'especialidad': 'Endodoncia',
        'telefono': '0992222222',
        'correo': 'pvera@dentisapp.com',
        'estado': 'Activo'
      },
      {
        'id_odontologo': 3,
        'nombres': 'Daniel',
        'apellidos': 'Castillo',
        'especialidad': 'Odontopediatría',
        'telefono': '0993333333',
        'correo': 'dcastillo@dentisapp.com',
        'estado': 'Inactivo'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odontólogos'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar odontólogo...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: odontologos.length,
              itemBuilder: (context, index) {

                final odontologo = odontologos[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        odontologo['nombres'].toString()[0],
                      ),
                    ),

                    title: Text(
                      '${odontologo['nombres']} ${odontologo['apellidos']}',
                    ),

                    subtitle: Text(
                      'Especialidad: ${odontologo['especialidad']}\n'
                      'Teléfono: ${odontologo['telefono']}\n'
                      'Correo: ${odontologo['correo']}\n'
                      'Estado: ${odontologo['estado']}',
                    ),

                    isThreeLine: true,

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                    ),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditarOdontologoScreen(
                            odontologo: odontologo,
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
              builder: (_) => const NuevoOdontologoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}