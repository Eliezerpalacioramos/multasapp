import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/multa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'multas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE multas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigoMarbete TEXT,
        marca TEXT,
        modelo TEXT,
        color TEXT,
        año INTEGER,
        placa TEXT,
        tipoInfraccion TEXT,
        ubicacionGPS TEXT,
        fechaHora TEXT,
        descripcion TEXT,
        fotos TEXT,
        audioPath TEXT
      )
    ''');
  }

  Future<void> insertMulta(Multa multa) async {
    final db = await database;
    await db.insert('multas', multa.toMap());
  }

  Future<List<Multa>> getMultas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('multas');
    return List.generate(maps.length, (i) {
      return Multa.fromMap(maps[i]);
    });
  }

  Future<void> deleteMultas() async {
    final db = await database;
    await db.delete('multas');
  }
}
