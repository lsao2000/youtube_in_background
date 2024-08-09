import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/model/PlayVideAsAudio.dart';
import 'package:youtube_inbackground_newversion/model/VideoContoller.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}
class HomePageState extends State<HomePage> {
    VideoContoller? currentVideoController ;
    @override
    void initState() {
        super.initState();
    }
    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.sizeOf(context).width;
        double height = MediaQuery.sizeOf(context).height;
        return Consumer<PlayVideoAsAudio>(builder: (context, playVideoAsAudio, child){
            if (int.parse(playVideoAsAudio.runtimeTime.toString()) == 0)  {
                return  Center(child: Text("Search Something", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: placeHolderColor),),) ;
            }
            if (playVideoAsAudio.allLstVideos.isEmpty) {
                return Center(
                    child:SizedBox(
                        width: width * 0.15,
                        height: height * 0.08,
                        child: CircularProgressIndicator(
                            color: loading,
                        )
                    )
                );
            }
            return SingleChildScrollView(
                        child: Column(
                            children: <Widget>[
                                SizedBox(
                                    width: width,
                                    height: height * 0.83,
                                    child: ListView.builder(
                                        itemCount:playVideoAsAudio.allLstVideos.length,
                                        itemBuilder: (context, index){
                                            VideoContoller videoContoller =playVideoAsAudio.allLstVideos[index];
                                            return InkWell(
                                                //width: width ,
                                                child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.02),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                            SizedBox(
                                                                child:Stack(
                                                                    alignment: Alignment.bottomRight,
                                                                    children: [
                                                                        ClipRRect(
                                                                            borderRadius: BorderRadius.circular(8),
                                                                            child:Image.network("https://img.youtube.com/vi/${videoContoller.getVideoId}/default.jpg",
                                                                                width: width * 0.485,
                                                                                scale: .1,
                                                                            ),
                                                                        ),
                                                                        Positioned(
                                                                            bottom: 10,
                                                                            //right: -1,
                                                                            //width: 1,
                                                                            right: -width * 0.01,
                                                                            child:
                                                                        ClipRRect(
                                                                                borderRadius: BorderRadius.circular(18),
                                                                                child:  ElevatedButton(
                                                                                    style:ElevatedButton.styleFrom(
                                                                                        backgroundColor:bottomBarColor,
                                                                                        shape:const CircleBorder(),
                                                                                    ),
                                                                                    onPressed: (){
                                                                                        if (currentVideoController == null) {
                                                                                            setState(() {
                                                                                                currentVideoController = videoContoller;
                                                                                                currentVideoController!.setIsPlaying = !currentVideoController!.getIsPlaying;
                                                                                                //videoContoller.setIsPlaying = !videoContoller.getIsPlaying;
                                                                                            });
                                                                                        }else if(currentVideoController!.getIsPlaying){
                                                                                            currentVideoController!.setIsPlaying = false;
                                                                                            currentVideoController = videoContoller;
                                                                                        }
                                                                                        setState(() {
                                                                                            videoContoller.setIsPlaying = !videoContoller.getIsPlaying;
                                                                                        });
                                                                                        print(videoContoller.getIsPlaying);
                                                                                    },
                                                                                    child:videoContoller.getIsPlaying ? Icon(Icons.pause, color: brandColor,)  : Icon(Icons.play_arrow, color: brandColor,),
                                                                                ),
                                                                            ))
                                                                    ],
                                                                )
                                                            ),
                                                            videoInfo(width, height, videoContoller),
                                                        ],
                                                    )
                                                ),
                                            );
                                        }
                                    )
                                ,)
                            ]
                        ),
                    );
                //}
            });
    }
    Widget videoInfo(double width, double height, VideoContoller videoContoller){
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: height * 0.005),
                    width: width * 0.42,
                    child:  Text(videoContoller.getTitleVideo,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),),
                ),
                //Text("channel ${videoContoller.getVideoChannel}"),
                videoContoller.getVideoDuration == 0 ? const Text("") :  Text(videoContoller.getVideoDuration.toString()),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Text("${videoContoller.getVideoWatchers} views")
                    ,)
            ],
        );

    }
}
