import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/src/features/search/data/datasource/local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final LocalDb localDb;
  SearchRepositoryImpl(this.localDb);
  @override
  Future<List<SearchHistory>> getHistorySearch() async {
    List<Map<String, dynamic>> list = await localDb.getHistorySearch();
    List<SearchHistory> allSearch = list
        .map<SearchHistory>((search) => SearchHistory.fromJson(search))
        .toList();
    return allSearch;
  }

  @override
  Future<void> addHistory(String query) async {
    SearchHistory searchHistory = SearchHistory(title: query.trim());
    debugPrint(searchHistory.toJson().toString());
    await localDb.addToHistory(searchHistory);
  }
}
