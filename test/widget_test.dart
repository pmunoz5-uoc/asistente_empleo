import 'package:asistente_empleo/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
//Fichero Test para comprobar la correcta carga de la app y la navegación entre ventanas.
void main() {
  testWidgets('se puede abrir cada pantalla principal', (tester) async {
    await tester.pumpWidget(const EmploymentAssistantApp());
    expect(find.text('Inicio'), findsWidgets);

    await tester.tap(find.text('Analizar oferta'));
    await tester.pumpAndSettle();
    expect(find.text('Nueva oferta'), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Aún no hay datos de perfil'), findsOneWidget);
    await tester.tap(find.text('Cargar CV y completar perfil'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('fullNameField')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Candidaturas'));
    await tester.pumpAndSettle();
    expect(find.text('No hay candidaturas que mostrar.'), findsOneWidget);
  });
}
