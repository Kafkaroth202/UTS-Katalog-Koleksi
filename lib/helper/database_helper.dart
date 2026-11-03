import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Rename this to force the database (and the seed data) to be recreated.
  static const String _dbName = 'katalog_koleksi_v1.db';

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

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        subtype TEXT,
        title TEXT NOT NULL,
        creator TEXT,
        year INTEGER,
        category TEXT,
        status TEXT NOT NULL,
        rating INTEGER,
        review TEXT,
        image_url TEXT
      )
    ''');

    final seed = [
      Item(
        type: 'book',
        title: 'Dune',
        creator: 'Frank Herbert',
        year: 1965,
        category: 'Sci-Fi',
        status: 'done',
        rating: 5,
        review:
            'A dense, patient story about politics, ecology and prophecy. '
            'The worldbuilding takes effort at first but pays off completely '
            'by the second half.',
        imageUrl: 'https://picsum.photos/seed/dune/300/400',
      ),
      Item(
        type: 'movie',
        title: 'Spirited Away',
        creator: 'Hayao Miyazaki',
        year: 2001,
        category: 'Fantasy',
        status: 'wishlist',
        imageUrl: 'https://picsum.photos/seed/spirited/300/400',
      ),
      Item(
        type: 'anime',
        title: 'Cowboy Bebop',
        creator: 'Sunrise',
        year: 1998,
        category: 'Action',
        status: 'ongoing',
        rating: 4,
        review: 'Stylish episodic storytelling with a great soundtrack.',
        imageUrl: 'https://picsum.photos/seed/bebop/300/400',
      ),
      Item(
        type: 'game',
        title: 'Hollow Knight',
        creator: 'Team Cherry',
        year: 2017,
        category: 'Adventure',
        status: 'done',
        rating: 5,
        review:
            'Atmospheric exploration with tight combat. The map is huge and '
            'the bosses are memorable.',
        imageUrl: 'https://picsum.photos/seed/hollow/300/400',
      ),
      Item(
        type: 'other',
        subtype: 'Manga',
        title: 'Vagabond',
        creator: 'Takehiko Inoue',
        year: 1998,
        category: 'Drama',
        status: 'wishlist',
        imageUrl: 'https://picsum.photos/seed/vagabond/300/400',
      ),
    ];

    for (final item in seed) {
      await db.insert('items', item.toMap()..remove('id'));
    }
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
