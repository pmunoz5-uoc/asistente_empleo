import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import 'profile_repository.dart';
import 'user_profile.dart';

class SqliteProfileRepository implements ProfileRepository {
  SqliteProfileRepository({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;
  //Operación para devolver el perfil.
  @override
  Future<UserProfile?> load() async {
    try {
      final database = await _database.database;
      final rows = await database.query(
        'user_profile',
        where: 'id = ?',
        whereArgs: [1],
        limit: 1,
      );
      if (rows.isEmpty) return null;

      final row = rows.single;
      return UserProfile(
        fullName: row['full_name'] as String,
        position: row['position'] as String? ?? '',
        email: row['email'] as String,
        phone: row['phone'] as String,
        cvText: row['cv_text'] as String,
        originalPdfName: row['original_pdf_name'] as String?,
        originalPdfBytes: row['original_pdf_bytes'] as Uint8List?,
        updatedAt: DateTime.parse(row['updated_at'] as String),
      );
    } on DatabaseException catch (error) {
      throw ProfileStorageException('No se pudo cargar el perfil: $error');
    }
  }

  //Operación para guardar el perfil.
  @override
  Future<void> save(UserProfile profile) async {
    try {
      final database = await _database.database;
      await database.insert('user_profile', {
        'id': 1,
        'full_name': profile.fullName,
        'position': profile.position,
        'email': profile.email,
        'phone': profile.phone,
        'cv_text': profile.cvText,
        'original_pdf_name': profile.originalPdfName,
        'original_pdf_bytes': profile.originalPdfBytes,
        'updated_at': profile.updatedAt.toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } on DatabaseException catch (error) {
      throw ProfileStorageException('No se pudo guardar el perfil: $error');
    }
  }
}
