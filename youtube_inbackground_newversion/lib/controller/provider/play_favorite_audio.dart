import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/service/favorite_history_audio_handler.dart';

class PlayFavoriteAudio extends ChangeNotifier {
  YoutubeExplode yt = YoutubeExplode();
  late FavoriteHistoryAudioHandler  audioHandler;
  PlayFavoriteAudio() {
    //initilizeAudioHandler();
  }
  Future<void> initilizeAudioHandler() async {
    try {
        audioHandler = await initAudioService();
      audioHandler.playbackState.listen((state) {
        notifyListeners();
        log("initiliazing succes");
      });
      notifyListeners();
    } catch (e) {
      print("oh oh we got errors in audio ${e.toString()}");
      log(e.toString());
    }
  }

  Future<void> playAudio(FavoriteVideoHistory favoriteVideoHistory,
      ) async {
    try {
      String videoId = favoriteVideoHistory.videoId;
      if (favoriteVideoHistory.isPlaying) {
        print("resume");
        audioHandler.play();
      } else {
        print("play");
        String url = "";
        if (favoriteVideoHistory.isLive) {
          var manifest = yt.videos.streams.getHttpLiveStreamUrl(VideoId(videoId));
          url = manifest.toString();
        } else {
          var manifest = await yt.videos.streams.getManifest(videoId);
          var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
          url = audioStreamInfo.url.toString();
        }
        var audioInfo = await yt.videos.get(videoId);
        await initilizeAudioHandler();
        audioHandler.setUrl(url);
        List<Map<String, String>> allMusic = [{
          'id': audioInfo.id.toString(),
          'title': audioInfo.title,
          'album': audioInfo.author,
          'url': "https://img.youtube.com/vi/${audioInfo.id}/default.jpg"
        }];
        List<MediaItem> mediaItem =allMusic.map((music)=> MediaItem(
            id: music['id'] ?? '',
            title: music['title'] ?? 'error',
            album: music['album'] ?? 'empty',
            extras: {'url': url},
            artUri: Uri.parse(music['url'] ?? ''),
            displaySubtitle: audioInfo.description)).toList();
        audioHandler.addQueueItems(mediaItem);
        //audioHandler.addQueueItem(mediaItem);
        audioHandler.play();
        notifyListeners();
      }
    } catch (e) {
      print("error in playing ${e.toString()}");
    }
  }
}
