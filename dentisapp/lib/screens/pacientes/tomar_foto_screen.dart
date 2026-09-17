import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../services/camera_service.dart';

class TomarFotoScreen extends StatefulWidget {
  const TomarFotoScreen({
    super.key,
  });

  @override
  State<TomarFotoScreen> createState() => _TomarFotoScreenState();
}

class _TomarFotoScreenState extends State<TomarFotoScreen> {
  final CameraService cameraService = CameraService();

  CameraController? controller;

  bool cargando = true;
  String? error;

  Future<bool> _mostrarExplicacionCamara() async {
    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acceso a la cámara'),
          content: const Text(
            'DentisApp necesita acceder a la cámara para '
            'tomar fotografías clínicas del paciente. '
            'La cámara solo se utilizará cuando solicites '
            'tomar una fotografía.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Ahora no'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );

    return resultado ?? false;
  }
  
  Future<void> _iniciarCamaraConExplicacion() async {
    final continuar = await _mostrarExplicacionCamara();

    if (!continuar || !mounted) {
      return;
    }

    await _prepararCamara();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarCamaraConExplicacion();
    });
  }

  Future<void> _prepararCamara() async {
    try {
      final camaras = await cameraService.obtenerCamaras();

      if (camaras.isEmpty) {
        setState(() {
          cargando = false;
          error = 'No hay ninguna cámara disponible.';
        });
        return;
      }

      final camara = camaras.first;

      final nuevoController =
          await cameraService.inicializarCamara(camara);

      if (!mounted) {
        await cameraService.liberarCamara(nuevoController);
        return;
      }

      setState(() {
        controller = nuevoController;
        cargando = false;
      });
    } on CameraException catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = _mensajeErrorCamara(e);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = 'No se pudo iniciar la cámara.';
      });
    }
  }

  String _mensajeErrorCamara(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        return 'El acceso a la cámara fue denegado.';
      case 'CameraAccessDeniedWithoutPrompt':
        return 'El acceso a la cámara está bloqueado. '
            'Actívalo desde los ajustes de la aplicación.';
      case 'CameraAccessRestricted':
        return 'El acceso a la cámara está restringido.';
      default:
        return 'No se pudo acceder a la cámara.';
    }
  }

  Future<void> _tomarFoto() async {
    final cameraController = controller;

    if (cameraController == null ||
        !cameraController.value.isInitialized) {
      return;
    }

    try {
      final foto = await cameraController.takePicture();

      if (!mounted) return;

      Navigator.pop(context, foto.path);
    } on CameraException {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo tomar la fotografía.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    final cameraController = controller;

    if (cameraController != null) {
      cameraService.liberarCamara(cameraController);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fotografía clínica'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fotografía clínica'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotografía clínica'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton(
              onPressed: _tomarFoto,
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}