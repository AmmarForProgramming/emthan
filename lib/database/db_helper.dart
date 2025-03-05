//import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';
import '../models/sale_model.dart';
import '../models/purchase_model.dart';
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
 
   static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('shop_manager.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL
      );
    ''');

    await db.execute('''
     CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        quantity INTEGER NOT NULL DEFAULT 0
      
      )
    ''');

    await db.execute('''
     CREATE TABLE purchases (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_cost REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        productName TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

await db.execute('''
     CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        language TEXT DEFAULT 'ar',
        notifications_enabled INTEGER DEFAULT 1
      )
    ''');
await db.execute('''
  CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    date TEXT NOT NULL,
    is_read INTEGER DEFAULT 0
  )
''');



  }
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

   Future<int> addProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  
  
  Future<int> deleteProduct(int id) async {
    Database db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

   Future<int> addPurchase(Purchase purchase) async {
    Database db = await database;
    return await db.insert('purchases', purchase.toMap());
  }

  Future<List<Purchase>> getPurchases() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('purchases');
    return result.map((map) => Purchase.fromMap(map)).toList();
  }
 

  Future<List<Sale>> getSales() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query('sales');
    return result.map((map) => Sale.fromMap(map)).toList();
  }
Future<int> addSale(Sale sale) async {
    Database db = await database;
    return await db.insert('sales', sale.toMap());
  }
Future<void>updateProductqun(int product_id,int quantity)async{
final db=await database;
await db.rawUpdate('UPDATE products SET quantity=quantity + ? WHERE id=?',[quantity,product_id],);

}

}

  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'store_manager.db');
    await databaseFactory.deleteDatabase(path);
  }





