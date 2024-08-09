import 'package:sqflite/sqflite.dart';
import 'package:youtube_inbackground_newversion/model/search_history.dart';

class SearchHistoryController {

    static void insertSearchHistory(SearchHistory searchHistory, Database db) async {
        await db.insert("search_history", searchHistory.toJson());
    }
    //static void d
}
