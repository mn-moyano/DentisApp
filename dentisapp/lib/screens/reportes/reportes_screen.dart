import 'package:flutter/material.dart';

class ReportesScreen extends StatelessWidget {
  const ReportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [

            Card(
              child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Ingresos del Mes'),
                subtitle: Text('\$3,420.00'),
              ),
            ),

            SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Citas Programadas'),
                subtitle: Text('8 citas'),
              ),
            ),

            SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text('Citas Atendidas'),
                subtitle: Text('5 citas'),
              ),
            ),

            SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Citas Canceladas'),
                subtitle: Text('1 cita'),
              ),
            ),

            SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(Icons.medical_services),
                title: Text('Tratamiento Más Frecuente'),
                subtitle: Text('Limpieza Dental (25 veces)'),
              ),
            ),

            SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Pacientes Registrados'),
                subtitle: Text('120 pacientes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}