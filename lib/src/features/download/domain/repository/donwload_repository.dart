import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';

/// Downloads a file from the given [url] and saves it to the specified [destinationPath].
abstract class DownloadRepository {
  Future<String> downloadFile(String url, String destinationPath);
  // Future<void> cancelDownload(String filePath);
  Future<void> addDownloadedFile(
      {required DownloadedVideoModel downloadedVideoModel});

  Future<List<DownloadedVideoModel>> getDownloadedAudios();

  Future<void> updateDownloadedProgress(String filePath, double progress);

  /// Checks if a file exists at the specified [filePath].
  Future<bool> fileExists(String filePath);
}
