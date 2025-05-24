import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';

class LocalDb {
  Database? _database;
  static const searchTableName = "search_history";
  static const favoriteTableName = "favorite_history";
  static const searchTable =
      "CREATE TABLE IF NOT EXISTS $searchTableName (search_id INTEGER PRIMARY KEY , search TEXT UNIQUE)";
  static const favoriteTable =
      """ CREATE TABLE IF NOT EXISTS $favoriteTableName (
                  videoId TEXT PRIMARY KEY,
                  titleVideo TEXT,
                  videoWatchers TEXT,
                  imgUrl TEXT,
                  isLive INTEGER,
                  videoDuration TEXT,
                  videoChannel TEXT,
                  realDuration INTEGER
                  )""";
  LocalDb() {
    createDatabase();
  }
  Future<void> createDatabase() async {
    try {
      if (Platform.isLinux) {
        // sqfliteFfiInit();
        // databaseFactory = databaseFactoryFfi;
        // String path = join(await getDatabasesPath(), 'user_history.db');
        // _database = await databaseFactory.openDatabase(path,
        //     options: OpenDatabaseOptions(
        //       version: 1,
        //       onCreate: (db, version) async {
        //         await db.execute(searchTable);
        //       },
        //     ));
      } else {
        String path = join(await getDatabasesPath(), 'user_history.db');
        _database = await openDatabase(path, onCreate: (db, version) async {
          await db.execute(searchTable);
          // await db.execute(favoriteTable);
        }, version: 1);
        final db = await database;
        final tableInfo =
            await db.rawQuery('PRAGMA table_info($searchTableName)');
        debugPrint('Current table columns:');
        for (final column in tableInfo) {
          debugPrint('${column['name']} (${column['type']})');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await createDatabase();
    return _database!;
  }

  Future<void> addToHistory(SearchHistory searchHistory) async {
    try {
      final db = await database;
      var addS = await db.insert(searchTableName, searchHistory.toJson());

      debugPrint("id: $addS");
      debugPrint("succeess");
    } catch (e) {
      debugPrint("failed to add history:${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getHistorySearch() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> data = await db.query(searchTableName);
      return data;
    } catch (e) {
      debugPrint("failed To Get SearchHistory: ${e.toString()}");
      return [];
    }
  }
}
