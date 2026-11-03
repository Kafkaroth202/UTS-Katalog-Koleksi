import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Rename this to force the database to be recreated (e.g. after changing
  // the table structure).
  static const String _dbName = 'katalog_koleksi_v3.db';

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // The table starts empty: the user adds every item manually.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        creator TEXT,
        year INTEGER,
        status TEXT NOT NULL,
        rating REAL,
        description TEXT,
        image_url TEXT
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toMap()..remove('id'));
  }

  Future<List<Item>> getItems() async {
    final db = await database;
    final result = await db.query('items', orderBy: 'id DESC');
    return result.map((m) => Item.fromMap(m)).toList();
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
