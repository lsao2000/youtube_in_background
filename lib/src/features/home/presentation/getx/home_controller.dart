import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController extends GetxController {
  final HomeUseCase homeUseCase;
  HomeController({required this.homeUseCase});
  final YoutubeExplode yt = YoutubeExplode();
  RxList<HomeModel> lstVideos = <HomeModel>[].obs;
  RxList<FavoriteModel> lstFavorite = <FavoriteModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isFavoriteLoading = false.obs;
  final Rx<HomeModel?> selectedVideo = Rx<HomeModel?>(null);
  RxBool isVideoMinimized = false.obs;
  RxDouble dragHeight = 0.0.obs;
  Rx<YoutubePlayerController> youtubePlayerController = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: const YoutubePlayerFlags(
      isLive: true,
    ),
  ).obs;

  @override
  void onInit() async {
    super.onInit();
    await getAllFavorite();
    dragHeight = (Get.height*0.83).obs;
  }

  updateSelectedVideo({required HomeModel homeModel}) async {
    // youtubePlayerController.value.dispose();
    selectedVideo.value = homeModel;
    selectedVideo.refresh();
    youtubePlayerController.value = YoutubePlayerController(
        initialVideoId: selectedVideo.value!.videoId,
        flags: YoutubePlayerFlags(isLive: homeModel.isLive, autoPlay: true));
    youtubePlayerController.refresh();
    // youtubePlayerController.value.play();
  }

  Future getAllFavorite() async {
    lstFavorite.value = await homeUseCase.getAllFavorite();
    lstFavorite.refresh();
  }

  Future searchYoutube({required String searchQuery}) async {
    try {
      isLoading.value = true;
      isLoading.refresh();
      VideoSearchList lstSearch = await yt.search.search(searchQuery);
      if (lstSearch.isNotEmpty) {
        lstVideos.value = List.generate(
          lstSearch.length,
          (e) => HomeModel(
            isFavorite: false,
            videoId: lstSearch[e].id.value,
            viewCount: customViewsText(lstSearch[e].engagement.viewCount),
            isLive: lstSearch[e].isLive,
            channelName: lstSearch[e].author,
            videoDuration: lstSearch[e].duration ?? Duration.zero,
            durationAsString:
                customDurationText(lstSearch[e].duration ?? Duration.zero),
            title: lstSearch[e].title,
          ),
        );
        lstVideos.refresh();
        for (var video in lstVideos) {
          var isFavorite = lstFavorite.any((e) => e.videoId == video.videoId);
          video.isFavorite = isFavorite;
        }
        lstVideos.refresh();
      }
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    } finally {
      isLoading.value = false;
      isLoading.refresh();
    }
  }

  Future addAndRemoveFavorite({required String videoId}) async {
    final index = lstVideos.indexWhere((e) => e.videoId == videoId);
    if (!lstVideos.value[index].isFavorite) {
      var dataExecution = await homeUseCase.addToFavorite(videoId: videoId);
      if (dataExecution) {
        lstVideos.value[index].isLoadingFavorite = true;
        await getAllFavorite();
        lstVideos.refresh();
        Future.delayed(Duration(seconds: 1)).whenComplete(() {
          lstVideos.value[index].isLoadingFavorite = false;
          lstVideos.value[index].isFavorite =
              !lstVideos.value[index].isFavorite;
          lstVideos.refresh();
        });
      }
    } else {
      var databasseExecution =
          await homeUseCase.removeFromFavorite(videoId: videoId);
      if (databasseExecution) {
        await getAllFavorite();
        lstVideos.value[index].isLoadingFavorite = true;
        lstVideos.refresh();
        Future.delayed(const Duration(seconds: 1)).whenComplete(() {
          lstVideos.value[index].isLoadingFavorite = false;
          lstVideos.value[index].isFavorite =
              !lstVideos.value[index].isFavorite;
          lstVideos.refresh();
        });
      }
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
