import 'package:camera/camera.dart';

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