import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    if (_database != null) {
      return _database!;
    }

    String path = join(await getDatabasesPath(), 'my_database.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT)',
        );
      },
    );

    return _database!;
  }

  Future<int?> insertUser(String email, String password) async {
    // Ensure that the database is initialized
    if (_database == null) {
      await initializeDatabase();
    }

    // Insert the user into the database
    Map<String, dynamic> user = {
      'email': email,
      'password': password,
    };
    int? userId = await _database?.insert('users', user);

    return userId;
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    // Ensure that the database is initialized
    if (_database == null) {
      await initializeDatabase();
    }

    // Query the database for the user
    List<Map<String, Object?>>? results = await _database?.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (results!.isNotEmpty) {
      // Return the user data
      return results.first;
    } else {
      // User not found
      return null;
    }
  }
}
