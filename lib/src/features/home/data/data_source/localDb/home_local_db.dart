import 'package:sqflite/sqflite.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';

class HomeLocalDb {
  Database? _database;
  static const favoriteTableName = "favorite_history";
  static const favoriteTable =
      """ CREATE TABLE IF NOT EXISTS $favoriteTableName (
                favorite_id INTEGER PRIMARY KEY,
                  video_id TEXT
                  )""";
  Future<Database> get database async {
    if (_database != null) return _database!;
    await createDatabase();
    return _database!;
  }

  Future<void> createDatabase() async {
    try {
      if (Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        String path = join(await getDatabasesPath(), 'user_history.db');
        _database = await databaseFactory.openDatabase(path,
            options: OpenDatabaseOptions(
              version: 1,
              onCreate: (db, version) async {
                await db.execute(favoriteTable);
              },
            ));
      } else {
        String path = join(await getDatabasesPath(), 'user_history.db');
        _database = await openDatabase(path, onCreate: (db, version) async {
          await db.execute(favoriteTable);
        }, version: 1);
        final db = await database;
        final tableInfo =
            await db.rawQuery('PRAGMA table_info($favoriteTableName)');
        for (final column in tableInfo) {
          debugPrint('${column['name']} (${column['type']})');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<List<FavoriteVideoHistory>> getAllFavorite() async {
  //   try {
  //     await createDatabase();
  //     final List<Map<String, dynamic>> data =
  //         await database.query(favoriteTableName);
  //     final List<FavoriteVideoHistory> allData = data
  //         .map((el) => FavoriteVideoHistory.fromJson({
  //               "videoId": el["videoId"],
  //               "titleVideo": el["titleVideo"],
  //               "videoWatchers": el["videoWatchers"],
  //               "imgUrl": el["imgUrl"],
  //               "isLive": el["isLive"],
  //               "videoDuration": el["videoDuration"],
  //               "videoChannel": el["videoChannel"],
  //               "realDuration": el["realDuration"],
  //             }))
  //         .toList();
  //     return allData;
  //   } catch (e) {
  //     log("get All Favorite Error ${e.toString()}");
  //     return [];
  //   }
  // }
  Future<void> deleteFavoriteHistory({required int? favoriteId}) async {
    final db = await database;
    db.delete(favoriteTableName,
        where: "favorite_id = ?", whereArgs: [favoriteId]);
  }

  Future<void> addToFavorite({required String videoId}) async {
    final db = await database;
    FavoriteModel favoriteModel = FavoriteModel(id: null, videoId: videoId);
    await db.insert(favoriteTableName, favoriteModel.toJson());
    db.close();
  }
}
