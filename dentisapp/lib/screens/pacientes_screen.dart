import 'package:flutter/material.dart';
import 'nuevo_paciente_screen.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pacientes = [
      {'nombre': 'Juan Pérez',
      'cedula': '1234567890',
      'telefono': '555-1234'},
      {'nombre': 'María Gómez',
      'cedula': '0987654321',
      'telefono': '555-5678'},
      {'nombre': 'Carlos Rodríguez',
      'cedula': '1122334455',
      'telefono': '555-9012'},
      {'nombre': 'Ana Martínez',
      'cedula': '5544332211',
      'telefono': '555-3456'},
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
                        paciente['nombre']![0],
                    ),
                  ),
                    
                  title: Text(
                    paciente['nombre']!,
                  ),

                  subtitle: Text(
                    'Cédula: ${paciente['cedula']}\n'
                    'Teléfono: ${paciente['telefono']}',
                  ),

                  isThreeLine: true,

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  
                  onTap: () {},
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