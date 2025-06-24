import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/models/search_history.dart';
import 'package:youtube_inbackground_newversion/src/features/search/domain/usercases/get_search_use_case.dart';

class SearchBarController extends GetxController {
  final RxList<SearchHistory> allSearch = <SearchHistory>[].obs;
  final RxList<SearchHistory> filteredList = <SearchHistory>[].obs;
  final GetSearchUseCase getSearchUseCase;
  SearchBarController({required this.getSearchUseCase});

  @override
  void onInit() async {
    await getSearchHistory();
    super.onInit();
  }

  searchForVideo({required String searchQuery}) async {
    var homeController = Get.find<HomeController>();
    homeController.searchYoutube(searchQuery: searchQuery);
    // whenComplete(() async {
    // for (var vid in homeController.lstVideos) {
    //   var index = homeController.lstVideos.value.indexOf(vid);
    //   // var channelInfo = await homeController.yt.channels.get();
    //   // lstVideos.value[index].channelImageUrl = channelInfo.logoUrl;
    // }
    // lstVideos.refresh();
    // });
    Get.back();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      filteredList.assignAll(allSearch);
    } else {
      filteredList.assignAll(allSearch
          .where((e) => e.getTitle.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  Future<void> addToHistory(String query) async {
    await getSearchUseCase.addSearchHistory(query);
    await getSearchHistory(); // Refresh the list after adding
  }

  Future<void> getSearchHistory() async {
    final data = await getSearchUseCase.getSearchHistory();
    allSearch.assignAll(data); // Use assignAll instead of direct assignment
    filteredList.assignAll(data);
  }
}
