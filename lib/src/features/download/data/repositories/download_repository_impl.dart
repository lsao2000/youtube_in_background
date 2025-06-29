import 'package:flutter/foundation.dart';
import 'package:youtube_inbackground_newversion/src/features/download/data/data_source/localDb/downloads_local_db.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/repository/donwload_repository.dart';

class DownloadRepositoryImpl implements DownloadRepository {
  DownloadsLocalDb downloadsLocalDb;
  DownloadRepositoryImpl({required this.downloadsLocalDb});
  @override
  Future<List<DownloadedVideoModel>> getDownloadedAudios() async {
    return await downloadsLocalDb.getDownloads();
  }

  @override
  Future<bool> fileExists(String filePath) {
    throw UnimplementedError();
  }

  @override
  Future<String> downloadFile(String url, String destinationPath) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateDownloadedProgress(String filePath, double progress) {
    throw UnimplementedError();
  }

  @override
  Future<void> addDownloadedFile(
      {required DownloadedVideoModel downloadedVideoModel}) {
    throw UnimplementedError();
  }
}
