import 'package:flutter/material.dart';
import '../../models/paciente.dart';

class EditarPacienteScreen extends StatelessWidget {
  final Paciente paciente;
  
  const EditarPacienteScreen({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    
    final idPacienteController = TextEditingController(text: paciente.idPaciente.toString());

    final nombresController = TextEditingController(text: paciente.nombre);

    final apellidosController = TextEditingController(text: paciente.apellido);

    final cedulaController = TextEditingController(text: paciente.cedula);

    final fechaNacimientoController = TextEditingController(text: paciente.fechaNacimiento?.toString().split(' ') [0] ?? '',);

    final telefonoController = TextEditingController(text: paciente.telefono ?? '');

    final correoController = TextEditingController(text: paciente.correo ?? '');

    final direccionController = TextEditingController(text: paciente.direccion ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Paciente'),
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            
            TextField(
              controller: idPacienteController,
              decoration: const InputDecoration(labelText: 'ID Paciente', border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),

          const SizedBox(height: 15),

            TextField(
              controller: nombresController,
              decoration: const InputDecoration(labelText: 'Nombres', border: OutlineInputBorder(),
              ),
            ),

          const SizedBox(height: 15),

          TextField(
            controller: apellidosController,
            decoration: const InputDecoration(labelText: 'Apellidos', border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: cedulaController,
            decoration: const InputDecoration(labelText: 'Cédula', border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),
          
          TextField(
            controller: fechaNacimientoController,
            decoration: const InputDecoration(labelText: 'Fecha de Nacimiento', hintText: 'DD/MM/YYYY', border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: telefonoController,
            decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: correoController,
            decoration: const InputDecoration(labelText: 'Correo Electrónico', border: OutlineInputBorder(),
            ),
          ),
          
          const SizedBox(height: 20),

          TextField(
            controller: direccionController,
            decoration: const InputDecoration(labelText: 'Dirección', border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
                // Aquí puedes agregar la lógica para guardar los cambios del paciente
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