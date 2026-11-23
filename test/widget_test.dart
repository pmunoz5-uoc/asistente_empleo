import 'package:asistente_empleo/main.dart';
import 'package:asistente_empleo/features/applications/application_repository.dart';
import 'package:asistente_empleo/features/applications/application_status.dart';
import 'package:asistente_empleo/features/applications/job_application.dart';
import 'package:asistente_empleo/features/profile/profile_repository.dart';
import 'package:asistente_empleo/features/profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

//Fichero Test para comprobar la correcta carga de la app y la navegación entre ventanas.
void main() {
  testWidgets('se puede abrir cada pantalla principal', (tester) async {
    await tester.pumpWidget(
      const EmploymentAssistantApp(
        profileRepository: _MemoryProfileRepository(),
        applicationRepository: _MemoryApplicationRepository(),
      ),
    );
    expect(find.text('Inicio'), findsWidgets);

    await tester.tap(find.text('Analizar oferta'));
    await tester.pumpAndSettle();
    expect(find.text('Nueva oferta'), findsOneWidget);

    await tester.tap(find.text('Perfil'));
    await tester.pumpAndSettle();
    expect(find.text('Aún no hay datos de perfil'), findsOneWidget);
    await tester.tap(find.text('Completar perfil'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('fullNameField')), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Candidaturas'));
    await tester.pumpAndSettle();
    expect(find.text('No hay candidaturas que mostrar.'), findsOneWidget);
  });

  testWidgets('el dashboard muestra el número de candidaturas guardadas', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 11, 23);
    final application = JobApplication(
      id: 1,
      title: 'Desarrollador Flutter',
      company: 'Empresa ejemplo',
      offerDescription: 'Desarrollo de aplicaciones.',
      status: ApplicationStatus.saved,
      createdAt: now,
      updatedAt: now,
    );

    await tester.pumpWidget(
      EmploymentAssistantApp(
        profileRepository: const _MemoryProfileRepository(),
        applicationRepository: _MemoryApplicationRepository(
          applications: [application],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}

class _MemoryProfileRepository implements ProfileRepository {
  const _MemoryProfileRepository();

  @override
  Future<UserProfile?> load() async => null;

  @override
  Future<void> save(UserProfile profile) async {}
}

class _MemoryApplicationRepository implements ApplicationRepository {
  const _MemoryApplicationRepository({this.applications = const []});

  final List<JobApplication> applications;

  @override
  Future<List<JobApplication>> loadAll() async => applications;

  @override
  Future<JobApplication> save(JobApplication application) async => application;
}
