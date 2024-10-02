import 'package:sqflite/sqflite.dart';
import 'package:youtube_inbackground_newversion/model/search_history.dart';
import 'package:path/path.dart';

class SearchHistoryController {
  late Database database;
  static const tableName = "search_history";
  SearchHistoryController() {
    createDatabase();
  }

  Future<void> createDatabase() async {
    try {
      database =
          await openDatabase(join(await getDatabasesPath(), 'user_history.db'),
              onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $tableName (search_id INTEGER PRIMARY KEY ,search TEXT)");
      }, version: 1);
    } catch (e) {
      print("something went wrong in creating database ${e.toString()}");
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
      await database.insert(tableName, searchHistory.toJson());
    }
  }

  Future<void> deleteItem(int id) async {
    await createDatabase();
    try {
      database.delete(tableName, where: "search_id = ?", whereArgs: [id]);
    } catch (e) {
        print("Something went wrong ${e.toString()}");
    }
  }

  Future<List<SearchHistory>> getAllSearch() async {
    await createDatabase();
    final List<Map<String, dynamic>> data = await database.query(tableName);
    List<SearchHistory> allSearch = data
        .map<SearchHistory>(
            (search) => SearchHistory.fromJson(searchMap: search))
        .toList();
    return allSearch;
    //return database.;
  }
}
