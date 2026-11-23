import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase({DatabaseFactory? factory, this.databasePath})
    : _databaseFactory = factory ?? databaseFactory;

  static const _databaseName = 'asistente_empleo.db';

  final DatabaseFactory _databaseFactory;
  final String? databasePath;
  Future<Database>? _database;

  //Operación para abrir la BBDD.
  Future<Database> get database => _database ??= _openDatabase();

  //Operación para abrir la BBDD.
  Future<Database> _openDatabase() async {
    final filePath =
        databasePath ??
        path.join(await _databaseFactory.getDatabasesPath(), _databaseName);

    return _databaseFactory.openDatabase(
      filePath,
      options: OpenDatabaseOptions(
        version: 4,
        onCreate: (database, version) async {
          //Operación para crear la tabla de perfil.
          await _createProfileTable(database);
          //Operación para crear la tabla de candidaturas.
          await _createApplicationsTable(database);
        },
        onUpgrade: (database, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await _ensureColumn(
              database,
              'user_profile',
              'position',
              "TEXT NOT NULL DEFAULT ''",
            );
          }
          if (oldVersion < 3) {
            //Operación para crear tabla de candidaturas.
            await _createApplicationsTable(database);
          }
          if (oldVersion < 4) {
            //Operación para crear las columnas relacionadas con PDF cuando se cargue un documento.
            await _ensurePdfColumns(database);
          }
        },
      ),
    );
  }

  //Operación para crear la tabla de perfil.
  Future<void> _createProfileTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS user_profile (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        full_name TEXT NOT NULL,
        position TEXT NOT NULL DEFAULT '',
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        cv_text TEXT NOT NULL,
        original_pdf_name TEXT,
        original_pdf_bytes BLOB,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  //Operación para crear la tabla de candidaturas.
  Future<void> _createApplicationsTable(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS applications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        company TEXT NOT NULL,
        offer_description TEXT NOT NULL,
        offer_url TEXT NOT NULL DEFAULT '',
        contact TEXT NOT NULL DEFAULT '',
        notes TEXT NOT NULL DEFAULT '',
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        next_action_at TEXT,
        cv_adapted TEXT NOT NULL DEFAULT '',
        cover_letter TEXT NOT NULL DEFAULT ''
      )
    ''');
  }

  //Operación para crear las columnas relacionadas con PDF cuando se cargue un documento.
  Future<void> _ensurePdfColumns(Database database) async {
    await _ensureColumn(database, 'user_profile', 'original_pdf_name', 'TEXT');
    await _ensureColumn(database, 'user_profile', 'original_pdf_bytes', 'BLOB');
  }

  Future<void> _ensureColumn(
    Database database,
    String table,
    String column,
    String definition,
  ) async {
    final columns = await database.rawQuery('PRAGMA table_info($table)');
    if (columns.any((row) => row['name'] == column)) return;
    await database.execute('ALTER TABLE $table ADD COLUMN $column $definition');
  }
}
