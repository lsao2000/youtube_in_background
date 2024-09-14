import 'package:flutter/material.dart';
import 'package:youtube_in_background/pages/FavouritePage.dart';
import 'package:youtube_in_background/pages/HomePage.dart';
import 'package:youtube_in_background/pages/LivesPage.dart';
import 'package:youtube_in_background/pages/MusicObject.dart';
import 'package:youtube_in_background/pages/PlayVideoAsAudio.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
class Home extends StatefulWidget{
     const Home({super.key});
     @override
     HomeState createState() => HomeState();
}
class HomeState extends  State<Home>{
    final String brand = "YoBack";
    String url = "https://iv.datura.network";
    List<MusicObject> lstVideos = [ ];
    List<String> lstImages = [];
    var lstTitles = [];
    var selectedPageIndex = 0;
    List<String> lstYoutubeUrls = [];
    static late PlayVideoAsAudio playVideoAsAudio;
    static  List<Widget> lstNavigations = [  HomePage(),  FavouritePage(),  LivesPage()];
    //late YoutubePlayerController _controller;
    @override
      void initState() {
        super.initState();
        setState(() {
            playVideoAsAudio = PlayVideoAsAudio();
            //playVideoAsAudio.initilizeAudioHandler();
        });
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
            body:
            //body:lstTitles.isEmpty ? // this for check if this condition is true then display a circular Progress Indicator
            //Center(
            //    child:Container(
            //        width: width * 0.15,
            //        height: height * 0.2,
            //        child:const CircularProgressIndicator(
            //            color: Colors.orange,
            //        )))
            //: // if the condition is not true then display this listview with all items
            lstNavigations[selectedPageIndex],
            bottomNavigationBar: BottomNavigationBar(
                items:const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(Icons.home),  label: "Home"),
                    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
                    BottomNavigationBarItem(icon: Icon(Icons.videocam), label:"Lives")
                ],
                currentIndex:selectedPageIndex ,
                backgroundColor: Colors.deepOrange,
                selectedItemColor: Colors.white,
                onTap: (index){
                    setState((){
                        selectedPageIndex = index;
                    });
                },
            ),
        );
    }
    //Widget homePage(){
    //    double width = MediaQuery.of(context).size.width;
    //    double height = MediaQuery.of(context).size.height;
    //    return  ListView.builder(
    //            itemCount: lstYoutubeUrls.length,
    //            itemBuilder: (context, index){
    //                var musicObj = MusicObject(imageUrl: lstImages[index], title: lstTitles[index], videoId: lstYoutubeUrls[index]);
    //                return Column(
    //                    children: [
    //                        Container(
    //                            padding: EdgeInsets.symmetric(vertical: height*0.04, horizontal: width * 0.04),
    //                            width: width ,
    //                            height: height * 0.2,
    //                            child: Image.network("$url${musicObj.imageUrl}",
    //                                width: width,
    //                                height: height ,),
    //                        ),
    //                        RichText(text:TextSpan(
    //                                text:musicObj.title,
    //                                style:const TextStyle(color: Colors.black)
    //                                ), ),
    //                        SizedBox(width: 0, height: height * 0.02),
    //                        Row(
    //                            crossAxisAlignment: CrossAxisAlignment.center,
    //                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                            children: [
    //                                FloatingActionButton(
    //                                    child: const Icon(Icons.play_arrow, color: Colors.green,),
    //                                    onPressed: (){
    //                                        var url = "https://www.youtube.com/watch?v=${musicObj.videoId}";
    //                                       playVideoAsAudio.playAudio(index, url);
    //                                    },
    //                                    backgroundColor: Colors.orange,
    //                                ),
    //                                FloatingActionButton(
    //                                    child: const Icon(Icons.pause),
    //                                    onPressed: (){
    //                                        playVideoAsAudio.pauseAudio();
    //                                    },
    //                                    backgroundColor: Colors.orange,
    //                                )
    //                            ],
    //                        )
    //                    ],
    //                );
    //            },
    //            );
    //}
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


 //_controller = YoutubePlayerController(
                //    initialVideoId: youtubeUrl,
                //    flags: const YoutubePlayerFlags(
                //        autoPlay: true,
                //        mute: false,
                //        ),
                //    );
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

