
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youtube_in_background/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
////
class FavouritePage extends StatefulWidget {
    const FavouritePage({super.key});
    @override
    FavouritePageState createState() => FavouritePageState();
}

class FavouritePageState extends State<FavouritePage> {
     AudioPlayer _audioPlayer = AudioPlayer();
     YoutubeExplode _youtubeExplode = YoutubeExplode();
     late VideoSearchList lst ;
     List<String> allVideo = [];
    //late String _audioUrl;
    //String apiKey = 'AIzaSyDgqTH_UQhL0Uijj5euCEVnw-P7G-4rDrg';
    //String channelId = '@tokyospliff';
    List<Video> lstVideos = [];
    List<String> lstVideosInfo = [];
    @override
    void initState() {
        super.initState();
        //_fetchLiveAudioUrl();
        try {
            fetchData();
        } catch (e) {
            print("nothing found : ${e.toString()}");
        }
        setState(() {
            //_audioPlayer = AudioPlayer();
            //_youtubeExplode = YoutubeExplode();
            //_audioUrl = "";
        });
    }
    Future<void> fetchData() async {
        try {
            print("function work");
            setState(() async{
                lst = await _youtubeExplode.search.search("chill music");
                lstVideos= lst.toList(growable: true);
                lstVideosInfo = lstVideos.map((el) => "id:${el.url}, title: ${el.title}").toList();
                allVideo+= lstVideosInfo;
            });
        } catch (e) {
            print("error in fetching data: ${e.toString()}");
        }
    }
    //Future<void> _fetchLiveAudioUrl() async {
    //    try {
    //        String videoId = await "9UMxZofMNbA";
    //        //String videoId = await _getLiveVideoId(apiKey, channelId);
    //        var manifest = await _youtubeExplode.videos.streamsClient.getManifest(videoId);
    //        //print("error before audio stream info");
    //        var audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    //        setState((){
    //            _audioUrl = audioStreamInfo.url.toString();
    //            print("----------${_audioUrl.toString()}");
    //        });
    //        _audioPlayer.play(UrlSource(_audioUrl));
    //    } catch (e) {
    //        print('Error fail to fetch: $e');
    //    }
    //}
    Future<String?> _getLiveVideoId(String apiKey, String channelId) async {
        try {

            //final url = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyDgqTH_UQhL0Uijj5euCEVnw-P7G-4rDrg&part=snippet&eventType=live&type=video&channelId=UChs0pSaEoNLV4mevBFGaoKA";            final response = await http.get(Uri.parse(url));
            //print("error here ${response.body}");
            //if (response.statusCode == 200) {
            //    final data = json.decode(response.body);
            //    if (data['items'].isNotEmpty) {
            //        return data['items'][0]['id']['videoId'];
            //    } else {
            //        throw Exception('No live video found');
            //    }
            //} else {
            //    throw Exception('Failed to fetch live video');
            //}
            return null;
        } catch (e) {
            print("Error to get live video id");
            return "";
        }
    }
    @override
    void dispose() {
        _audioPlayer.dispose();
        _youtubeExplode.close();
        super.dispose();
    }
    @override
    Widget build(BuildContext context) {
        // to get image url https://img.youtube.com/vi/<VideoId>/0.jpg
        return Column(children:[
            Text(allVideo.length.toString()),
            FloatingActionButton(onPressed: (){
                setState(() {
                    lst.nextPage();
                    lstVideos= lst.toList(growable: true);
                    lstVideosInfo = lstVideos.map((el) => "id:${el.url}, title: ${el.title}").toList();
                    allVideo+=lstVideosInfo;
                });
            },
            child: Text("next"),)
        ],);
        //    ListView.builder(
        //        itemCount: lstVideos.length,
        //        itemBuilder: (context, index){
        //            return Text(lstVideosInfo[index].toString());
        //        }
        //) : const Center(child: CircularProgressIndicator());
    }
}

//--------
//Center(
//              child:Row(
//                  children: <Widget>[
//                      FloatingActionButton(
//                          onPressed: (){
//                              var url = "https://www.youtube.com/watch?v=QWZ_LjzT39k";
//                              HomeState.playVideoAsAudio.playAudio(40, url);
//                          },
//                          child: Text("Play"),
//                      ),
//                      FloatingActionButton(onPressed: (){
//                            HomeState.playVideoAsAudio.pauseAudio();
//                      },
//                          child: Text("Stop")
//                        )
//                  ]
//              )
//          ) ;
//


//-------------------------------------




//
//import 'package:flutter/material.dart';
//import 'package:youtube_explode_dart/youtube_explode_dart.dart';
//import 'package:audioplayers/audioplayers.dart';
////
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Live YouTube Audio Player'),
//        ),
//        body: LiveAudioPlayer(),
//      ),
//    );
//  }
//}
//
//class LiveAudioPlayer extends StatefulWidget {
//  @override
//  _LiveAudioPlayerState createState() => _LiveAudioPlayerState();
//}

//class _LiveAudioPlayerState extends State<LiveAudioPlayer> {
//   @override
//  Widget build(BuildContext context) {
//    return _audioUrl == null
//        ? Center(child: CircularProgressIndicator())
//        : Center(
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Text('Playing live audio stream...'),
//                IconButton(
//                  icon: Icon(Icons.pause),
//                  onPressed: () => _audioPlayer.pause(),
//                ),
//                IconButton(
//                  icon: Icon(Icons.play_arrow),
//                  onPressed: () => _audioPlayer.play(_audioUrl),
//                ),
//              ],
//            ),
//          );
//  }
//}

