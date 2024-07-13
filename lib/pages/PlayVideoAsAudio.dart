import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';

class PlayVideoAsAudio {
    late Audioplayerhandler audioplayerhandler;
    late String? youtubeUrl;
    static List<String?> lstYoutubeIds = [];
    static List<String?> lstImagesUrl = [];
    static var lstTitles = [];
    static late var lstYoutubeUrl;
    Future<void> initilizeAudioHandler() async {
        audioplayerhandler = await AudioService.init(
            builder: () => Audioplayerhandler(),
            config: const AudioServiceConfig(
                    androidNotificationChannelId: 'com.example.youtube_in_background.channel.audio',
                    androidNotificationChannelName: 'Audio Channel',
                    androidNotificationOngoing: true,
                )
            );
    }
    static Future<void> addImageUrl(List<String> lstImageUrl) async {
        for (String item in lstImageUrl){
            lstImagesUrl.add(item);
        }
    }
    static Future<void> addTitles(List<dynamic> lstTitle) async {
        for(dynamic item in lstTitle){
            lstTitles.add(item);
        }
    }
    static Future<void> addYoutubeIds(List<String> lstYoutubeId) async {
        //lstYoutubeUrl = lstYoutubeId;
        for(String? item in lstYoutubeId)  {
            String? youtubeUrl = await getYoutubeUrl("https://www.youtube.com/watch?v=$item") ;
            //if(youtubeUrl == null){
            //    int index = lstYoutubeIds.indexOf(item);
            //    lstTitles.removeAt(index);
            //    lstImagesUrl.removeAt(index);
            //    continue;
            //}
            lstYoutubeIds.add(youtubeUrl);
        }
        print("length: ${lstYoutubeIds.length}");
    }
    static  Future<String?> getYoutubeUrl(String url) async {
        var yt = YoutubeExplode();
        try{
           var video = await yt.videos.get(url);
           if(video.isLive){
               return null;
           }
           print("Video Id: ${video.id}");
           var manifest = await yt.videos.streamsClient.getManifest(video.id);
           var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
           return audioStreamInfo.url.toString();
        }catch (e){
            return null;
        }
        finally{ yt.close();}
    }
    //Future<void> filterYoutubeUrl() async {
    //    for(dynamic item in lstYoutubeIds){
    //        if(item == null){
    //                        }
    //    }
    //}
    Future<void> playAudio(int index, String url) async {
        var yt = YoutubeExplode();
        String youtubeUrl = "";
        try{
            //var count = 0;
            //for (dynamic it in lstYoutubeUrl){
            //    var video = await yt.videos.get("https://www.youtube.com/watch?v=$it");
            //    if(!video.isLive){
            //        count += 1;
            //    }
            //}
            print("playing video with Id: ${lstYoutubeIds[index]}");
            youtubeUrl = lstYoutubeIds[index]!;
        }catch(e) {
            print("unkown error 1 in playing audid: $e");
            try {
                var video = await  yt.videos.get(url);
                var manifest = await yt.videos.streamsClient.getManifest(video.id);
                var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
                youtubeUrl = audioStreamInfo.url.toString();
            } catch (e) {
                print("unkonwn error 2 in Playing audio: $e");
            }
        }
        await audioplayerhandler.setUrl(youtubeUrl);
        audioplayerhandler.play();
    }
    Future<void> pauseAudio() async {
            audioplayerhandler.pause();
    }
}
