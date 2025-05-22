import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/repositories/search_repository.dart';

class GetSearchUseCase {
  final SearchRepository searchRepository;
  GetSearchUseCase({required this.searchRepository});
  Future searchVideos() async {}

  Future<List<SearchHistory>> getSearchHistory() async {
    return await searchRepository.getHistorySearch();
  }

  Future addSearchHistory(String query) async {
    await searchRepository.addHistory(query);
  }
}
