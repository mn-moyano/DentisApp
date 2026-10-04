import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  /// Obtiene las cámaras disponibles en el dispositivo.
  Future<List<CameraDescription>> obtenerCamaras() async {
    return availableCameras();
  }

  /// Inicializa el controlador de la cámara.
  Future<CameraController> inicializarCamara(
    CameraDescription camara,
  ) async {
    final controller = CameraController(
      camara,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller.initialize();

    return controller;
  }

  /// Libera los recursos utilizados por la cámara.
  Future<void> liberarCamara(
    CameraController controller,
  ) async {
    await controller.dispose();
  }
}

class BotonCamaraPermisos extends StatefulWidget {
  // Esta función se ejecutará SOLO si el usuario da permiso
  final VoidCallback onPermisoConcedido; 

  const BotonCamaraPermisos({super.key, required this.onPermisoConcedido});

  @override
  State<BotonCamaraPermisos> createState() => _BotonCamaraPermisosState();
}

class _BotonCamaraPermisosState extends State<BotonCamaraPermisos> {
  Future<void> _manejarPermisoCamara() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      // ESTADO 1: Concedido. Ejecuta tu código para abrir la cámara.
      widget.onPermisoConcedido();
    } else if (status.isDenied) {
      // ESTADO 2 y 3: Denegado. Degradación elegante.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sin acceso a la cámara. Se usará un avatar por defecto para el paciente.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // ESTADO 4: Denegado permanentemente. Redirigir a Ajustes.
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cámara Bloqueada'),
          content: const Text('Has denegado el acceso permanentemente. Habilítalo en los ajustes del sistema para poder tomar fotos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Continuar sin foto')
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Abre ajustes del dispositivo
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
      label: const Text('Tomar Foto de Perfil'),
    );
  }
}