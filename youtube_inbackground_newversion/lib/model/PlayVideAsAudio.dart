import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/model/VideoContoller.dart';
class PlayVideoAsAudio extends ChangeNotifier {
    YoutubeExplode yt = YoutubeExplode();
    AudioPlayer audioPlayer = AudioPlayer();
    VideoSearchList? lstSearch ;
    // The 3 line below is a Singleton for manage global variable for data accessing.
    static  PlayVideoAsAudio? _instance;
    int runtimeTime = 0;
    PlayVideoAsAudio._internalInstance();
    factory  PlayVideoAsAudio(){
        return _instance ?? PlayVideoAsAudio._internalInstance();
    }

    List<VideoContoller> allLstVideos = [];
    Future<List<VideoContoller>> searchYoutube(String searchType) async {
        // Dont delete the line below.
        runtimeTime = 1;
        notifyListeners();
        lstSearch = await yt.search.search(searchType);
        List<Video> lstVideosInfo =  lstSearch!.toList(growable: true);
        allLstVideos =  lstVideosInfo.map((el) =>
            VideoContoller(videoId: el.id.toString(),
                realDuration: el.duration ?? Duration.zero,
                isLive: el.isLive,
                titleVideo: el.title.toString(),
                videoDuration: customDurationText(el.duration ?? Duration.zero),
                videoChannel: el.channelId.value,
                videoWatchers:customViewsText( el.engagement.viewCount),
                )
        ).toList();
        notifyListeners();
        return allLstVideos;
    }
    Future<void> addMoreVideo() async{
        lstSearch!.nextPage();
        List<Video> lstVideosInfo = lstSearch!.toList();
        allLstVideos += lstVideosInfo.map((el) =>
            VideoContoller(videoId: el.id.toString(),
                realDuration: el.duration ?? Duration.zero,
                isLive: el.isLive,
                titleVideo: el.title.toString(),
                videoDuration: el.duration.toString(),
                videoChannel: el.channelId.toString(),
                videoWatchers:customViewsText( el.engagement.viewCount))
        ).toList();
        notifyListeners();
    }
    String customDurationText(Duration duration){
        try {
            if (duration.inSeconds == 0) {
                return "0";
            }
            String duratinString = duration.toString();
            List<String> lstDuration = duratinString.split(":");
            if (int.parse(lstDuration.first.toString()) == 0) {
                lstDuration.removeAt(0);
            }
            lstDuration.first =int.parse(lstDuration.first).toString();
            lstDuration.last = lstDuration.last.split(".")[0];
            return lstDuration.join(":");
        } catch ( e ) {
            return duration.toString();
        }
    }
    String customViewsText(int views){
        if(views < 1000){
            return "$views ";
        }else if(views >= 1000  && views < 1000000){
            var newViews = views / 1000;
            return "${newViews.toStringAsFixed(1)} K";
        }else if(views >= 1000000 && views < 1000000000){
            var newViews = views / 1000000;
            return "${newViews.toStringAsFixed(1)} M";
        }
        return "$views Md";
    }
    Future<String> playAudio(VideoContoller videoController) async {
        var videoId = videoController.getVideoId;
        if (videoController.getIsPlaying) {
            if( videoController.getIsLive){
                var manifest = await yt.videos.streams.getHttpLiveStreamUrl(VideoId(videoId));
                audioPlayer.play(UrlSource(manifest.toString()));
                print("audio played");
                return "work";
            }
            var manifest = await yt.videos.streamsClient.getManifest(videoId);
            var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
            audioPlayer.play(UrlSource(audioStreamInfo.url.toString()));
            print("audio played 2");
            return "work 2";
        }
        audioPlayer.pause();
        print("audio paused");
        return "work 3";
    }
    Future<void> updateValueDuration(VideoContoller videoController) async {
        //audioPlayer.onPositionChanged.listen((value){
        //    videoController.updateProgressValue = value.inSeconds.toDouble();
        //}) ;
    }
}
