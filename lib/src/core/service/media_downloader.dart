import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';

class MediaDownloader {
  MediaDownloader();
  final YoutubeExplode youtubeExplode = YoutubeExplode();
  final Dio dio = Dio();
  bool isSuccess = false;
  final DownloadController downloadController = Get.find<DownloadController>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> download(
      {required String url,
      required String path,
      required String title}) async {
    downloadController.downloadProgress.value = 0.0;
    // Simulate a download process
    dio.download(url, path, onReceiveProgress: (received, total) {
      if (total != -1) {
        int progress = ((received / total) * 100).floor();
        downloadController.downloadProgress.value =
            (received / total * 100).toDouble();
        downloadController.downloadProgress.refresh();
        showDownloadProgressNotification(title: title, progress: progress);
      }
    }, deleteOnError: true).then((response) {
      if (response.statusCode == 200) {
        debugPrint('Download completed successfully.');
        showDownloadCompleteNotification(title);
      } else {
        debugPrint('Download failed with status code: ${response.statusCode}');
      }
    }).catchError((error) {
      debugPrint('Download error: $error');
    });
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

  Future<void> showDownloadCompleteNotification(String title) async {
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
      'Download completed!',
      platformChannelSpecifics,
    );
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
