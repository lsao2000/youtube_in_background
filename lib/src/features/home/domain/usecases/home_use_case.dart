import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/repository/home_repository.dart';

class HomeUseCase {
  final HomeRepository homeRepository;
  HomeUseCase({required this.homeRepository});

  Future<bool> addToFavorite({required String videoId}) async {
    var body = await homeRepository.addToFavorite(videoId: videoId);
    if (body["success"]) {
      debugPrint(body["msg"].toString());
      return true;
    } else {
      debugPrint(body["msg"].toString());
      return false;
    }
  }

  Future<bool> removeFromFavorite({required int favoriteId}) async {
    await homeRepository.removeFromFavorite(favoriteId: favoriteId);
    return true;
  }
}
