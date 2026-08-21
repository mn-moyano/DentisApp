import 'package:flutter/material.dart';

import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'nuevo_odontologo_screen.dart';
import 'editar_odontologo_screen.dart';

class OdontologosScreen extends StatefulWidget {
  const OdontologosScreen({super.key});

  @override
  State<OdontologosScreen> createState() =>
      _OdontologosScreenState();
}

class _OdontologosScreenState extends State<OdontologosScreen> {
  final TextEditingController buscarController =
      TextEditingController();

  final List<Map<String, dynamic>> odontologos = [
    {
      'id_odontologo': 1,
      'nombres': 'Andrés',
      'apellidos': 'Morales',
      'especialidad': 'Ortodoncia',
      'telefono': '0991111111',
      'correo': 'amorales@dentisapp.com',
      'estado': 'Activo',
    },
    {
      'id_odontologo': 2,
      'nombres': 'Paola',
      'apellidos': 'Vera',
      'especialidad': 'Endodoncia',
      'telefono': '0992222222',
      'correo': 'pvera@dentisapp.com',
      'estado': 'Activo',
    },
    {
      'id_odontologo': 3,
      'nombres': 'Daniel',
      'apellidos': 'Castillo',
      'especialidad': 'Odontopediatría',
      'telefono': '0993333333',
      'correo': 'dcastillo@dentisapp.com',
      'estado': 'Inactivo',
    },
  ];

  @override
  void initState() {
    super.initState();

    buscarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get odontologosFiltrados {
    final texto =
        buscarController.text.trim().toLowerCase();

    if (texto.isEmpty) {
      return odontologos;
    }

    return odontologos.where((odontologo) {
      final nombre =
          '${odontologo['nombres']} ${odontologo['apellidos']}'
              .toLowerCase();

      final especialidad =
          odontologo['especialidad']
              .toString()
              .toLowerCase();

      final telefono =
          odontologo['telefono']
              .toString()
              .toLowerCase();

      final correo =
          odontologo['correo']
              .toString()
              .toLowerCase();

      return nombre.contains(texto) ||
          especialidad.contains(texto) ||
          telefono.contains(texto) ||
          correo.contains(texto);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lista = odontologosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Odontólogos'),
      ),

      body: Column(
        children: [
          CustomSearchBar(
            controller: buscarController,
            hint: 'Buscar odontólogo...',
          ),

          Expanded(
            child: lista.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron odontólogos.',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 80,
                    ),
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      final odontologo = lista[index];

                      return CustomCard(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              odontologo['nombres']
                                  .toString()[0]
                                  .toUpperCase(),
                            ),
                          ),

                          title: Text(
                            '${odontologo['nombres']} '
                            '${odontologo['apellidos']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          subtitle: Text(
                            'Especialidad: '
                            '${odontologo['especialidad']}\n'
                            'Teléfono: '
                            '${odontologo['telefono']}\n'
                            'Correo: '
                            '${odontologo['correo']}\n'
                            'Estado: '
                            '${odontologo['estado']}',
                          ),

                          isThreeLine: true,

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                          ),

                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditarOdontologoScreen(
                                  odontologo: odontologo,
                                ),
                              ),
                            );

                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const NuevoOdontologoScreen(),
            ),
          );

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}