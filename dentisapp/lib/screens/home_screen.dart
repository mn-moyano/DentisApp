import 'package:flutter/material.dart';

import 'pacientes/pacientes_screen.dart';
import 'odontologos/odontologos_screen.dart';
import 'citas/citas_screen.dart';
import 'tratamientos/tratamientos_screen.dart';
import 'pagos/pagos_screen.dart';
import 'reportes/reportes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DentisApp'),
      ),
      
      body: ListView(
        children: [
          
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Pacientes'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PacientesScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.medical_services),
            title: const Text('Odontólogos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OdontologosScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Citas'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CitasScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.healing),
            title: const Text('Tratamientos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TratamientosScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pagos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PagosScreen(),
                ),
              );
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Reportes'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  } 
}