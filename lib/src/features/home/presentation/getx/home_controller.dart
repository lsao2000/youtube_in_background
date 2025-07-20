import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/core/service/media_downloader.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/downloaded_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/usecases/home_use_case.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/show_downloads_options.dart';
import 'package:youtube_inbackground_newversion/src/features/search/search_dependency_injections.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
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
  RxDouble availableHeight = 0.0.obs;
  // images of youtube channel that got from search
  RxList<String> youtubeChannelImage = <String>[].obs;

  RxBool wasMimizingView = false.obs;
  // RxBool isDownloading = false.obs;
  // RxDouble downloadProgress = 0.0.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // StreamSubscription? streamSubscription;
  // String? sharedUrl;
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
    initSearchDependy();
    setAppBarHeight();
  }

  setAppBarHeight() {
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
      // Reset the state for a new videoId
      var downloadController = Get.find<DownloadController>();
      downloadController.isDownloading.value = false;
      downloadController.downloadProgress.value = 0.0;
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
        // get all channel images
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
    // Check if the video is already in the favorites list
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

// Custom text for views
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
    // final downloadController = Get.find<DownloadController>();
    // downloadController.downloadProgress.value = 0.0;
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')));
      return null;
    } else {
      // Create unique notification ID
      // final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

      var yte = YoutubeExplode();
      final client = http.Client();

      final video = await yte.videos.get(selectedVideo.value!.videoId);
      final cleanTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      Directory directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Music/');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      final file = File('${directory.path}/$cleanTitle.mp3');
      StreamInfo? audioStream = null;
      try {
        // Track last progress to throttle updates
        if (file.existsSync()) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text('File already exists: ${file.path}'),
            ),
          );
        } else {
          // Get video metadata
          final manifest = await yte.videos.streamsClient.getManifest(video.id);

          audioStream = manifest.audioOnly.fold(null,
              (StreamInfo? closest, StreamInfo stream) {
            final currentDiff =
                (stream.bitrate.kiloBitsPerSecond - targetKbps).abs();
            final closestDiff = closest != null
                ? (closest.bitrate.kiloBitsPerSecond - targetKbps).abs()
                : double.infinity;
            return currentDiff < closestDiff ? stream : closest;
          });

          MediaDownloader mediaDownloader = MediaDownloader();
          mediaDownloader.download(
              url: audioStream!.url.toString(),
              path: file.path,
              title: cleanTitle);
          // Show initial notification
          // await _updateDownloadNotification(
          //   notificationId: notificationId,
          //   progress: 0,
          //   failed: false,
          //   filename: 'audio',
          //   isComplete: false,
          // );

          // int lastProgress = 0;
          // Download with progress
          // final request =
          //     await client.send(http.Request('GET', audioStream!.url));
          // final contentLength = request.contentLength ?? 0;
          // int received = 0;

          // final sink = file.openWrite();
          // await request.stream.listen(
          //   (List<int> chunk) async {
          //     received += chunk.length;
          //     final progress = ((received / contentLength) * 100).toInt();
          //
          //     sink.add(chunk);
          //     downloadController.downloadProgress.value = progress.toDouble();
          //     downloadController.downloadProgress.refresh();
          //     if (downloadController.downloadProgress.value >= 100) {
          //       lastProgress = progress;
          //       // Update progress in UI
          //       homeUseCase.addDownloadedVideo(
          //         downloadedVideoModel: DownloadedVideoModel(
          //           videoId: video.id.value,
          //           title: video.title,
          //           progress: downloadController.downloadProgress.value,
          //           // thumbnailUrl: video.thumbnails.highResUrl,
          //           thumbnailUrl: ImageHelper().getDefaultImageUrl(
          //               imgUrl: selectedVideo.value!.videoId),
          //           videoUrl: audioStream!.url.toString(),
          //           duration:
          //               video.duration?.inSeconds ?? Duration.zero.inSeconds,
          //           downloadDate: DateTime.now(),
          //         ),
          //       );
          //       await _updateDownloadNotification(
          //         notificationId: notificationId,
          //         progress: downloadController.downloadProgress.value.toInt(),
          //         failed: false,
          //         filename: cleanTitle,
          //         isComplete: true,
          //       );
          //     } else {
          //       lastProgress = progress;
          //       // Update progress in UI
          //       // downloadController.downloadProgress.value = progress.toDouble();
          //       // downloadController.downloadProgress.refresh();
          //       await _updateDownloadNotification(
          //         notificationId: notificationId,
          //         failed: false,
          //         progress: progress,
          //         filename: cleanTitle,
          //         isComplete: false,
          //       );
          //     }
          //   },
          //   // ✔️
          //   onDone: () async {
          //     await sink.close();
          //     debugPrint("Download completed");
          //
          //     // Update notification to complete
          //     await _updateDownloadNotification(
          //       notificationId: notificationId,
          //       progress: 100,
          //       failed: false,
          //       filename: cleanTitle,
          //       isComplete: true,
          //     );
          //   },
          //   onError: (e) async {
          //     await sink.close();
          //     debugPrint("Download error: $e");
          //
          //     // Show error notification
          //     await flutterLocalNotificationsPlugin.show(
          //       notificationId,
          //       'Download failed',
          //       'Failed to download audio',
          //       const NotificationDetails(
          //         android: AndroidNotificationDetails(
          //           'download_channel',
          //           'Downloads',
          //           importance: Importance.high,
          //         ),
          //       ),
          //     );
          //     throw e;
          //   },
          // ).asFuture();
          // sink.flush();
          // sink.close();
        }
        // downloadController.isDownloading.value = false;
        // downloadController.downloadProgress.value = 100.0;
        // downloadController.update();
        debugPrint("Download completed successfully");
        // Show success notification
        // homeUseCase.addDownloadedVideo();
        // homeUseCase.addDownloadedVideo(
        //   downloadedVideoModel: DownloadedVideoModel(
        //     videoId: video.id.value,
        //     title: video.title,
        //     progress: downloadController.downloadProgress.value,
        //     thumbnailUrl: video.thumbnails.highResUrl,
        //     videoUrl: audioStream!.url.toString(),
        //     duration: video.duration?.inSeconds ?? Duration.zero.inSeconds,
        //     downloadDate: DateTime.now(),
        //   ),
        // );

        return file.path;
      } catch (e) {
        // downloadController.downloadProgress.value = 0.0;
        // downloadController.isDownloading.value = false;
        // downloadController.update();
        // file.deleteSync();
        // await _updateDownloadNotification(
        //     notificationId: notificationId,
        //     progress: downloadController.downloadProgress.value.toInt(),
        //     filename: cleanTitle,
        //     failed: true,
        //     isComplete: true);
        // homeUseCase.addDownloadedVideo(
        //   downloadedVideoModel: DownloadedVideoModel(
        //     videoId: video.id.value,
        //     title: video.title,
        //     progress: downloadController.downloadProgress.value,
        //     thumbnailUrl: video.thumbnails.highResUrl,
        //     videoUrl: audioStream!.url.toString(),
        //     duration: video.duration?.inSeconds ?? Duration.zero.inSeconds,
        //     downloadDate: DateTime.now(),
        //   ),
        // );
        return null;
      } finally {
        client.close();
        yte.close();
      }
    }
  }

  Future<void> _updateDownloadNotification({
    required int notificationId,
    required int progress,
    required String filename,
    required bool isComplete,
    required bool failed,
  }) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Download progress notifications',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: !isComplete,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
      ongoing: !isComplete,
      autoCancel: isComplete,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      isComplete
          ? failed
              ? 'Failed to download ${filename.substring(0, min(20, filename.length))}'
              : 'Download complete'
          : 'Downloading ${filename.substring(0, min(20, filename.length))}...',
      isComplete
          ? failed
              ? '❌ Download failed, please try again'
              : ' ✔️ Audio downloaded successfully'
          : '$progress% complete',
      platformChannelSpecifics,
    );
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
        await SharePlus.instance.share(
          ShareParams(
            uri: shareUri,
          ),
        );
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
      try {
        debugPrint(
            "Fetching available formats for video ID: ${selectedVideo.value!.videoId}");
        result.clear();
        final manifest = await yt.videos.streamsClient
            .getManifest(selectedVideo.value!.videoId);
        debugPrint("Available streams fetched successfully");

        // Process the manifest
        final audioStreams = manifest.audioOnly
            .where((s) =>
                s.container == StreamContainer.webM ||
                s.container == StreamContainer.m3u8)
            .toList();

        // Sort by quality (highest first)
        audioStreams.sort((a, b) => b.bitrate.compareTo(a.bitrate));

        // Update your result
        result['mp3'] = audioStreams;
      } catch (e) {
        debugPrint("Error fetching streams: ${e.toString()}");
        getAvailableFormats();
      }
    }
  }

  Future showAvailableFormats() async {
    showDialog(
      context: Get.context!,
      builder: (context) => showDownloadsOptions(Get.context!, result),
    );
  }

  void showNotificationDownloadProgress() {
    // Implement your notification logic here
    // For example, using a package like flutter_local_notifications
    final downloadController = Get.find<DownloadController>();
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'download_channel',
      'Download Progress',
      channelDescription: 'Channel for download progress notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      progress: downloadController.downloadProgress.value.toInt(),
      maxProgress: 100,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: downloadController.downloadProgress.value.toInt(),
      subtitle: 'Downloading video',
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true),
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint(
            "Notification clicked with payload: ${response.payload.toString()}");
        // if (response.payload == 'video_download') {
        //   // Handle the notification click
        //   // Get.toNamed('/downloads'); // Navigate to downloads page
        // }
      },
    );
    flutterLocalNotificationsPlugin.show(
      0,
      '${selectedVideo.value?.title}',
      'Download progress: ${downloadController.downloadProgress.value.toStringAsFixed(1)}%',
      platformChannelSpecifics,
      payload: 'video_download',
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
