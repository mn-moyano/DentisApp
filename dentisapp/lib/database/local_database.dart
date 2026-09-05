import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase instance = LocalDatabase._init();

  LocalDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase('dentisapp.db');

    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pacientes_local (
        id_local INTEGER PRIMARY KEY AUTOINCREMENT,

        id_paciente INTEGER,

        client_id TEXT NOT NULL UNIQUE,

        nombres TEXT NOT NULL,

        apellidos TEXT NOT NULL,

        cedula TEXT NOT NULL,

        telefono TEXT,

        correo TEXT,

        direccion TEXT,

        sync_status TEXT NOT NULL,

        updated_at_server TEXT,

        cached_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_operations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        operation_id TEXT NOT NULL UNIQUE,

        entity_type TEXT NOT NULL,

        entity_client_id TEXT NOT NULL,

        operation_type TEXT NOT NULL,

        payload TEXT NOT NULL,

        retry_count INTEGER DEFAULT 0,

        max_retries INTEGER DEFAULT 5,

        next_retry_at TEXT,

        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE pacientes_local ADD COLUMN direccion TEXT');
    }
  }

  Future<void> cerrar() async {
    final db = await instance.database;

    await db.close();

    _database = null;
  }

  Future<void> eliminarBaseDatos() async {
    await cerrar();

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, 'dentisapp.db');

    await deleteDatabase(path);
  }
}
