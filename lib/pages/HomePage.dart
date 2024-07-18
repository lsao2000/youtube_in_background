import 'package:flutter/material.dart';
import 'package:youtube_in_background/pages/MusicObject.dart';
import 'package:youtube_in_background/pages/PlayVideoAsAudio.dart';

class HomePage extends StatefulWidget{
    late PlayVideoAsAudio playVideoAsAudio;
     HomePage({super.key, required this.playVideoAsAudio});
    @override
    HomePageState createState() => HomePageState(playVideoAsAudio:playVideoAsAudio );
}
class HomePageState extends State<HomePage> {
    HomePageState({required this.playVideoAsAudio});
    static String url = "https://iv.datura.network";
    static List<MusicObject> lstVideos = [ ];
    static List<String> lstImages = [];
    static var lstTitles = [];
    static List<String> lstYoutubeUrls = [];
    late PlayVideoAsAudio playVideoAsAudio;

    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return  ListView.builder(
            itemCount: lstYoutubeUrls.length,
            itemBuilder: (context, index){
                var musicObj = MusicObject(imageUrl: lstImages[index], title: lstTitles[index], videoId: lstYoutubeUrls[index]);
                return Column(
                    children: [
                        Container(
                            padding: EdgeInsets.symmetric(vertical: height*0.04, horizontal: width * 0.04),
                            width: width ,
                            height: height * 0.2,
                            child: Image.network("$url${musicObj.imageUrl}",
                                width: width,
                                height: height ,),
                        ),
                        RichText(text:TextSpan(
                                text:musicObj.title,
                                style:const TextStyle(color: Colors.black)
                        ), ),
                        SizedBox(width: 0, height: height * 0.02),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                FloatingActionButton(
                                    child: const Icon(Icons.play_arrow, color: Colors.green,),
                                    onPressed: (){
                                        var url = "https://www.youtube.com/watch?v=${musicObj.videoId}";
                                        playVideoAsAudio.playAudio(index, url);
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
            },
            );
    }
}
