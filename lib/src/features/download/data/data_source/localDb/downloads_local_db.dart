import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';

class DownloadsLocalDb {
  // This class is responsible for managing the local database for downloads.
  // It will handle operations like adding, removing, and retrieving download items.

  Database? _database;
  // Example properties
  final String dbName = 'user_history.db';
  static const downloadedTableName = "downloaded_videos";
  static const downloadTable = """
    CREATE TABLE IF NOT EXISTS downloaded_videos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      video_id TEXT NOT NULL UNIQUE,
      title TEXT,
      thumbnail_url TEXT,
      video_url TEXT,
      duration INTEGER,
      download_date TEXT,
      progress REAL DEFAULT 0.0
    )
  """;

  DownloadsLocalDb() {
    // Constructor to initialize the database
    createDatabase();
  }

  Future<Database> get database async {
    _database = _database ?? await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    try {
      String path = join(await getDatabasesPath(), dbName);
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            downloadTable,
          );
          debugPrint('Created downloaded_videos table');
        },
        onOpen: (db) async {
          final tables = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='downloaded_videos'",
          );
        },
      );
    } catch (e) {
      debugPrint('Error creating database: ${e.toString()}');
      rethrow; // Rethrow the exception to handle it at a higher level if needed
    }
  }

  Future<void> ensureDownloadedTableExists() async {
    final db = await database;
    try {
      await db.rawQuery('SELECT 1 FROM downloaded_videos LIMIT 1');
    } catch (e) {
      await db.execute(downloadTable);
      debugPrint('Created missing downloaded_videos table');
    }
  }

  // Example methods
  void addDownload(String item) {
    // Logic to add a download item to the local database
  }

  void removeDownload(String item) {
    // Logic to remove a download item from the local database
  }

  Future<List<DownloadedVideoModel>> getDownloads() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query(downloadedTableName);
      return List.generate(maps.length, (i) {
        return DownloadedVideoModel.fromJson(maps[i]);
      });
    } catch (e) {
      debugPrint('Error fetching downloaded videos: ${e.toString()}');
      return [];
    }
  }
}
