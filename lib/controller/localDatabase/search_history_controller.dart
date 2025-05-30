import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/model/search_history.dart';
import 'package:path/path.dart';

class SearchHistoryController {
  late Database database;
  static const searchTableName = "search_history";
  static const favoriteTableName = "favorite_history";
  static const searchTable =
      "CREATE TABLE IF NOT EXISTS $searchTableName (search_id INTEGER PRIMARY KEY ,search TEXT)";
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
  SearchHistoryController() {
    createDatabase();
  }

  Future<void> createDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'user_history.db');
      //await deleteDatabase(path);
      database = await openDatabase(path, onCreate: (db, version) async {
        await db.execute(searchTable);
        await db.execute(favoriteTable);
      }, version: 2);
    } catch (e) {
      log("create Database Error ${e.toString()}");
    }
  }

  Future<void> addToFavorite(FavoriteVideoHistory favoriteVideoHistory) async {
    try {
      //print("not added yet");
      await createDatabase();
      await database.insert(favoriteTableName, favoriteVideoHistory.toJson());
      database.close();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addToHistory(String search) async {
    List<SearchHistory> all = await getAllSearch();
    SearchHistory searchHistory = SearchHistory(search: search.trim());
    var notHere = false;
    for (var i = 0; i < all.length; i++) {
      if (all[i].search.trim() == search.trim()) {
        notHere = true;
      }
    }
    if (!notHere) {
      //database.
      await database.insert(searchTableName, searchHistory.toJson());
      database.close();
    }
  }

  Future<void> deleteItem(int id) async {
    await createDatabase();
    try {
      database.delete(searchTableName, where: "search_id = ?", whereArgs: [id]);
      database.close();
    } catch (e) {
      log("something went wrong ${e.toString()}");
    }
  }

  Future<void> deleteFavoriteHistory({required String videoId}) async {
    try {
      await createDatabase();
      database.delete(favoriteTableName,
          where: "videoId = ?", whereArgs: [videoId]);
    } on DatabaseException catch (e) {
      log(e.toString());
    }
  }

  Future<List<SearchHistory>> getAllSearch() async {
    try {
      await createDatabase();
      final List<Map<String, dynamic>> data =
          await database.query(searchTableName);
      List<SearchHistory> allSearch = data
          .map<SearchHistory>(
              (search) => SearchHistory.fromJson(searchMap: search))
          .toList();
      return allSearch;
    } catch (e) {
      log("get All Search Error ${e.toString()}");
      return [];
    }
  }

  Future<List<FavoriteVideoHistory>> getAllFavorite() async {
    try {
      await createDatabase();
      final List<Map<String, dynamic>> data =
          await database.query(favoriteTableName);
      final List<FavoriteVideoHistory> allData = data
          .map((el) => FavoriteVideoHistory.fromJson({
                "videoId": el["videoId"],
                "titleVideo": el["titleVideo"],
                "videoWatchers": el["videoWatchers"],
                "imgUrl": el["imgUrl"],
                "isLive": el["isLive"],
                "videoDuration": el["videoDuration"],
                "videoChannel": el["videoChannel"],
                "realDuration": el["realDuration"],
              }))
          .toList();
      return allData;
    } catch (e) {
      log("get All Favorite Error ${e.toString()}");
      return [];
    }
  }
}
