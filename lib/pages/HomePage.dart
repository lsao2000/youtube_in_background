import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/PlayVideoAsAudio.dart';
import 'package:youtube_in_background/pages/Home.dart';
class HomePage extends StatefulWidget{
    //late PlayVideoAsAudio playVideoAsAudio;
    const HomePage({super.key});
    @override
    HomePageState createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
    HomePageState();
    static String url = "https://iv.datura.network";
    final YoutubeExplode yt = YoutubeExplode();
    PlayVideoAsAudio playVideoAsAudio = HomeState.playVideoAsAudio;
    @override
      void initState() {
        super.initState();
      }
    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
                return Column(
                    children: [
                        SizedBox(width: 0, height: height * 0.02),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                FloatingActionButton(
                                    child: const Icon(Icons.play_arrow, color: Colors.green,),
                                    onPressed: () async{
                                        var url = "https://www.youtube.com/watch?v=D4i1J90oNEg&t=597s&ab_channel=wevibin%E2%80%99";
                                        var data = await yt.videos.get("D4i1J90oNEg");
                                        var image = await yt.videos.get("D4i1J90oNEg");
                                        var imageUrl =image.thumbnails.highResUrl.toString();
                                        String   titleVi  = data.title;
                                        String    descriptionVi = data.description;
                                        try {
                                            playVideoAsAudio.playAudio(0, url, imageUrl, titleVi, descriptionVi);
                                        } catch (e) {
                                            print("some error with service: ${e.toString()}");
                                        }
                                    },
                                    backgroundColor: Colors.orange,
                                ),
                                FloatingActionButton(
                                    child: const Icon(Icons.pause),
                                    onPressed: (){
                                        playVideoAsAudio.pauseAudio();
                                    },
                                    backgroundColor: Colors.orange,
                                )
                            ],
                        )
                    ],
        );
    }
}
