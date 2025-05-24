import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeController extends GetxController {
  final YoutubeExplode yt = YoutubeExplode();
  List<String> lstVideos = [];
  RxBool isLoading = false.obs;
  Future searchYoutube({required String searchQuery}) async {
    try {
      isLoading.value = true;
      // update();
      isLoading.refresh();
      List<dynamic> lstSearch = await yt.search.search(searchQuery);
      if (lstSearch.isNotEmpty) {
        for (var i = 0; i < lstSearch.length; i++) {
          debugPrint(lstSearch[i].toString());
        }
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      isLoading.refresh();
      // update();
    }
  }
}
