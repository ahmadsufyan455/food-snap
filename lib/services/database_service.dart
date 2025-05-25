import 'package:food_snap/models/food_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tableFood = 'foods';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/food.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tableFood (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      path Text,
      label TEXT,
      confidenceScore REAL,
      calories TEXT,
      carbohydrates TEXT,
      fat TEXT,
      fiber TEXT,
      protein TEXT
    );
  ''');
  }

  Future<void> insertFood(FoodTable food) async {
    final db = await database;
    await db!.insert(
      _tableFood,
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FoodTable>> getAllFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db!.query(_tableFood);
    return result.map((map) => FoodTable.fromMap(map)).toList();
  }

  Future<FoodTable?> getFoodById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db!.query(
      _tableFood,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return FoodTable.fromMap(result.first);
    }
    return null;
  }
}
