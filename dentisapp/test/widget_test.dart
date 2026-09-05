import 'package:flutter_test/flutter_test.dart';
import 'package:dentisapp/main.dart';

void main() {
  testWidgets('la app debe iniciar con la pantalla de inicio', (tester) async {
    await tester.pumpWidget(const DentisApp());
    await tester.pumpAndSettle();

    expect(find.text('DentisApp'), findsWidgets);
    expect(find.text('Inicia sesión para continuar'), findsOneWidget);
  });
}
