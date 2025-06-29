import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/downloaded_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/favorite_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;
  HomeUseCase({required this.homeRepository});

  Future<bool> addToFavorite({required String videoId}) async {
    var body = await homeRepository.addToFavorite(videoId: videoId);
    if (body["success"]) {
      debugPrint(body["msg"].toString());
      return true;
    }
    debugPrint(body["msg"].toString());
    return false;
  }

  Future<bool> removeFromFavorite({required String videoId}) async {
    var body = await homeRepository.removeFromFavorite(videoId: videoId);
    if (body["success"]) {
      debugPrint(body["msg"].toString());
      return true;
    }
    debugPrint(body["msg"].toString());
    return false;
  }

  Future<List<FavoriteModel>> getAllFavorite() async {
    var body = await homeRepository.getAllFavorite();
    if (body["success"]) {
      debugPrint(body["msg"]);
      return body["data"];
    }
    debugPrint(body["msg"]);
    return body["data"];
  }

  Future<void> addDownloadedVideo(
      {required DownloadedVideoModel downloadedVideoModel}) async {
    homeRepository.addDownloadedVideo(
      downloadedVideoModel: downloadedVideoModel,
    );
  }
}
