import 'package:asistente_empleo/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('muestra el dashboard inicial y sus métricas vacías', (
    tester,
  ) async {
    await tester.pumpWidget(const EmploymentAssistantApp());

    expect(find.text('Inicio'), findsNWidgets(2));
    expect(find.text('Ofertas guardadas'), findsOneWidget);
    expect(find.text('Análisis realizados'), findsOneWidget);
    expect(find.text('Candidaturas'), findsNWidgets(2));
    expect(find.text('0'), findsNWidgets(3));
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('la navegación abre placeholders y permite volver al inicio', (
    tester,
  ) async {
    await tester.pumpWidget(const EmploymentAssistantApp());

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Esta pantalla está pendiente.'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Inicio'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Resumen de tu búsqueda de empleo.'),
      findsOneWidget,
    );
  });
}
