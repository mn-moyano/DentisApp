import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/camera_service.dart';

class TomarFotoScreen extends StatefulWidget {
  const TomarFotoScreen({super.key});

  @override
  State<TomarFotoScreen> createState() => _TomarFotoScreenState();
}

class _TomarFotoScreenState extends State<TomarFotoScreen> {
  final CameraService cameraService = CameraService();

  CameraController? controller;

  bool cargando = true;
  String? error;
  bool permisoBloqueado = false;

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
      if (mounted) {
        Navigator.pop(context);
      }

      return;
    }

    await _solicitarPermisoYPrepararCamara();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _iniciarCamaraConExplicacion();
    });
  }

  Future<void> _solicitarPermisoYPrepararCamara() async {
    setState(() {
      cargando = true;
      error = null;
      permisoBloqueado = false;
    });

    final estado = await Permission.camera.status;

    if (estado.isGranted) {
      await _prepararCamara();
      return;
    }

    if (estado.isPermanentlyDenied) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error =
            'El acceso a la cámara está bloqueado. '
            'Activa el permiso desde los ajustes de la aplicación.';
        permisoBloqueado = true;
      });

      return;
    }

    if (estado.isRestricted) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = 'El acceso a la cámara está restringido.';
      });

      return;
    }

    final resultado = await Permission.camera.request();

    if (!mounted) return;

    if (resultado.isGranted) {
      await _prepararCamara();
      return;
    }

    if (resultado.isPermanentlyDenied) {
      setState(() {
        cargando = false;
        error =
            'El acceso a la cámara está bloqueado. '
            'Activa el permiso desde los ajustes de la aplicación.';
        permisoBloqueado = true;
      });

      return;
    }

    if (resultado.isRestricted) {
      setState(() {
        cargando = false;
        error = 'El acceso a la cámara está restringido.';
        permisoBloqueado = false;
      });

      return;
    }

    setState(() {
      cargando = false;
      error =
          'El acceso a la cámara fue denegado.\n\n'
          'Para utilizar esta función, habilita el permiso '
          'desde los ajustes de la aplicación.\n\n'
          'Ajustes → Permisos → Cámara → '
          'Permitir al usar la app';
      permisoBloqueado = true;
    });
  }

  Future<void> _prepararCamara() async {
    try {
      final camaras = await cameraService.obtenerCamaras();

      if (camaras.isEmpty) {
        if (!mounted) return;

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
        error = null;
        permisoBloqueado = false;
      });
    } on CameraException catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = _mensajeErrorCamara(e);
        permisoBloqueado =
            e.code == 'CameraAccessDeniedWithoutPrompt';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = 'No se pudo iniciar la cámara.';
        permisoBloqueado = false;
      });
    }
  }

  String _mensajeErrorCamara(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        return 'El acceso a la cámara fue denegado.\n\n'
            'Para utilizar esta función, habilita el permiso '
            'desde los ajustes de la aplicación.\n\n'
            'Ajustes → Permisos → Cámara → '
            'Permitir al usar la app';

      case 'CameraAccessDeniedWithoutPrompt':
        return 'El acceso a la cámara está bloqueado.\n\n'
            'Activa el permiso desde los ajustes de la aplicación.';

      case 'CameraAccessRestricted':
        return 'El acceso a la cámara está restringido.';

      default:
        return 'No se pudo acceder a la cámara.';
    }
  }

  Future<void> _abrirAjustes() async {
    final abierto = await openAppSettings();

    if (!abierto && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudieron abrir los ajustes de la aplicación.',
          ),
        ),
      );
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 56,
                ),
                const SizedBox(height: 16),
                Text(
                  error!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (permisoBloqueado)
                  ElevatedButton.icon(
                    onPressed: _abrirAjustes,
                    icon: const Icon(Icons.settings),
                    label: const Text('Abrir ajustes'),
                  ),
              ],
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