import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MediaDownloader {
  MediaDownloader();
  final YoutubeExplode youtubeExplode = YoutubeExplode();
  final Dio dio = Dio();
  bool isSuccess = false;
  final DownloadController downloadController = Get.find<DownloadController>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<Directory> getAudioDownloadsDirectory() async {
    // final appDocDir = await get ?? await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('/storage/emulated/0/Music/Backtube');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    return downloadsDir;
  }

  Future<bool> download(
      {required String url,
      required String path,
      required String title}) async {
    await getAudioDownloadsDirectory();
    downloadController.downloadProgress.value = 0.0;
    // Simulate a download process
    dio.download(url, path, onReceiveProgress: (received, total) {
      if (received < total) {
        int progress = ((received / total) * 100).floor();
        downloadController.downloadProgress.value =
            (received / total * 100).toDouble();
        downloadController.downloadProgress.refresh();
        showDownloadProgressNotification(title: title, progress: progress);
      } else if (received >= total) {
        downloadController.downloadProgress.value = 100.0;
        downloadController.downloadProgress.refresh();
        showDownloadCompleteNotification(title);
        debugPrint('Download completed');
      }
    }, deleteOnError: true).then((response) {
      if (response.statusCode != 200) {
        showDownloadFailedNotification(title);
        return false; // Return false to indicate failure
        // Future.delayed(const Duration(seconds: 1), () {
        //   downloadController.downloadProgress.value = 100.0;
        //   downloadController.downloadProgress.refresh();
        //   debugPrint("something happend");
        // });
        // return true; // Return false to continue the download
      }
    }).catchError((error) {
      debugPrint('Download error: $error');
      showDownloadFailedNotification(title);
      return false; // Return false to indicate failure
    });
    return false; // Return false to indicate that the download is in progress
  }

  Future<void> showDownloadProgressNotification({
    required String title,
    required int progress,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel_id',
      'Downloads',
      channelDescription: 'Notification for download progress',
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: downloadController.downloadProgress.value.toInt(),
      subtitle: 'Downloading video',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, // ID for this notification
        title,
        '$progress% downloaded',
        platformChannelSpecifics);
  }

  Future<void> showDownloadFailedNotification(String title) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel_id',
      'Downloads',
      channelDescription: 'Download completed notification',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      '❌ Download failed, please try again',
      platformChannelSpecifics,
    );
  }

  // Future<void> showDownloadCompleteNotification(String title) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'download_channel_id',
  //     'Downloads',
  //     channelDescription: 'Download completed notification',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     title,
  //     ' ✔️ Audio downloaded successfully',
  //     platformChannelSpecifics,
  //   );
  // }

  Future<void> showDownloadCompleteNotification(String title) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'download_channel_id',
      'Downloads',
      channelDescription: 'Notification for download progress',
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: false,
      maxProgress: 100,
      // progress: progress,
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: downloadController.downloadProgress.value.toInt(),
      subtitle: 'Downloading video',
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, // ID for this notification
        title,
        ' ✔️ Audio downloaded successfully',
        platformChannelSpecifics);
  }

  void initializeNotifications() {
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
    );
  }
}
