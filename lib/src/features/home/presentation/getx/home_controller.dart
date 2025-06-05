import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

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
  RxDouble appBarHeight = 0.0.obs;
  RxDouble totalHeight = 0.0.obs;
  RxDouble bottomNavBarHeight = 0.0.obs;
  RxDouble statusBarHeight = 0.0.obs;
  RxDouble availableHeight = 0.0.obs;
  RxList<String> youtubeChannelImage = <String>[].obs;
  RxBool wasMimizingView = false.obs;

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
    RxDouble appBarHeight = AppBar().preferredSize.height.obs;
    RxDouble totalHeight = Get.height.obs;
    RxDouble bottomNavBarHeight =
        kBottomNavigationBarHeight.obs; // Standard height (56.0)
    RxDouble statusBarHeight = MediaQuery.of(Get.context!).padding.top.obs;
    dragHeight = (totalHeight.value -
            appBarHeight.value -
            bottomNavBarHeight.value -
            statusBarHeight.value)
        .obs;
    availableHeight = (totalHeight.value -
            appBarHeight.value -
            bottomNavBarHeight.value -
            statusBarHeight.value)
        .obs;
  }

  updateSelectedVideo({required HomeModel homeModel}) async {
    debugPrint("dragHeight:${dragHeight.value}");
    dragHeight.value = availableHeight.value * 0.14;
    isVideoMinimized.value = true;

    selectedVideo.refresh();
    youtubePlayerController.value.dispose();

    var newYoutubeController = YoutubePlayerController(
        initialVideoId: homeModel.videoId,
        flags: YoutubePlayerFlags(isLive: homeModel.isLive, autoPlay: true));

    youtubePlayerController.value = newYoutubeController;
    selectedVideo.value = homeModel;

    youtubePlayerController.refresh();
  }

  Future getAllFavorite() async {
    lstFavorite.value = await homeUseCase.getAllFavorite();
    lstFavorite.refresh();
  }

  Future searchYoutube({required String searchQuery}) async {
    try {
      youtubeChannelImage.clear();
      isLoading.value = true;
      isLoading.refresh();
      VideoSearchList lstSearch = await yt.search.search(searchQuery);
      if (lstSearch.isNotEmpty) {
        // for (var video in lstSearch) {
        //   // var channelInfo = await yt.channels.get(video.channelId);
        //   var homeModel = HomeModel(
        //     // channelImageUrl: channelInfo.logoUrl,
        //     channelImageUrl: "",
        //     isFavorite: false,
        //     videoId: video.id.value,
        //     viewCount: customViewsText(video.engagement.viewCount),
        //     isLive: video.isLive,
        //     channelName: video.author,
        //     videoDuration: video.duration ?? Duration.zero,
        //     durationAsString:
        //         customDurationText(video.duration ?? Duration.zero),
        //     title: video.title,
        //   );
        //   lstVideos.add(homeModel);
        // }
        lstVideos.value = List.generate(lstSearch.length, (e) {
          String channelImageUrl = "";
          debugPrint(lstSearch[e].description);
          return HomeModel(
            channelImageUrl: channelImageUrl,
            description: lstSearch[e].description,
            isFavorite: false,
            videoId: lstSearch[e].id.value,
            viewCount: customViewsText(lstSearch[e].engagement.viewCount),
            isLive: lstSearch[e].isLive,
            channelName: lstSearch[e].author,
            videoDuration: lstSearch[e].duration ?? Duration.zero,
            durationAsString:
                customDurationText(lstSearch[e].duration ?? Duration.zero),
            title: lstSearch[e].title,
          );
        });
        // lstVideos.refresh();
        for (var video in lstVideos) {
          var isFavorite = lstFavorite.any((e) => e.videoId == video.videoId);
          video.isFavorite = isFavorite;
        }
        lstVideos.refresh();
        Future.delayed(const Duration(milliseconds: 400))
            .whenComplete(() async {
          for (var vid in lstSearch) {
            try {
              var channelInfo = await yt.channels.get(vid.channelId.value);
              var index = lstSearch.indexOf(vid);
              lstVideos.value[index].channelImageUrl = channelInfo.logoUrl;
              lstVideos.refresh();
            } catch (e) {
              debugPrint("error:${e.toString()}");
            }
          }
        });
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
  //
  // Future<void> downloadVideo(String videoUrl) async {
  //   try {
  //     var ytExplode = YoutubeExplode();
  //     var video = await ytExplode.videos.get(videoUrl);
  //
  //     var manifest = await ytExplode.videos.streamsClient.getManifest(video);
  //
  //     var streamInfo = manifest.audioOnly.first;
  //     var videoStream = manifest.video.first;
  //
  //     var audioStream = ytExplode.videos.streamsClient.get(streamInfo);
  //     var videoFile = await ytExplode.videos.streamsClient.get(videoStream);
  //     debugPrint(videoFile.first.toString());
  //     // saveVideo(videoFile: videoFile, title: title)
  //   } catch (e) {
  //   } finally {
  //     yt.close();
  //   }
  // }

  // Future<void> saveVideo(
  //     {required File videoFile, required String title}) async {
  //   if (Platform.isAndroid) {
  //     final status = await Permission.storage.request();
  //   }
  //   Directory? directory;
  //   // if (Platform.isAndroid) {
  //   // Use DCIM directory for videos (standard location)
  //   directory = await getExternalStorageDirectory();
  //   // final path = '${directory?.path}/DCIM/Camera'; // Common video storage path
  //   final savePath = '${directory?.path}/$title.mp4';
  //
  //   final videoBytes = await videoFile.readAsBytes();
  //   final File file = File(savePath);
  //
  //   await file.writeAsBytes(videoBytes);
  //   debugPrint("success to download");
  //   // } else if (Platform.isIOS) {
  //   //   // On iOS, use application documents directory
  //   //   directory = await getApplicationDocumentsDirectory();
  //   // }
  //
  //   // final appDocDir = await getApplicationDocumentsDirectory();
  // }
  //
  Future<String?> downloadAudio(String videoUrl) async {
    debugPrint("start downloading");
    final yt = YoutubeExplode();
    final client = http.Client();

    try {
      // Get video metadata
      final video = await yt.videos.get(videoUrl);

      // Get audio-only streams
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioStream = manifest.audioOnly.withHighestBitrate();

      // Get directory
      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      if (directory == null) return null;

      // Create file
      final cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      final file = File('${directory.path}/$cleanTitle.mp3');

      // Download with progress
      final request = await client.send(http.Request('GET', audioStream.url));
      final contentLength = request.contentLength ?? 0;
      int received = 0;

      final sink = file.openWrite();
      await request.stream.listen(
        (List<int> chunk) {
          received += chunk.length;
          debugPrint(
              'Progress: ${(received / contentLength * 100).toStringAsFixed(1)}%');
          sink.add(chunk);
        },
        onDone: () {
          debugPrint("done downloading");
          sink.close();
        },
        onError: (e) => throw e,
      ).asFuture();

      return file.path;
    } catch (e) {
      debugPrint('Download failed: $e');
      return null;
    } finally {
      client.close();
      yt.close();
    }
  }
}
