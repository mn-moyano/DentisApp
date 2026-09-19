import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _inicializado = false;

  Future<void> inicializar() async {
    if (_inicializado) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notifications.initialize(settings);

    _inicializado = true;
  }

  Future<bool?> solicitarPermiso() async {
    await inicializar();

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      return androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      return iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return null;
  }

  Future<void> mostrarNotificacion({
    required int id,
    required String titulo,
    required String mensaje,
  }) async {
    await inicializar();

    const androidDetails = AndroidNotificationDetails(
      'dentisapp_general',
      'Notificaciones de DentisApp',
      channelDescription: 'Avisos importantes de DentisApp.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notifications.show(
      id,
      titulo,
      mensaje,
      notificationDetails,
    );
  }
}