import 'package:sqflite/sqflite.dart';

import '../model/from_api/restaurant.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblWishlist = 'wishlist';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant_app.db',
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tblWishlist (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating REAL
        )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<List<Restaurant>> getWishlist() async {
    final db = await database;
    final result = await db!.query(_tblWishlist);

    return result.map((e) => Restaurant.fromJson(e)).toList();
  }

  Future<void> insertWishlist(Restaurant restaurant) async {
    final db = await database;
    await db!.insert(_tblWishlist, restaurant.toJson());
  }

  Future<Map> getWishlistById(String id) async {
    final db = await database;
    final result = await db!.query(
      _tblWishlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }

  Future<void> deleteWishlist(String id) async {
    final db = await database;
    await db!.delete(
      _tblWishlist,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
