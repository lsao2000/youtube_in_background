import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:youtube_in_background/pages/MusicObject.dart';
import 'package:youtube_in_background/pages/PlayVideoAsAudio.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class Home extends StatefulWidget{
     const Home({super.key});
     @override
     HomeState createState() => HomeState();
}
class HomeState extends  State<Home>{
    final String brand = "YoBack";
    String url = "https://iv.datura.network";
    String imageUrl = "";
    String title = "";
    String youtubeUrl = "";
    List<MusicObject> lstVideos = [ ];
    List<String> lstImages = [];
    var lstTitles = [];
    List<String> lstYoutubeUrls = [];
    late PlayVideoAsAudio playVideoAsAudio;
    // properties for youtube video
    //double volume = 100;
    //bool _muted = false;
    //bool _isPlayerReady = false;
    // Youtube Player
    //late PlayerState _playerState;
    //late YoutubeMetaData _metaData;
    late YoutubePlayerController _controller;
    @override
      void initState() {
        super.initState();
        playVideoAsAudio = PlayVideoAsAudio();
        playVideoAsAudio.initilizeAudioHandler();
        scrapData();
      }
    @override
      Widget build(BuildContext context) {
          double width = MediaQuery.of(context).size.width;
          double height = MediaQuery.of(context).size.height;
        return Scaffold(
            appBar: AppBar(
                title: Text(brand,
                    style: const TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                backgroundColor: Colors.deepOrangeAccent,
            ),
            body:lstTitles.isEmpty ? // this for check if this condition is true then display a circular Progress Indicator
            Center(
                child:Container(
               width: width * 0.15,
               height: height * 0.8,
               child:const CircularProgressIndicator(
                   color: Colors.orange,
                   )))
            : // if the condition is not true then display this listview with all items
            ListView.builder(
                itemCount: lstTitles.length,
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
                                           playVideoAsAudio.playAudio(index);
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
                        ],);
                },

                ),
            //YoutubePlayer(controller: _controller,
            //                showVideoProgressIndicator: true,
            //                progressIndicatorColor: Colors.red,
            //                progressColors: const ProgressBarColors(
            //                    playedColor: Colors.blue,
            //                    handleColor: Colors.green,
            //                ),
            //                onReady: (){
            //                    _controller.addListener((){
            //                    });
            //                }
            //            ),
                        //loadVideo() ,
            );
      }
    Future<void> scrapData() async {
        try {
            Parser? response = await Chaleno().load("https://iv.datura.network/search?q=music+game+music");
            var  imgUrl = response!.getElementsByTagName("img")!.map((el) => el.querySelector(".thumbnail")).first;
            Iterable<List<Result>?> imgUrlTwo = response!.getElementsByTagName("img")!.map((el) => el.querySelectorAll(".thumbnail"));
            var titlevalue = response.getElementsByClassName("video-card-row")
                    .map((el) {
                        var aElement = el.querySelector("a");
                        if(aElement?.href.toString().split("/")[1] != "channel"){
                            var pElement = aElement?.querySelector("p");
                            return pElement?.text;
                        }
                    });
            var youtubeUrls = imgUrlTwo.map((el) {
               var imgSrc = el!.first.src;
               var youtubeId = imgSrc.toString().split('/')[2];
               return youtubeId;
            });
            var nl= [];
            setState((){
                // List with clean data.
                lstTitles = titlevalue.toList();
                 lstImages = imgUrlTwo.map((el) => el!.first.src!).toList();
                 for(int x = 0; x < lstTitles.length; x++){
                     if(lstTitles[x] == Null || lstTitles[x].toString() == "null" || lstTitles[x] == null){
                         lstTitles.remove(x);
                     }
                     else if(lstTitles[x].runtimeType != String){
                         lstTitles.remove(lstTitles[x]);
                     }
                     else{
                         //lst[x] = "_${lst[x]}_";
                         nl.add(lstTitles[x]);
                     }
                 }
                 lstTitles = nl;
                //String string = titlevalue.toList().join(",").replaceAll(',null','');
                //List<String> lstTitles = string.split(",");
                lstYoutubeUrls = youtubeUrls.toList();
                //
                PlayVideoAsAudio.addYoutubeIds(lstYoutubeUrls);
                //imageUrl = imgUrl!.src ?? "";
                //youtubeUrl = imageUrl.toString().split('/')[2];
                //var musicObj = MusicObject(imageUrl: imageUrl, title: "noting", videoId: "nothing");
                //lstVideos.add(musicObj);
                //_controller = YoutubePlayerController(
                //    initialVideoId: youtubeUrl,
                //    flags: const YoutubePlayerFlags(
                //        autoPlay: true,
                //        mute: false,
                //        ),
                //    );
            });

        }catch(e ) {
            //if(e.toString() == "Bad state: No element"){
                scrapData();
            //}
            print("Error hna: ${e.toString()}");
        }
    }
    //YoutubePlayer loadVideo() async {
    //    String videoId = await scrapData();
    //   setState(()  {
    //    _controller = YoutubePlayerController(
    //        initialVideoId: videoId,
    //        flags: const YoutubePlayerFlags(
    //            autoPlay: true,
    //            mute: false,
    //        ),
    //    );
    //
    //
    //   });
    //    return YoutubePlayer(controller: _controller,
    //        showVideoProgressIndicator: true,
    //        progressIndicatorColor: Colors.red,
    //        progressColors: const ProgressBarColors(
    //            playedColor: Colors.blue,
    //            handleColor: Colors.green,
    //            ),
    //        onReady: (){
    //            _controller.addListener((){
    //            });
    //        }
    //        );
    //}
}
