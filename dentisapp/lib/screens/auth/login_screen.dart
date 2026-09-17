import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/auth_service.dart';
import '../../theme/app_spacing.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usuarioController = TextEditingController();

  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

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
        username: _usuarioController.text.trim(),
        password: _passwordController.text,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/logo_dentisapp.svg',
                    width: 150,
                    height: 150,
                  ),

                  const SizedBox(
                    height: AppSpacing.md,
                  ),

                  Text(
                    'DentisApp',
                    style: textTheme.displayLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    'Gestión odontológica',
                    style: textTheme.titleMedium,
                  ),

                  const SizedBox(
                    height: AppSpacing.sm,
                  ),

                  Text(
                    'Inicia sesión para continuar',
                    style: textTheme.bodyMedium,
                  ),

                  const SizedBox(
                    height: AppSpacing.xl,
                  ),

                  TextFormField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'Ingrese su usuario',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Ingrese su usuario';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.md,
                  ),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Ingrese su contraseña',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
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
                      if (value == null || value.isEmpty) {
                        return 'Ingrese su contraseña';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton(
                      onPressed:
                          _cargando ? null : _iniciarSesion,
                      child: _cargando
                          ? const SizedBox(
                              width: AppSpacing.md,
                              height: AppSpacing.md,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Iniciar sesión',
                            ),
                    ),
                  ),

                  const SizedBox(
                    height: AppSpacing.md,
                  ),

                  Text(
                    'Si no tiene credenciales, solicítelas '
                    'en la clínica.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
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