import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';

abstract class SearchRepository {
  Future<List<SearchHistory>> getHistorySearch();
  Future<void> addHistory(String query);
}
