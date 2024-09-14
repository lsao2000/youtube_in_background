import 'package:audio_service/audio_service.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';
//import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';
//import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';

class PlayVideoTest extends StatefulWidget{
    const PlayVideoTest({super.key});
    //final Audioplayerhandler audioplayerhandler;
    @override
    PlayVideoTestState createState() => PlayVideoTestState();
}

class PlayVideoTestState extends State<PlayVideoTest> {
    //PlayVideoTestState({required this.audioHandler});
    String url = "https://iv.datura.network";
    late String youtubeUrl;
    late AudioPlayerHandler audioHandler ;
    @override
      void initState() {
        scrapData();
        try {
                initialiseAudioHandler();
                } catch (e) {
            print("IlegalExceptionError: $e");
                }
        super.initState();
      }
    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: const Text("YoBack",
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                ),
                backgroundColor: Colors.deepOrange,
                ),
            body: Column(
            children: [ElevatedButton(
              onPressed: () async {
                String? audioUrl = await getYoutubeAudioUrl("https://www.youtube.com/watch?v=QGi3vcs8cH8");
                if (audioUrl != null) {
                  await audioHandler.setUrl(audioUrl);
                  audioHandler.play();
                } else {
                  print('Failed to get audio URL');
                }
              },
              child: Text('Play Audio'),
            ),
            ElevatedButton(
              onPressed: () => audioHandler.pause(),
              child: Text('Pause'),
            ),
            ]),
        );
    }
    Future<void> scrapData() async {
        final response = await Chaleno().load("$url/search?q=music+game+music");
        var Id = response!.getElementsByTagName("img")!.map((el) => el.querySelector(".thumbnail")).first;
        setState(() {
           var youtubeId = Id!.src.toString().split('/')[2];
           youtubeUrl = "https://www.youtube.com/watch?v=$youtubeId";
        });
        getYoutubeAudioUrl("https://www.youtube.com/watch?v=QGi3vcs8cH8");
    }
    Future<String?> getYoutubeAudioUrl(String url) async {
        var yt = YoutubeExplode();
        try{
           var video = await yt.videos.get(url);
           print("Video Id: ${video.id}");
           var manifest = await yt.videos.streamsClient.getManifest(video.id);
           var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
           return audioStreamInfo.url.toString();
        }catch(e){
            print("some error: $e");
            return null;
        }finally{
            yt.close();
        }
    }
    Future<AudioPlayerHandler> initialiseAudioHandler() async {
         audioHandler = await AudioService.init(
             builder: () => AudioPlayerHandler(),
            config: const AudioServiceConfig(
                androidNotificationChannelId: 'com.example.youtube_in_background.channel.audio',
                androidNotificationChannelName: 'Audio Channel',
                androidNotificationOngoing: true,
            )
        );
         return audioHandler;
    }
}
