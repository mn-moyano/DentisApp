import 'package:flutter/material.dart';
import 'nuevo_paciente_screen.dart';
import 'editar_paciente_screen.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pacientes = [
      {'id_paciente': 1,
        'nombres': 'Juan', 
      'apellidos': 'Pérez',
      'cedula': '1234567890',
      'fechaNacimiento': '1990-01-01',
      'telefono': '555-1234',
      'correo': 'juan.perez@example.com',
      'direccion': 'Calle Falsa 123'},
      {'id_paciente': 2,
        'nombres': 'María', 'apellidos': 'Gómez',
      'cedula': '0987654321',
      'fechaNacimiento': '1985-05-15',
      'telefono': '555-5678',
      'correo': 'maria.gomez@example.com',
      'direccion': 'Avenida Principal 456'},
      {'id_paciente': 3,
        'nombres': 'Carlos', 'apellidos': 'Rodríguez',
      'cedula': '1122334455',
      'fechaNacimiento': '1995-12-10',
      'telefono': '555-9012',
      'correo': 'carlos.rodriguez@example.com',
      'direccion': 'Calle Principal 789'},
      {'id_paciente': 4,
        'nombres': 'Ana', 'apellidos': 'Martínez',
      'cedula': '5544332211',
      'fechaNacimiento': '1988-08-20',
      'telefono': '555-3456',
      'correo': 'ana.martinez@example.com',
      'direccion': 'Avenida Secundaria 101'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar paciente...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {
                final paciente = pacientes[index];
                
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 5.0,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        paciente['nombres'].toString()[0],
                      ),
                    ),
                    
                    title: Text(
                      '${paciente['nombres']} ${paciente['apellidos']}',
                    ),
                    
                    subtitle: Text(
                      'Cédula: ${paciente['cedula']}\n'
                      'Teléfono: ${paciente['telefono']}\n'
                      'Correo: ${paciente['correo']}\n'
                      'Dirección: ${paciente['direccion']}',
                    ),

                  isThreeLine: true,

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarPacienteScreen(
                          paciente: paciente,
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
              builder: (context) => const NuevoPacienteScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}