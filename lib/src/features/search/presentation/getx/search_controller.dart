import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/usercases/get_search_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/search/search_dependency_injections.dart';

class SearchBarController extends GetxController {
  RxList<SearchHistory> allSearch = <SearchHistory>[].obs;
  RxList<SearchHistory> filteredList = <SearchHistory>[].obs;
  final GetSearchUseCase getSearchUseCase;
  SearchBarController({required this.getSearchUseCase});

  Future search(String query) async {
    filteredList =
        allSearch.where((e) => e.getTitle.contains(query.trim())).toList().obs;
  }

  @override
  void onInit() async {
    // init();
    await getSearchHistory();
    super.onInit();
  }

  Future addToHistory(String query) async {
    await getSearchUseCase.addSearchHistory(query);
    update();
  }

  getSearchHistory() async {
    var data = await getSearchUseCase.getSearchHistory();
    debugPrint(data.toString());
    allSearch.value = data;
    filteredList.value = data;
    update();
  }
}
