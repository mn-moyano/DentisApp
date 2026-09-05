import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/auth/session_gate.dart';
import 'services/sync_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final syncService = SyncService();

  runApp(
    ProviderScope(
      child: DentisApp(
        syncService: syncService,
      ),
    ),
  );
}

class DentisApp extends StatelessWidget {
  const DentisApp({
    super.key,
    required this.syncService,
  });

  final SyncService syncService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DentisApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: SessionGate(
        syncService: syncService,
      ),
    );
  }
}