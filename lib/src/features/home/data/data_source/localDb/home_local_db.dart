import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';

class HomeLocalDb {
  Database? _database;
  static const favoriteTableName = "favorite_history";
  static const favoriteTable = """
    CREATE TABLE IF NOT EXISTS $favoriteTableName (
      favorite_id INTEGER PRIMARY KEY AUTOINCREMENT,
      video_id TEXT NOT NULL UNIQUE
    )
  """;

  HomeLocalDb() {
    createDatabase();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    try {
      if (Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      String path = join(await getDatabasesPath(), 'user_history.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(favoriteTable);
          debugPrint('Created $favoriteTableName table');
        },
        onOpen: (db) async {
          // Verify table exists on open
          final tables = await db.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='$favoriteTableName'");
          if (tables.isEmpty) {
            await db.execute(favoriteTable);
            debugPrint('Recreated $favoriteTableName table as it was missing');
          }
        },
      );
    } catch (e) {
      debugPrint('Database creation error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> ensureTableExists() async {
    final db = await database;
    try {
      await db.rawQuery('SELECT 1 FROM $favoriteTableName LIMIT 1');
    } catch (e) {
      await db.execute(favoriteTable);
      debugPrint('Created missing $favoriteTableName table');
    }
  }

  Future<void> addToFavorite({required String videoId}) async {
    final db = await database;
    await ensureTableExists(); // Ensure table exists before operation

    try {
      await db.insert(
        favoriteTableName,
        {'video_id': videoId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error adding favorite: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleteFavoriteHistory({required String? videoId}) async {
    final db = await database;
    await ensureTableExists(); // Ensure table exists before operation

    try {
      await db.delete(
        favoriteTableName,
        where: "video_id = ?",
        whereArgs: [videoId],
      );
    } catch (e) {
      debugPrint('Error deleting favorite: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<FavoriteModel>> getAllFavorites() async {
    final db = await database;
    await ensureTableExists();

    try {
      final List<Map<String, dynamic>> maps = await db.query(favoriteTableName);
      return List.generate(maps.length, (i) {
        return FavoriteModel(
          id: maps[i]['favorite_id'],
          videoId: maps[i]['video_id'],
        );
      });
    } catch (e) {
      debugPrint('Error getting favorites: ${e.toString()}');
      return [];
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
