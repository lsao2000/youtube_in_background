import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';

class LocalDb {
  Database? _database;
  static const searchTableName = "search_history";
  static const searchTable =
      "CREATE TABLE $searchTableName (search_id INTEGER PRIMARY KEY AUTOINCREMENT, search TEXT UNIQUE)";

  LocalDb() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    try {
      if (Platform.isLinux || Platform.isWindows) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final String path = join(await getDatabasesPath(), 'user_history.db');
      debugPrint('Database path: $path');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          debugPrint('Creating database tables...');
          await db.execute(searchTable);
          debugPrint('Table $searchTableName created successfully');
        },
        onOpen: (db) async {
          // Verify table exists on open
          final tables = await db.rawQuery(
              "SELECT name FROM sqlite_master WHERE type='table' AND name='$searchTableName'");
          if (tables.isEmpty) {
            debugPrint('Table missing, recreating...');
            await db.execute(searchTable);
          }
        },
      );

      // Verify table structure
      await _verifyTableStructure();
    } catch (e) {
      debugPrint('Database initialization error: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> _verifyTableStructure() async {
    final db = await database;
    try {
      final tableInfo =
          await db.rawQuery('PRAGMA table_info($searchTableName)');
      debugPrint('Table structure:');
      for (final column in tableInfo) {
        debugPrint('${column['name']} (${column['type']})');
      }
    } catch (e) {
      debugPrint('Error verifying table: $e');
      // Recreate table if verification fails
      await db.execute('DROP TABLE IF EXISTS $searchTableName');
      await db.execute(searchTable);
    }
  }

  Future<Database> get database async {
    while (_database == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return _database!;
  }

  Future<int> addToHistory(SearchHistory searchHistory) async {
    final db = await database;
    try {
      return await db.insert(
        searchTableName,
        searchHistory.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Insert error: $e');
      // Try recreating table if insert fails
      await db.execute('DROP TABLE IF EXISTS $searchTableName');
      await db.execute(searchTable);
      return await db.insert(searchTableName, searchHistory.toJson());
    }
  }

  Future<List<Map<String, dynamic>>> getHistorySearch() async {
    try {
      final db = await database;
      final results = await db.query(
        searchTableName,
        orderBy: 'search_id DESC',
      );
      return results;
    } catch (e) {
      debugPrint("failed To Get SearchHistory: ${e.toString()}");
      return [];
    }
  }
  //
  // Future<List<SearchHistory>> getHistorySearch() async {
  //   final db = await database;
  //   try {
  //     final results = await db.query(
  //       searchTableName,
  //       orderBy: 'search_id DESC',
  //     );
  //     return results.map((e) => SearchHistory.fromJson(e)).toList();
  //   } catch (e) {
  //     debugPrint('Query error: $e');
  //     return [];
  //   }
  // }
}
// class LocalDb {
//   Database? _database;
//   static const searchTableName = "search_history";
//   static const searchTable =
//       "CREATE TABLE IF NOT EXISTS $searchTableName (search_id INTEGER PRIMARY KEY , search TEXT UNIQUE)";
//   LocalDb() {
//     createDatabase();
//   }
//   Future<void> createDatabase() async {
//     try {
//       if (Platform.isLinux) {
//         // sqfliteFfiInit();
//         sqfliteFfiInit();
//         databaseFactory = databaseFactoryFfi;
//         String path = join(await getDatabasesPath(), 'user_history.db');
//         _database = await databaseFactory.openDatabase(path,
//             options: OpenDatabaseOptions(
//               version: 1,
//               onCreate: (db, version) async {
//                 await db.execute(searchTable);
//               },
//             ));
//       } else {
//         String path = join(await getDatabasesPath(), 'user_history.db');
//         _database = await openDatabase(path, onCreate: (db, version) async {
//           await db.execute(searchTable);
//         }, version: 1);
//         final db = await database;
//         final tableInfo =
//             await db.rawQuery('PRAGMA table_info($searchTableName)');
//         debugPrint('Current table columns:');
//         for (final column in tableInfo) {
//           debugPrint('${column['name']} (${column['type']})');
//         }
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     await createDatabase();
//     return _database!;
//   }
//
//   Future<void> addToHistory(SearchHistory searchHistory) async {
//     try {
//       final db = await database;
//       var addS = await db.insert(searchTableName, searchHistory.toJson());
//
//       debugPrint("id: $addS");
//       debugPrint("succeess");
//     } catch (e) {
//       debugPrint("failed to add history:${e.toString()}");
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> getHistorySearch() async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> data = await db.query(searchTableName);
//       return data;
//     } catch (e) {
//       debugPrint("failed To Get SearchHistory: ${e.toString()}");
//       return [];
//     }
//   }
// }
