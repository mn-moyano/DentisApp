import 'package:flutter/material.dart';

import '../../services/notification_service.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() =>
      _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  bool procesando = false;
  bool? permisoConcedido;

  Future<void> _solicitarPermiso() async {
    setState(() {
      procesando = true;
    });

    try {
      final resultado =
          await NotificationService.instance.solicitarPermiso();

      if (!mounted) return;

      setState(() {
        permisoConcedido = resultado;
        procesando = false;
      });

      if (resultado == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Las notificaciones fueron habilitadas.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Las notificaciones no fueron habilitadas.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        procesando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo solicitar el permiso de notificaciones.',
          ),
        ),
      );
    }
  }

  Future<void> _enviarNotificacionPrueba() async {
    if (permisoConcedido != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Primero debes habilitar las notificaciones.',
          ),
        ),
      );
      return;
    }

    try {
      await NotificationService.instance.mostrarNotificacion(
        id: 1,
        titulo: 'DentisApp',
        mensaje: 'Esta es una notificación de prueba.',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Notificación enviada.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo mostrar la notificación.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.notifications_outlined,
              size: 64,
            ),
            const SizedBox(height: 24),
            const Text(
              'Notificaciones de DentisApp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'DentisApp puede mostrar avisos relacionados con '
              'citas y otras actividades importantes de la aplicación.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: procesando ? null : _solicitarPermiso,
              icon: const Icon(Icons.notifications_active),
              label: Text(
                procesando
                    ? 'Solicitando permiso...'
                    : 'Activar notificaciones',
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _enviarNotificacionPrueba,
              icon: const Icon(Icons.send),
              label: const Text('Enviar notificación de prueba'),
            ),
            const SizedBox(height: 24),
            if (permisoConcedido == true)
              const Text(
                'Estado: permiso concedido.',
                textAlign: TextAlign.center,
              )
            else if (permisoConcedido == false)
              const Text(
                'Estado: permiso denegado.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}