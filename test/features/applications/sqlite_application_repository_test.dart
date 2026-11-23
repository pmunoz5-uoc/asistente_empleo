import 'package:asistente_empleo/features/applications/application_status.dart';
import 'package:asistente_empleo/features/applications/job_application.dart';
import 'package:asistente_empleo/features/applications/sqlite_application_repository.dart';
import 'package:asistente_empleo/features/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('guarda y recupera una candidatura desde SQLite', () async {
    sqfliteFfiInit();
    final repository = SqliteApplicationRepository(
      database: AppDatabase(
        factory: databaseFactoryFfi,
        databasePath: inMemoryDatabasePath,
      ),
    );
    final now = DateTime.utc(2026, 11, 21);
    final application = JobApplication(
      id: 0,
      title: 'Desarrollador Flutter',
      company: 'Empresa ejemplo',
      offerDescription: 'Desarrollo de aplicaciones móviles.',
      offerUrl: 'https://example.com/oferta',
      contact: 'personas@example.com',
      notes: 'Contactar el viernes.',
      status: ApplicationStatus.interesting,
      createdAt: now,
      updatedAt: now,
    );

    final saved = await repository.save(application);
    final loaded = await repository.loadAll();

    expect(saved.id, greaterThan(0));
    expect(loaded, hasLength(1));
    expect(loaded.first.title, application.title);
    expect(loaded.first.company, application.company);
    expect(loaded.first.offerDescription, application.offerDescription);
    expect(loaded.first.offerUrl, application.offerUrl);
    expect(loaded.first.contact, application.contact);
    expect(loaded.first.notes, application.notes);
    expect(loaded.first.status, application.status);
  });
}
