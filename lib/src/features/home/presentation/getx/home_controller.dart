import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';

class HomeController extends GetxController {
  final HomeUseCase homeUseCase;
  HomeController({required this.homeUseCase});
  final YoutubeExplode yt = YoutubeExplode();
  RxList<HomeModel> lstVideos = <HomeModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFavoriteLoading = false.obs;
  Future searchYoutube({required String searchQuery}) async {
    try {
      isLoading.value = true;
      // update();
      isLoading.refresh();
      VideoSearchList lstSearch = await yt.search.search(searchQuery);
      for (var i = 0; i < lstSearch.length; i++) {
        debugPrint(lstSearch[i].url);
      }
      if (lstSearch.isNotEmpty) {
        lstVideos.value = lstSearch.map((e) {
          return HomeModel(
            isFavorite: false,
            videoId: e.id.value,
            viewCount: customViewsText(e.engagement.viewCount),
            isLive: e.isLive,
            channelName: e.author,
            videoDuration: e.duration ?? Duration.zero,
            durationAsString: customDurationText(e.duration ?? Duration.zero),
            title: e.title,
          );
        }).toList();
        lstVideos.refresh();
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      isLoading.refresh();
      // update();
    }
  }

  Future addAndRemoveFavorite({required String videoId}) async {
    final index = lstVideos.indexWhere((e) => e.videoId == videoId);
    if (!lstVideos.value[index].isFavorite) {
      var dataExecution = await homeUseCase.addToFavorite(videoId: videoId);
      if (dataExecution) {
        lstVideos.value;
        lstVideos.value[index].isLoadingFavorite = true;
        lstVideos.refresh();
        Future.delayed(Duration(seconds: 1)).whenComplete(() {
          lstVideos.value[index].isLoadingFavorite = false;
          lstVideos.value[index].isFavorite =
              !lstVideos.value[index].isFavorite;
          lstVideos.refresh();
        });
      } else {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("fail to add to favorite")));
      }
    } else {
      // homeUseCase.removeFromFavorite(favoriteId: favoriteId);
    }
  }

  String customViewsText(int views) {
    if (views < 1000) {
      return "$views ";
    } else if (views >= 1000 && views < 1000000) {
      var newViews = views / 1000;
      return "${newViews.toStringAsFixed(1)} K";
    } else if (views >= 1000000 && views < 1000000000) {
      var newViews = views / 1000000;
      return "${newViews.toStringAsFixed(1)} M";
    }

    return "${(views / 1000000000).toStringAsFixed(1)} Md";
  }

  String customDurationText(Duration duration) {
    try {
      if (duration.inSeconds == 0) {
        return "0";
      }
      String duratinString = duration.toString();
      List<String> lstDuration = duratinString.split(":");
      if (int.parse(lstDuration.first.toString()) == 0) {
        lstDuration.removeAt(0);
      }
      lstDuration.first = int.parse(lstDuration.first).toString();
      lstDuration.last = lstDuration.last.split(".")[0];
      return lstDuration.join(":");
    } catch (e) {
      return duration.toString();
    }
  }
}
