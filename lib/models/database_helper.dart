import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/booking_model.dart';

class DatabaseHelper {
  late final Future<Database> _db;

  DatabaseHelper() {
    _db = initDatabase();
  }

  Future<String> getDatabasePath() async {
    String currentDirectory = Directory.current.path;
    String databasePath = '$currentDirectory/booking.db';

    if (kDebugMode) {
      print(databasePath);
    }

    return databasePath;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'booking.db');
    final Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE bookings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerName TEXT,
            customerEmail TEXT,
            customerID TEXT,
            contactNo TEXT,
            movieTitle TEXT,
            tickets INTEGER,
            dateTime TEXT,
            timeSlot TEXT
          )
        ''');
      },
    );
    return database;
  }

  Future<Booking?> getBookingByDateTime(String dateTime, String timeSlot) async {
    final dbClient = await _db;
    final result = await dbClient.query(
      'bookings',
      where: 'dateTime = ? AND timeSlot = ?',
      whereArgs: [dateTime, timeSlot],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return Booking.fromMap(result.first);
    }
    return null;
  }

  Future<void> insertBooking(Map<String, dynamic> bookingMap) async {
    final dbClient = await _db;
    await dbClient.insert(
      'bookings',
      bookingMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
