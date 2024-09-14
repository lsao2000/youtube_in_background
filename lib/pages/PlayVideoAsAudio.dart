import 'package:audio_service/audio_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';
import 'package:youtube_in_background/services/audio_handler.dart';

class PlayVideoAsAudio {
    //late MyAudioHandler myAudioHandler;
    late Audioplayerhandler audioplayerhandler;
    late String? youtubeUrl;
    static List<String?> lstYoutubeIds = [];
    static List<String?> lstImagesUrl = [];
    static var lstTitles = [];
    //static late var lstYoutubeUrl;
    Future<void> initilizeAudioHandler(String url) async {
        try {
            audioplayerhandler = await AudioService.init(
                builder: () => Audioplayerhandler(),
                config: const AudioServiceConfig(
                    androidNotificationChannelId: 'com.mycompany.myapp.audio',
                    androidNotificationChannelName: 'Audio Service Demo',
                    androidNotificationOngoing: true,
                    androidStopForegroundOnPause: true,
                ),
            );
            audioplayerhandler.setUrl(url);
        } catch (e) {
            print("error in service ${e.toString()}");
        }
        //audioplayerhandler = await AudioService.init(
        //    builder: () => Audioplayerhandler(),
        //    config: const AudioServiceConfig(
        //            androidNotificationChannelId: 'com.example.youtube_in_background.channel.audio',
        //            androidNotificationChannelName: 'Audio Channel',
        //        )
        //    );

    }
    //static Future<void> addImageUrl(List<String> lstImageUrl) async {
    //    for (String item in lstImageUrl){
    //        lstImagesUrl.add(item);
    //    }
    //}
    //static Future<void> addTitles(List<dynamic> lstTitle) async {
    //    for(dynamic item in lstTitle){
    //        lstTitles.add(item);
    //    }
    //}
    //static Future<void> addYoutubeIds(List<String> lstYoutubeId) async {
    //    for(String? item in lstYoutubeId)  {
    //        String? youtubeUrl = await getYoutubeUrl("https://www.youtube.com/watch?v=$item") ;
    //        lstYoutubeIds.add(youtubeUrl);
    //    }
    //}
    //static  Future<String?> getYoutubeUrl(String url) async {
    //    var yt = YoutubeExplode();
    //    try{
    //       var video = await yt.videos.get(url);
    //       if(video.isLive){
    //           return null;
    //       }
    //       var manifest = await yt.videos.streamsClient.getManifest(video.id);
    //       var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    //       return audioStreamInfo.url.toString();
    //    }catch (e){
    //        return null;
    //    }
    //    finally{ yt.close();}
    //}
    Future<void> playAudio(int index, String url, String image, String title, String description) async {
        try {
            var yt = YoutubeExplode();
            String youtubeUrl = "";
            try {
                var video = await  yt.videos.get(url);
                var manifest = await yt.videos.streamsClient.getManifest(video.id);
                var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
                youtubeUrl = audioStreamInfo.url.toString();
                await initilizeAudioHandler(youtubeUrl);
                List<Map<String, String>> music = [{
                    'id': video.id.toString(),
                    'title': video.title,
                    'album': video.author,
                    'url':"https://img.youtube.com/vi/${video.id}/default.jpg"
                }];
                List<MediaItem> mediaItems = music
                        .map( (audio) => MediaItem(
                                id: audio['id'] ?? '',
                                title: audio['title'] ?? '',
                                album: audio['album'] ?? '',
                                extras: {'url': youtubeUrl},
                                artUri: Uri.parse(audio['url'] ?? ''),
                                displaySubtitle: video.description
                        )).toList();
                audioplayerhandler.addQueueItems(mediaItems);
                audioplayerhandler.play();
            } catch (e) {
                print("unkonwn error 2 in Playing audio: $e");
            }
        } catch (e) {
                print("unkonwn error  in audio Service: $e");
        }
    }
    Future<void> pauseAudio() async {
            //myAudioHandler.pause();
        audioplayerhandler.pause();
    }
}
