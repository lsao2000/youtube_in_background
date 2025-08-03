import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/usecases/download_use_case.dart';

class DownloadController extends GetxController {
  RxDouble downloadProgress = 0.0.obs;
  RxBool isDownloading = false.obs;
  RxList<DownloadedVideoModel> downloadedVideos = <DownloadedVideoModel>[].obs;
  final DownloadUseCase downloadUseCase;
  DownloadController({required this.downloadUseCase});
  final YoutubeExplode yt = YoutubeExplode();

  @override
  void onInit() {
    super.onInit();
    // getDownloadedVideos();
    showListOfDownloadedAudios();
  }

  getDownloadedVideos() async {
    await downloadUseCase.getDownloadedVideos().then((value) {
      downloadedVideos.value = value;
      downloadedVideos.refresh();
    });
  }

  Future<void> showListOfDownloadedAudios() async {
      debugPrint('Fetching downloaded audios...');
    final downloadedAudios = await getDownloadedAudiosList();
    for (var i = 0; i < downloadedAudios.length; i++) {
      debugPrint('Downloaded Audio: ${downloadedAudios[i].path}');
    }
    debugPrint('Total downloaded audios: ${downloadedAudios.length}');
  }

  Future<List<FileSystemEntity>> getDownloadedAudiosList() async {
    // final downloadedAudios = await downloadUseCase.getDownloadedAudios();
    // downloadedVideos.value = downloadedAudios;
    // downloadedVideos.refresh();
    final dir = await getAudioDownloadsDirectory();
    return dir.list().toList();
  }

  Future<Directory> getAudioDownloadsDirectory() async {
    final downloadsDir = Directory('/storage/emulated/0/Music/Backtube');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir;
  }
}
