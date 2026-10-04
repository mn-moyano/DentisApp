import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// ==========================================
// 1. BOTÓN DE CÁMARA (Con los 4 estados)
// ==========================================
class BotonCamaraPermisos extends StatefulWidget {
  final VoidCallback onPermisoConcedido; 
  const BotonCamaraPermisos({super.key, required this.onPermisoConcedido});

  @override
  State<BotonCamaraPermisos> createState() => _BotonCamaraPermisosState();
}

class _BotonCamaraPermisosState extends State<BotonCamaraPermisos> {
  Future<void> _manejarPermisoCamara() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      widget.onPermisoConcedido();
    } else if (status.isDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sin acceso a la cámara. Se usará un avatar por defecto.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cámara Bloqueada'),
          content: const Text('Has denegado el acceso permanentemente. Habilítalo en los ajustes del sistema.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(ctx);
              },
              child: const Text('Ir a Ajustes'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _manejarPermisoCamara,
      icon: const Icon(Icons.camera_alt),
      label: const Text('Tomar Foto'),
    );
  }
}

// ==========================================
// 2. BOTÓN DE GUARDAR CON NOTIFICACIÓN
// ==========================================
class BotonGuardarConNotificacion extends StatefulWidget {
  final Future<void> Function() onGuardarPaciente;
  const BotonGuardarConNotificacion({super.key, required this.onGuardarPaciente});

  @override
  State<BotonGuardarConNotificacion> createState() => _BotonGuardarConNotificacionState();
}

class _BotonGuardarConNotificacionState extends State<BotonGuardarConNotificacion> {
  bool _cargando = false;

  Future<void> _ejecutarGuardado() async {
    setState(() => _cargando = true);
    
    final status = await Permission.notification.request();
    await widget.onGuardarPaciente(); // Guarda el dato en SQLite/Backend

    if (status.isDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Guardado offline. Activa las alertas para que la app te avise al sincronizar.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (status.isPermanentlyDenied) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Alertas Desactivadas'),
          content: const Text('No te podremos avisar cuando los datos se envíen al servidor. Puedes activarlas en Ajustes.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Entendido')),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(ctx);
              },
              child: const Text('Ir a Ajustes'),
            ),
          ],
        ),
      );
    }

    if (mounted) setState(() => _cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      onPressed: _cargando ? null : _ejecutarGuardado,
      child: _cargando 
          ? const CircularProgressIndicator(color: Colors.white) 
          : const Text('Guardar', style: TextStyle(color: Colors.white)),
    );
  }
}