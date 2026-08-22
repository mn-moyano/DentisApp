import 'package:flutter/material.dart';

import '../../models/cita.dart';
import '../../services/cita_api_service.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import 'editar_cita_screen.dart';
import 'nueva_cita_screen.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final CitaApiService _apiService = CitaApiService();

  List<Cita> citas = [];

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });

    cargarCitas();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> cargarCitas() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final resultado =
          await _apiService.obtenerCitas();

      if (!mounted) return;

      setState(() {
        citas = resultado;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  List<Cita> get citasFiltradas {
    final texto =
        searchController.text.trim().toLowerCase();

    if (texto.isEmpty) {
      return citas;
    }

    return citas.where((cita) {
      final estado =
          cita.estado.toLowerCase();

      final fecha =
          cita.fechaHora.toString().toLowerCase();

      final motivo =
          cita.motivo.toLowerCase();

      return estado.contains(texto) ||
          fecha.contains(texto) ||
          motivo.contains(texto) ||
          cita.idPaciente
              .toString()
              .contains(texto) ||
          cita.idOdontologo
              .toString()
              .contains(texto);
    }).toList();
  }

  String formatearFecha(DateTime fecha) {
    final dia =
        fecha.day.toString().padLeft(2, '0');

    final mes =
        fecha.month.toString().padLeft(2, '0');

    final anio =
        fecha.year.toString();

    final hora =
        fecha.hour.toString().padLeft(2, '0');

    final minuto =
        fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final lista = citasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),

      body: Column(
        children: [
          CustomSearchBar(
            controller: searchController,
            hint: 'Buscar cita...',
          ),

          Expanded(
            child: AsyncStateView(
              isLoading: isLoading,
              error: error,
              isEmpty:
                  !isLoading && lista.isEmpty,
              onRetry: cargarCitas,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 80,
                ),
                itemCount: lista.length,
                itemBuilder: (context, index) {
                  final cita = lista[index];

                  return CustomCard(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.calendar_today,
                        ),
                      ),

                      title: Text(
                        'Cita #${cita.idCita}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      subtitle: Text(
                        'Fecha: '
                        '${formatearFecha(cita.fechaHora)}\n'
                        'Motivo: '
                        '${cita.motivo}\n'
                        'Paciente: '
                        '${cita.idPaciente}\n'
                        'Odontólogo: '
                        '${cita.idOdontologo}\n'
                        'Estado: '
                        '${cita.estado}',
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
                                EditarCitaScreen(
                              cita: cita,
                            ),
                          ),
                        );

                        cargarCitas();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const NuevaCitaScreen(),
            ),
          );

          cargarCitas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}