import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/usecases/download_use_case.dart';

class DownloadController extends GetxController {
  RxDouble downloadProgress = 0.0.obs;
  RxBool isDownloading = false.obs;
  RxList<DownloadedVideoModel> downloadedVideos = <DownloadedVideoModel>[].obs;
  final DownloadUseCase downloadUseCase;
  DownloadController({required this.downloadUseCase});
  @override
  void onInit() {
    super.onInit();
    getDownloadedVideos();
  }

  getDownloadedVideos() async {
    await downloadUseCase.getDownloadedVideos().then((value) {
      debugPrint("Downloaded videos retrieved: ${value.length}");
      debugPrint("Downloaded videos: ${value.map((e) => e.title).toList()}");
      downloadedVideos.value = value;
      downloadedVideos.refresh();
    });
    // .catchError((error) {
    //   debugPrint("Error fetch downloaded videos: $error");
    // });
  }
}
