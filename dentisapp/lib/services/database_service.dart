import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Servicio encargado de administrar la base de datos local SQLite.
///
/// Contiene:
/// - Tabla de pacientes.
/// - Tabla de operaciones pendientes.
/// - Control de versiones.
/// - Migraciones futuras.
/// - Limpieza completa de datos al cerrar sesión.
class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static Database? _database;

  /// Nombre de la base de datos local.
  static const String _databaseName = 'dentisapp.db';

  /// Versión actual de la base de datos.
  ///
  /// Cuando se modifique el esquema en el futuro,
  /// se debe incrementar este número.
  static const int _databaseVersion = 1;

  /// Nombre de la tabla de pacientes.
  static const String pacientesTable = 'pacientes';

  /// Nombre de la tabla que almacena las operaciones
  /// pendientes de sincronización.
  static const String pendingOperationsTable = 'pending_operations';

  /// Obtiene la instancia de la base de datos.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  /// Inicializa la base de datos SQLite.
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();

    final path = join(
      databasesPath,
      _databaseName,
    );

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Se ejecuta únicamente cuando la base de datos
  /// se crea por primera vez.
  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    await _createPacientesTable(db);

    await _createPendingOperationsTable(db);
  }

  /// Se ejecuta cuando aumenta la versión de la
  /// base de datos.
  ///
  /// Aquí se colocarán las futuras migraciones.
  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    /*
    ============================================================
    MIGRACIONES FUTURAS
    ============================================================

    Ejemplo:

    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE pacientes
        ADD COLUMN nuevo_campo TEXT
      ''');
    }

    if (oldVersion < 3) {
      ...
    }

    ============================================================
    */
  }

  /// Crea la tabla local de pacientes.
  ///
  /// Incluye información necesaria para:
  /// - Funcionamiento offline.
  /// - Identificador único generado por el cliente.
  /// - Estado de sincronización.
  /// - Control de fechas locales y del servidor.
  Future<void> _createPacientesTable(Database db) async {
    await db.execute('''
      CREATE TABLE $pacientesTable (
        local_id INTEGER PRIMARY KEY AUTOINCREMENT,

        id_paciente INTEGER,

        client_id TEXT NOT NULL UNIQUE,

        nombres TEXT NOT NULL,

        apellidos TEXT NOT NULL,

        cedula TEXT NOT NULL,

        fecha_nacimiento TEXT,

        telefono TEXT,

        correo TEXT,

        direccion TEXT,

        sync_status TEXT NOT NULL DEFAULT 'synced',

        updated_at_local TEXT NOT NULL,

        updated_at_server TEXT
      )
    ''');
  }

  /// Crea la tabla de operaciones pendientes.
  ///
  /// Esta tabla permite:
  /// - Guardar operaciones realizadas sin conexión.
  /// - Reintentar automáticamente.
  /// - Evitar duplicados mediante operation_id.
  /// - Guardar errores de sincronización.
  Future<void> _createPendingOperationsTable(
    Database db,
  ) async {
    await db.execute('''
      CREATE TABLE $pendingOperationsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        operation_id TEXT NOT NULL UNIQUE,

        entity_type TEXT NOT NULL,

        operation_type TEXT NOT NULL,

        client_id TEXT NOT NULL,

        payload TEXT NOT NULL,

        attempts INTEGER NOT NULL DEFAULT 0,

        created_at TEXT NOT NULL,

        next_retry_at TEXT,

        last_error TEXT
      )
    ''');
  }

  /// Elimina todos los datos locales.
  ///
  /// Este método debe ejecutarse durante el cierre de sesión
  /// para cumplir con el requisito de protección de datos
  /// personales del taller.
  Future<void> clearAllData() async {
    final db = await database;

    await db.transaction((txn) async {
      await txn.delete(pendingOperationsTable);

      await txn.delete(pacientesTable);
    });
  }

  /// Cierra la conexión con SQLite.
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();

      _database = null;
    }
  }

  /// Elimina físicamente la base de datos.
  ///
  /// Se puede utilizar en pruebas o durante el cierre
  /// de sesión si se desea borrar completamente el archivo.
  Future<void> deleteDatabaseFile() async {
    await closeDatabase();

    final databasesPath = await getDatabasesPath();

    final path = join(
      databasesPath,
      _databaseName,
    );

    await deleteDatabase(path);
  }
}