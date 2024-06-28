import 'package:audio_service/audio_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';

class PlayVideoAsAudio {
    late Audioplayerhandler audioplayerhandler;
    late String? youtubeUrl;
    static List<String?> lstYoutubeIds = [];
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

    static Future<void> addYoutubeIds(List<String> lstYoutubeId) async {
        for(String? item in lstYoutubeId)  {
            String? youtubeUrl = await getYoutubeUrl("https://www.youtube.com/watch?v=$item") ;
            lstYoutubeIds.add(youtubeUrl);
        }
        print("length: ${lstYoutubeIds.length}");
    }

   static  Future<String?> getYoutubeUrl(String url) async {
        var yt = YoutubeExplode();
        try{
           var video = await yt.videos.get(url);
           print("Video Id: ${video.id}");
           var manifest = await yt.videos.streamsClient.getManifest(video.id);
           var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
           return audioStreamInfo.url.toString();
        }catch (e){
            print("Error $e");
            return getLiveVideoUrl(url);
            //return null;
        }
        finally{ yt.close();}
    }
   static Future<String?> getLiveVideoUrl(String url) async {
       var yt = YoutubeExplode();
    try{
        var video = await yt.videos.get(url);
        print("video id: ${video.id}");
        var manifest = await yt.videos.streamsClient.getManifest(video.id);
        var audioStreamInfo = manifest.muxed.withHighestBitrate();
        //audioplayerhandler.play
        return audioStreamInfo.url.toString();
    }catch(e){
        print("Error m2akad : $e");
        return null;
    }
   }
    Future<void> playAudio(int index) async {
        //if(youtubeUrl != null){
        try{
            print("Id: ${lstYoutubeIds[index]}");
            String youtubeUrl = lstYoutubeIds[index]!;
            await audioplayerhandler.setUrl(youtubeUrl);
            audioplayerhandler.play();
        //} else
        }catch(e) {
            print("Failed to get audio url: $e");
            //playAudio(url);
        }
    }
    Future<void> pauseAudio() async {
        //String? youtubeUrl = await getYoutubeUrl(url);
        //if(youtubeUrl != null){
            //audioplayerhandler.setUrl(youtubeUrl ?? "");
            audioplayerhandler.pause();
        //}else{
            //print("Failed to get Url ");
        //}
    }
}
