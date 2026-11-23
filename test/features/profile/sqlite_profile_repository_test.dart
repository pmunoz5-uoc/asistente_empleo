import 'dart:typed_data';

import 'package:asistente_empleo/features/profile/sqlite_profile_repository.dart';
import 'package:asistente_empleo/features/profile/user_profile.dart';
import 'package:asistente_empleo/features/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('guarda y recupera el perfil desde SQLite', () async {
    sqfliteFfiInit();
    final repository = SqliteProfileRepository(
      database: AppDatabase(
        factory: databaseFactoryFfi,
        databasePath: inMemoryDatabasePath,
      ),
    );
    final profile = UserProfile(
      fullName: 'Ana García',
      position: 'Analista de datos',
      email: 'ana@example.com',
      phone: '+34 600 000 000',
      cvText: 'Experiencia en desarrollo.',
      originalPdfName: 'cv.pdf',
      originalPdfBytes: Uint8List.fromList([37, 80, 68, 70]),
      updatedAt: DateTime.utc(2026, 11, 18),
    );

    await repository.save(profile);
    final loaded = await repository.load();

    expect(loaded?.fullName, profile.fullName);
    expect(loaded?.position, profile.position);
    expect(loaded?.email, profile.email);
    expect(loaded?.phone, profile.phone);
    expect(loaded?.cvText, profile.cvText);
    expect(loaded?.originalPdfName, profile.originalPdfName);
    expect(loaded?.originalPdfBytes, orderedEquals(profile.originalPdfBytes!));
    expect(loaded?.updatedAt, profile.updatedAt);
  });
}
