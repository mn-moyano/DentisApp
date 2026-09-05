import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../home_screen.dart';
import 'login_screen.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() =>
      _SessionGateState();
}

class _SessionGateState
    extends State<SessionGate> {
  final AuthService _authService =
      AuthService();

  @override
  void initState() {
    super.initState();

    _verificarSesion();
  }

  Future<void> _verificarSesion() async {
    final tieneSesion =
        await _authService.tieneSesionActiva();

    if (!mounted) return;

    if (!tieneSesion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );

      return;
    }

    final rol = await _authService.obtenerRol();

    if (!mounted) return;

    if (rol == 'Administrador') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );

      return;
    }

    // Si el token existe pero el rol no está
    // autorizado, cerramos la sesión.
    await _authService.cerrarSesion();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}