import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_in_background/pages/FavouritePage.dart';
import 'package:youtube_in_background/pages/HomePage.dart';
import 'package:youtube_in_background/pages/LivesPage.dart';
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
    List<MusicObject> lstVideos = [ ];
    List<String> lstImages = [];
    var lstTitles = [];
    var selectedPageIndex = 0;
    List<String> lstYoutubeUrls = [];
    late PlayVideoAsAudio playVideoAsAudio;
    static  List<Widget> lstNavigations = [ const HomePage(), const FavouritePage(), const LivesPage()];
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
        //scrapData();
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
                    height: height * 0.2,
                    child:const CircularProgressIndicator(
                        color: Colors.orange,
                    )))
            : // if the condition is not true then display this listview with all items
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
    Widget homePage(){
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
    Future<void> filterData() async {
        var yt = YoutubeExplode();
        List<String> newYoutubeUrl = [];
        List<String> newTitles = [];
        List<String> newImages = [];
        print("before change: ");
        print("length of lstYoutubeURl: ${lstYoutubeUrls.length}");
        print("length of lstYoutubeImages: ${lstImages.length}");
        print("length of lstTitles: ${lstTitles.length}");
        for(String it in lstYoutubeUrls){
            var video =await yt.videos.get(it);
            if (!video.isLive) {
                var index = lstYoutubeUrls.indexOf(it);
                //lstYoutubeUrls.removeAt(index);
                newYoutubeUrl.add(lstYoutubeUrls[index]);
                newImages.add(lstImages[index]);
                newTitles.add(lstTitles[index]);
            }
        }
        setState(() {
            lstYoutubeUrls = newYoutubeUrl;
            lstImages = newImages;
            lstTitles = newTitles;
        });
        print("after changes: ");
        print("length of lstYoutubeURl: ${lstYoutubeUrls.length}");
        print("length of lstYoutubeImages: ${lstImages.length}");
        print("length of lstTitles: ${lstTitles.length}");

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
               return youtubeId.toString();
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
                lstYoutubeUrls = youtubeUrls.toList();
                PlayVideoAsAudio.addYoutubeIds(lstYoutubeUrls);
            });
            filterData();
        }catch(e) {
            print("Error low internet connection: ${e.toString()}");
            scrapData();
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

