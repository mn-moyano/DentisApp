import 'package:flutter_test/flutter_test.dart';
import 'package:dentisapp/main.dart';

void main() {
  testWidgets('la app debe iniciar con la pantalla de inicio', (tester) async {
    await tester.pumpWidget(const DentisApp());

    expect(find.text('DentisApp'), findsWidgets);
    expect(find.text('Pacientes'), findsOneWidget);
  });
}
