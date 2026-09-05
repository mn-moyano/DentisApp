import 'package:flutter_test/flutter_test.dart';
import 'package:dentisapp/main.dart';
import 'package:dentisapp/services/sync_service.dart';

void main() {
  testWidgets(
    'la app debe iniciar con la pantalla de inicio',
    (tester) async {
      await tester.pumpWidget(
        DentisApp(
          syncService: SyncService(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('DentisApp'), findsWidgets);
      expect(
        find.text('Inicia sesión para continuar'),
        findsOneWidget,
      );
    },
  );
}