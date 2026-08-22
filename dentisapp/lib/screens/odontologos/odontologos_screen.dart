import 'package:flutter/material.dart';

import '../../models/odontologo.dart';
import '../../services/odontologo_api_service.dart';
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

class _OdontologosScreenState
    extends State<OdontologosScreen> {
  final TextEditingController buscarController =
      TextEditingController();

  final OdontologoApiService apiService =
      OdontologoApiService();

  List<Odontologo> odontologos = [];

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();

    buscarController.addListener(() {
      setState(() {});
    });

    cargarOdontologos();
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  Future<void> cargarOdontologos() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final resultado =
          await apiService.obtenerOdontologos();

      if (!mounted) return;

      setState(() {
        odontologos = resultado;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        cargando = false;
      });
    }
  }

  List<Odontologo> get odontologosFiltrados {
    final texto =
        buscarController.text.trim().toLowerCase();

    if (texto.isEmpty) {
      return odontologos;
    }

    return odontologos.where((odontologo) {
      final nombre =
          '${odontologo.nombres} ${odontologo.apellidos}'
              .toLowerCase();

      final especialidad =
          odontologo.especialidad.toLowerCase();

      final telefono =
          odontologo.telefono?.toLowerCase() ?? '';

      final correo =
          odontologo.correo?.toLowerCase() ?? '';

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
            child: _construirContenido(lista),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado =
              await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const NuevoOdontologoScreen(),
            ),
          );

          if (resultado == true) {
            cargarOdontologos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _construirContenido(
    List<Odontologo> lista,
  ) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'No se pudieron cargar los odontólogos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: cargarOdontologos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (lista.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron odontólogos.',
        ),
      );
    }

    return ListView.builder(
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
                odontologo.nombres
                    .substring(0, 1)
                    .toUpperCase(),
              ),
            ),

            title: Text(
              '${odontologo.nombres} '
              '${odontologo.apellidos}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            subtitle: Text(
              'Especialidad: '
              '${odontologo.especialidad}\n'
              'Teléfono: '
              '${odontologo.telefono ?? 'No registrado'}\n'
              'Correo: '
              '${odontologo.correo ?? 'No registrado'}\n'
              'Estado: '
              '${odontologo.estado}',
            ),

            isThreeLine: true,

            trailing: const Icon(
              Icons.arrow_forward_ios,
            ),

            onTap: () async {
              final resultado =
                  await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditarOdontologoScreen(
                    odontologo: odontologo,
                  ),
                ),
              );

              if (resultado == true) {
                cargarOdontologos();
              }
            },
          ),
        );
      },
    );
  }
}