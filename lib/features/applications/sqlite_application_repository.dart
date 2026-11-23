import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import 'application_repository.dart';
import 'application_status.dart';
import 'job_application.dart';

class SqliteApplicationRepository implements ApplicationRepository {
  SqliteApplicationRepository({AppDatabase? database})
    : _database = database ?? AppDatabase();

  final AppDatabase _database;

  Map<String, Object?> _toRow(JobApplication application) => {
    'title': application.title,
    'company': application.company,
    'offer_description': application.offerDescription,
    'offer_url': application.offerUrl,
    'contact': application.contact,
    'notes': application.notes,
    'status': application.status.databaseValue,
    'created_at': application.createdAt.toIso8601String(),
    'updated_at': application.updatedAt.toIso8601String(),
  };

  JobApplication _fromRow(Map<String, Object?> row) {
    return JobApplication(
      id: row['id'] as int,
      title: row['title'] as String,
      company: row['company'] as String,
      offerDescription: row['offer_description'] as String,
      offerUrl: row['offer_url'] as String? ?? '',
      contact: row['contact'] as String? ?? '',
      notes: row['notes'] as String? ?? '',
      status: ApplicationStatusText.fromDatabase(row['status'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  //Operación para devolver todas las candidaturas.
  @override
  Future<List<JobApplication>> loadAll() async {
    try {
      final database = await _database.database;
      final rows = await database.query(
        'applications',
        orderBy: 'created_at DESC',
      );
      return rows.map(_fromRow).toList();
    } on DatabaseException catch (error) {
      throw ApplicationStorageException(
        'No se pudieron cargar las candidaturas: $error',
      );
    }
  }

  //Operación para guardar una candidatura.
  @override
  Future<JobApplication> save(JobApplication application) async {
    try {
      final database = await _database.database;
      final id = await database.insert('applications', _toRow(application));
      return JobApplication(
        id: id,
        title: application.title,
        company: application.company,
        offerDescription: application.offerDescription,
        offerUrl: application.offerUrl,
        contact: application.contact,
        notes: application.notes,
        status: application.status,
        createdAt: application.createdAt,
        updatedAt: application.updatedAt,
      );
    } on DatabaseException catch (error) {
      throw ApplicationStorageException(
        'No se pudo guardar la candidatura: $error',
      );
    }
  }
}
