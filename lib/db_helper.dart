import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shoe_store.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE shoes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            brand TEXT,
            size TEXT,
            purchaseDate TEXT,
            buyerName TEXT
          )
          ''',
        );
      },
    );
  }

  Future<int> insertShoe(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('shoes', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query('shoes');
  }

  Future<int> updateShoe(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('shoes', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteShoe(int id) async {
    Database db = await database;
    return await db.delete('shoes', where: 'id = ?', whereArgs: [id]);
  }
}
