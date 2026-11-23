import 'dart:io';

import 'package:asistente_empleo/features/applications/sqlite_application_repository.dart';
import 'package:asistente_empleo/features/database/app_database.dart';
import 'package:asistente_empleo/features/profile/sqlite_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('migra el perfil desde la versión 1 y crea ambas tablas', () async {
    sqfliteFfiInit();
    final temporaryDirectory = await Directory.systemTemp.createTemp(
      'asistente_empleo_database_test_',
    );
    final databasePath = path.join(temporaryDirectory.path, 'legacy.db');
    Database? database;
    addTearDown(() async {
      await database?.close();
      await temporaryDirectory.delete(recursive: true);
    });

    final legacyDatabase = await databaseFactoryFfi.openDatabase(
      databasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE user_profile (
              id INTEGER PRIMARY KEY CHECK (id = 1),
              full_name TEXT NOT NULL,
              email TEXT NOT NULL,
              phone TEXT NOT NULL,
              cv_text TEXT NOT NULL,
              updated_at TEXT NOT NULL
            )
          ''');
          await database.insert('user_profile', {
            'id': 1,
            'full_name': 'Ana García',
            'email': 'ana@example.com',
            'phone': '',
            'cv_text': 'CV existente',
            'updated_at': DateTime.utc(2026, 11, 18).toIso8601String(),
          });
        },
      ),
    );
    await legacyDatabase.close();

    final appDatabase = AppDatabase(
      factory: databaseFactoryFfi,
      databasePath: databasePath,
    );
    database = await appDatabase.database;
    final profile = await SqliteProfileRepository(database: appDatabase).load();
    final applications = await SqliteApplicationRepository(
      database: appDatabase,
    ).loadAll();

    expect(profile?.fullName, 'Ana García');
    expect(profile?.position, '');
    expect(applications, isEmpty);

    final profileColumns = await database.rawQuery(
      'PRAGMA table_info(user_profile)',
    );
    expect(
      profileColumns.map((column) => column['name']),
      containsAll(['position', 'original_pdf_name', 'original_pdf_bytes']),
    );
  });
}
