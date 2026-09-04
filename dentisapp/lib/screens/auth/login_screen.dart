import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usuarioController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final AuthService _authService =
      AuthService();

  bool _cargando = false;

  bool _ocultarPassword = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      await _authService.login(
        username:
            _usuarioController.text.trim(),
        password:
            _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString()
                .replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  const Icon(
                    Icons.local_hospital,
                    size: 80,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'DentisApp',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Inicia sesión para continuar',
                  ),

                  const SizedBox(height: 40),

                  TextFormField(
                    controller:
                        _usuarioController,
                    decoration:
                        const InputDecoration(
                      labelText: 'Usuario',
                      border:
                          OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Ingrese su usuario';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller:
                        _passwordController,
                    obscureText:
                        _ocultarPassword,
                    decoration:
                        InputDecoration(
                      labelText:
                          'Contraseña',
                      border:
                          const OutlineInputBorder(),
                      prefixIcon:
                          const Icon(
                            Icons.lock,
                          ),
                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword =
                                !_ocultarPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return
                            'Ingrese su contraseña';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          _cargando
                              ? null
                              : _iniciarSesion,
                      child:
                          _cargando
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Iniciar sesión',
                                ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Usuario de prueba: admin\n'
                    'Contraseña: 1234',
                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}