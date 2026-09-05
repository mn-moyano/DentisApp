import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'pacientes/pacientes_screen.dart';
import 'odontologos/odontologos_screen.dart';
import 'citas/citas_screen.dart';
import 'tratamientos/tratamientos_screen.dart';
import 'pagos/pagos_screen.dart';
import 'reportes/reportes_screen.dart';

/// Pantalla principal que muestra los módulos principales de DentisApp.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text(
            '¿Está seguro de que desea cerrar sesión?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await AuthService().cerrarSesion();

    if (!context.mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DentisApp'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),

      // Lista de opciones del sistema para navegar entre secciones.
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.people,
              color: colorScheme.primary,
            ),
            title: const Text('Pacientes'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PacientesScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(
              Icons.medical_services,
              color: colorScheme.primary,
            ),
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
            leading: Icon(
              Icons.calendar_month,
              color: colorScheme.primary,
            ),
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
            leading: Icon(
              Icons.healing,
              color: colorScheme.primary,
            ),
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
            leading: Icon(
              Icons.payment,
              color: colorScheme.primary,
            ),
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
            leading: Icon(
              Icons.bar_chart,
              color: colorScheme.primary,
            ),
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