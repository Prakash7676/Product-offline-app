import 'package:path/path.dart';
import 'package:product_offline_app/product.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  String dbName = "pms.db";
  String tableName = "products";

  DatabaseHelper._init();

  Future<Database> get database async {
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    String sql = """
  CREATE TABLE "$tableName" (
	"id"	INTEGER,
	"title"	TEXT NOT NULL,
	"description"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);

 """;
    await db.execute(sql);
  }

  Future<Product> addProduct(Product p) async {
    final db = await instance.database;
    final id = await db.insert(tableName, p.toMap());
    return p.copy(id: id);
  }

  Future<List<Product>> listAllProduct() async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index) {
      return Product(
          id: maps[index]['id'],
          title: maps[index]['title'],
          description: maps[index]['description']);
    }).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  //delete
  Future<bool> deleteProduct(int id) async {
    try {
      // Get a reference to the database.
      final db = await instance.database;

      // Remove the product from the database.
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updateProduct(Product p) async {
    // Get a reference to the database.
    try {
      final db = await database;

      await db.update(
        tableName,
        p.toMap(),
        where: 'id = ?', //if we put value instead of ? than hacker will hack it
        whereArgs: [p.id],
      );
      return true;
    } catch (ex) {
      return false;
    }
  }
}
