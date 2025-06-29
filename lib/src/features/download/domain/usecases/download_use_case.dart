import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/repository/donwload_repository.dart';

class DownloadUseCase {
  final DownloadRepository downloadRepository;
  DownloadUseCase({required this.downloadRepository});

  Future<bool> downloadFile(String url) async {
    try {
      await downloadRepository.downloadFile(url, '');
      return true;
    } catch (e) {
      debugPrint('Download failed: $e');
      return false;
    }
  }

  Future<void> addDownloadedFile(
      DownloadedVideoModel downloadedVideoModel) async {
    try {
      await downloadRepository.addDownloadedFile(
          downloadedVideoModel: downloadedVideoModel);
    } catch (e) {
      debugPrint('Failed to add downloaded file: ${e.toString()}');
    }
  }

  Future<List<DownloadedVideoModel>> getDownloadedVideos() async {
    return await downloadRepository.getDownloadedAudios();
  }
}
