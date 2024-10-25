import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/service/my_audio_handler.dart';
import 'package:youtube_inbackground_newversion/model/VideoContoller.dart';
class PlayVideoAsAudio extends ChangeNotifier {
  YoutubeExplode yt = YoutubeExplode();
  VideoSearchList? lstSearch;

  late MyAudioHandler myAudioHandler;
  // The 3 line below is a Singleton for manage global variable for data accessing.
  int runtimeTime = 0;
  PlayVideoAsAudio() {
    initiliazeAudioHandler();
  }
  List<VideoContoller> allLstVideos = [];
  Future<List<VideoContoller>> searchYoutube(String searchType) async {
    // Dont delete the line below.
    runtimeTime = 1;
    notifyListeners();
    lstSearch = await yt.search.search(searchType);
    List<Video> lstVideosInfo = lstSearch!.toList(growable: true);
    allLstVideos = lstVideosInfo
        .map((el) => VideoContoller(
              videoId: el.id.toString(),
              realDuration: el.duration ?? Duration.zero,
              isLive: el.isLive,
              titleVideo: el.title.toString(),
              videoDuration: customDurationText(el.duration ?? Duration.zero),
              videoChannel: el.channelId.value,
              videoWatchers: customViewsText(el.engagement.viewCount),
            ))
        .toList();
    notifyListeners();
    return allLstVideos;
  }

  Future<void> initiliazeAudioHandler() async {
    try {
      myAudioHandler = await AudioService.init(
          builder: () => MyAudioHandler(),
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.mycompany.myapp.audio',
            androidNotificationChannelName: 'Audio Service Demo',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true,
          ));
      myAudioHandler.playbackState.listen((state) {
        notifyListeners();
      });
    } catch (e) {
      print("error in initiliaze audio service${e.toString()}");
    }
  }

  Future<void> addMoreVideo() async {
    try {
      if (allLstVideos.length < 40) {
        lstSearch!.nextPage();
        List<Video> lstVideosInfo = lstSearch!.toList();
        allLstVideos += lstVideosInfo
            .map((el) => VideoContoller(
                videoId: el.id.toString(),
                realDuration: el.duration ?? Duration.zero,
                isLive: el.isLive,
                titleVideo: el.title.toString(),
                videoDuration: customDurationText(el.duration ?? Duration.zero),
                videoChannel: el.channelId.toString(),
                videoWatchers: customViewsText(el.engagement.viewCount)))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      print("error : ${e.toString()}");
    }
  }

  String customDurationText(Duration duration) {
    try {
      if (duration.inSeconds == 0) {
        return "0";
      }
      String duratinString = duration.toString();
      List<String> lstDuration = duratinString.split(":");
      if (int.parse(lstDuration.first.toString()) == 0) {
        lstDuration.removeAt(0);
      }
      lstDuration.first = int.parse(lstDuration.first).toString();
      lstDuration.last = lstDuration.last.split(".")[0];
      return lstDuration.join(":");
    } catch (e) {
      return duration.toString();
    }
  }

  String customViewsText(int views) {
    if (views < 1000) {
      return "$views ";
    } else if (views >= 1000 && views < 1000000) {
      var newViews = views / 1000;
      return "${newViews.toStringAsFixed(1)} K";
    } else if (views >= 1000000 && views < 1000000000) {
      var newViews = views / 1000000;
      return "${newViews.toStringAsFixed(1)} M";
    }
    return "$views Md";
  }

  Future<bool> playAudio(VideoContoller videoController) async {
    try {
      var videoId = videoController.getVideoId;
      if (videoController.getIsPlaying) {
        String url = "";
        if (videoController.getIsLive) {
          var manifest =
              await yt.videos.streams.getHttpLiveStreamUrl(VideoId(videoId));
          url = manifest.toString();
        }
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
        url = audioStreamInfo.url.toString();
        var video =
            await yt.videos.get("https://www.youtube.com/watch?v=$videoId");
        await initiliazeAudioHandler();
        myAudioHandler.setUrl(url);
        List<Map<String, String>> music = [
          {
            'id': video.id.toString(),
            'title': video.title,
            'album': video.author,
            'url': "https://img.youtube.com/vi/${video.id}/default.jpg"
          }
        ];
        List<MediaItem> mediaItems = music
            .map((audio) => MediaItem(
                id: audio['id'] ?? '',
                title: audio['title'] ?? '',
                album: audio['album'] ?? '',
                extras: {'url': url},
                artUri: Uri.parse(audio['url'] ?? ''),
                displaySubtitle: video.description))
            .toList();
        myAudioHandler.addQueueItems(mediaItems);
        myAudioHandler.play();
        return true;
      }
      myAudioHandler.pause();
      return false;
    } catch (e) {
      print("some error in initialize audio service ${e.toString()}");
      return false;
    }
  }
  Future<void> playFavoriteAudio(FavoriteVideoHistory favoriteVideoHistory) async{
    try {
      String videoId = favoriteVideoHistory.videoId;
      //if (favoriteVideoHistory.isPlaying) {
      //  myAudioHandler.play();
      //} else {
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
        myAudioHandler.setUrl(url);
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
        myAudioHandler.addQueueItems(mediaItem);
        myAudioHandler.play();
        notifyListeners();
      //}
    } catch (e) {
      print("error in playing ${e.toString()}");
    }
  }
}
