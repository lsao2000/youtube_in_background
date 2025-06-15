import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/show_downloads_options.dart';
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
  RxBool isDownloading = false.obs;
  RxDouble downloadProgress = 0.0.obs;
  final result = <String, List<StreamInfo>>{
    'mp3': [],
  };
  resetAll() {
    selectedVideo.value = null;
    // youtubePlayerController.value.dispose();
    selectedVideo.refresh();
  }

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
    if (selectedVideo.value != null &&
        selectedVideo.value!.videoId == homeModel.videoId) {
    } else {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
      dragHeight.value = availableHeight.value * 0.14;
      isVideoMinimized.value = true;
      youtubePlayerController.value.dispose();

      var newYoutubeController = YoutubePlayerController(
          initialVideoId: homeModel.videoId,
          flags: YoutubePlayerFlags(isLive: homeModel.isLive, autoPlay: true));

      youtubePlayerController.value = newYoutubeController;
      selectedVideo.value = homeModel;
      youtubePlayerController.refresh();
      getAvailableFormats();
    }
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
        Future.delayed(const Duration(seconds: 1)).whenComplete(() {
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

  Future<String?> downloadAudio(int targetKbps) async {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')));
    } else {
      final client = http.Client();
      try {
        // Get video metadata
        final video = await yt.videos.get(selectedVideo.value!.videoId);
        // Get audio-only streams
        final manifest = await yt.videos.streamsClient.getManifest(video.id);
        final audioStream = manifest.audioOnly.fold(null,
            (StreamInfo? closest, StreamInfo stream) {
          final currentDiff =
              (stream.bitrate.kiloBitsPerSecond - targetKbps).abs();
          final closestDiff = closest != null
              ? (closest.bitrate.kiloBitsPerSecond - targetKbps).abs()
              : double.infinity;
          return currentDiff < closestDiff ? stream : closest;
        });
        final directory = Platform.isAndroid
            ? await getDownloadsDirectory()
            : await getApplicationDocumentsDirectory();
        final cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
        // final cleanTitle = video.title;
        final file = File('${directory!.path}/$cleanTitle.mp3');

        // Download with progress
        final request =
            await client.send(http.Request('GET', audioStream!.url));
        final contentLength = request.contentLength ?? 0;
        int received = 0;

        final sink = file.openWrite();
        await request.stream.listen(
          (List<int> chunk) {
            received += chunk.length;
            debugPrint(
                'Progress: ${(received / contentLength * 100).toStringAsFixed(1)}%');
            downloadProgress.value = received / contentLength * 100;
            downloadProgress.refresh();
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
      }
    }
    return null;
  }

  shareVideo() async {
    if (selectedVideo.value == null) {
      debugPrint("No video selected to share");
    } else if (selectedVideo.value!.videoId.isEmpty) {
      debugPrint("Selected video ID is empty");
    } else {
      final String videoUrl =
          "https://www.youtube.com/watch?v=${selectedVideo.value!.videoId}";
      final Uri shareUri = Uri.parse(videoUrl);
      try {
        // if (await canLaunchUrl(shareUri)) {
        // await launchUrl(
        await SharePlus.instance.share(
          ShareParams(
            // text: "Check out this video: ${selectedVideo.value!.title}",
            uri: shareUri,
            // url: shareUri,
          ),
        );
        //   shareUri,
        //   mode: LaunchMode.externalApplication,
        // );
        // } else {
        // debugPrint("Could not launch URL: $videoUrl");
        // }
      } catch (e) {
        debugPrint("Error sharing video: ${e.toString()}");
      }
    }
  }

  //
  getAvailableFormats() async {
    if (selectedVideo.value == null) {
      debugPrint("No video selected");
    } else if (selectedVideo.value!.videoId.isEmpty) {
      debugPrint("Selected video ID is empty");
    } else {
      await yt.videos.streamsClient
          .getManifest(selectedVideo.value!.videoId)
          .then((value) async {
        // Categorize all available streams
        result.clear();
        result['mp3'] = value.audio
            .where((s) =>
                s.container == StreamContainer.webM ||
                s.container == StreamContainer.m3u8)
            .toList();
        // Sort each category by quality
        result['mp3']!.sort((a, b) => b.bitrate.compareTo(a.bitrate));

        // showDialog(
        //   context: Get.context!,
        //   builder: (context) => showDownloadsOptions(Get.context!, result),
        // );
      });
    }
  }

  Future showAvailableFormats() async {
    showDialog(
      context: Get.context!,
      builder: (context) => showDownloadsOptions(Get.context!, result),
    );
  }

  // Future<void> downloadWithRetry(String url, String savePath) async {
  //   final dio = Dio();
  //   const maxRetries = 3;
  //   int attempt = 0;
  //
  //   while (attempt < maxRetries) {
  //     try {
  //       await dio.download(
  //         url,
  //         savePath,
  //         onReceiveProgress: (received, total) {
  //           downloadProgress.value = (received / total * 100);
  //           downloadProgress.refresh();
  //         },
  //         options: Options(
  //           headers: {
  //             'Connection': 'keep-alive',
  //             'User-Agent':
  //                 'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0',
  //           },
  //           receiveTimeout: const Duration(minutes: 10),
  //         ),
  //       );
  //       return; // Success!
  //     } catch (e) {
  //       attempt++;
  //       if (attempt >= maxRetries) rethrow;
  //       await Future.delayed(
  //           Duration(seconds: attempt * 2)); // Exponential backoff
  //     }
  //   }
  // }
  //
  // Future<void> downloadUsingDio(String videoQuality) async {
  //   try {
  //     final hasPermission = await requestStoragePermission();
  //     if (!hasPermission) {
  //       ScaffoldMessenger.of(Get.context!).showSnackBar(
  //           const SnackBar(content: Text('Storage permission denied')));
  //       return;
  //     }
  //
  //     // Fetch fresh stream URL
  //     var video = await yt.videos.get(selectedVideo.value!.videoId);
  //     var manifest = await yt.videos.streamsClient.getManifest(video.id);
  //     var stream =
  //         manifest.video.where((s) => s.qualityLabel == videoQuality).first;
  //
  //     // Prepare save path
  //     final directory = Platform.isAndroid
  //         ? await getDownloadsDirectory()
  //         : await getApplicationDocumentsDirectory();
  //     final cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  //     final file = File('${directory!.path}/$cleanTitle.mp4');
  //
  //     // Download with retries
  //     await downloadWithRetry(stream.url.toString(), file.path);
  //
  //     Get.snackbar('Success', 'Video downloaded to ${file.path}');
  //   } catch (e) {
  //     debugPrint("Download failed: $e");
  //     Get.snackbar('Error', 'Failed to download: ${e.toString()}');
  //   }
  // }

  // Future<void> downloadUsingDio(String videoQuality) async {
  //   final hasPermission = await requestStoragePermission();
  //   if (!hasPermission) {
  //     ScaffoldMessenger.of(Get.context!).showSnackBar(
  //         const SnackBar(content: Text('Storage permission denied')));
  //     return;
  //   }
  //   // try {
  //     var video = await yt.videos.get(selectedVideo.value!.videoId);
  //     var manifest = await yt.videos.streamsClient.getManifest(video.id);
  //     var stream = manifest.video.where((s) {
  //       return s.qualityLabel == videoQuality ||
  //           s.qualityLabel.contains(videoQuality);
  //     }).first;
  //     final directory = Platform.isAndroid
  //         ? await getDownloadsDirectory()
  //         : await getApplicationDocumentsDirectory();
  //     final cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  //     final file = File('${directory!.path}/$cleanTitle.mp4');
  //     final dio = Dio();
  //     await dio.download(
  //       stream.url.toString(),
  //       file.path,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           downloadProgress.value = received / total * 100;
  //           downloadProgress.refresh();
  //           debugPrint(
  //               'Progress: ${(received / total * 100).toStringAsFixed(1)}%');
  //         }
  //       },
  //       options: Options(
  //         responseType: ResponseType.bytes,
  //         headers: {'Connection': 'keep-alive'},
  //         // followRedirects: true,
  //         receiveTimeout: const Duration(minutes: 6),
  //       ),
  //     );
  //   // } catch (e) {
  //   //   debugPrint("Error downloading video: ${e.toString()}");
  //   // }
  // }
  //
  Future<bool> requestStoragePermission() async {
    await Permission.storage.request();
    if (await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }
}
