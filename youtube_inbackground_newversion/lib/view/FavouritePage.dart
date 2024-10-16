import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/localDatabase/search_history_controller.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_video_as_audio.dart';
import 'package:youtube_inbackground_newversion/model/VideoContoller.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});
  @override
  FavouritePageState createState() => FavouritePageState();
}

class FavouritePageState extends State<FavouritePage> {
  late SearchHistoryController searchHistoryController;
  List<FavoriteVideoHistory> allFavoriteHistory = [];
  @override
  void initState() {
    super.initState();
    searchHistoryController = SearchHistoryController();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    PlayVideoAsAudio playVideoAsAudio = Provider.of<PlayVideoAsAudio>(context);
    return ListView.builder(
        itemCount: allFavoriteHistory.length,
        itemBuilder: (ctx, index) {
          FavoriteVideoHistory favoriteHistory = allFavoriteHistory[index];
          return Container(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.01, horizontal: width * 0.02),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    vidoeImageInfo(width, height, favoriteHistory),
                    videoInfo(width, height, favoriteHistory)
                ],
              ));
        });
  }
  Widget videoInfo(double width, double height,FavoriteVideoHistory favoriteHistory ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.005),
          width: width * 0.42,
          child: Text(
            favoriteHistory.titleVideo,
            maxLines: 3,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.005),
          child: Text(
            "${favoriteHistory.videoWatchers} views",
            style: TextStyle(
              fontSize: width * 0.03,
            ),
          ),
        ),
        !favoriteHistory.isLive
            ? const Text("")
            : Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.005, vertical: height * 0.01),
                    child: Icon(Icons.circle,
                        color: Colors.red, size: width * 0.05),
                  ),
                  const Text("Live",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
      ],
    );
  }

  Widget vidoeImageInfo(
      double width, double height, FavoriteVideoHistory favoriteHistory) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://img.youtube.com/vi/${favoriteHistory.videoId}/default.jpg",
              width: width * 0.485,
              scale: .1,
            ),
          ),
          Builder(
            builder: (ctx) {
              return favoriteHistory.isLive
                  ? const Text("")
                  :
                  // Below is the duration of the music.
                  Positioned(
                      left: width * 0.02,
                      bottom: height * 0.024,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4)),
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: width * 0.02),
                        child: Text(
                          favoriteHistory.videoDuration,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
            },
          ),
          // Below the widget for button that will play the audio and pause the audio.
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: bottomBarColor,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                print("pressed");
                // posibilities of pause and play button in favoriteHistory.
                // You play audio for the first time.
                //if (currentVideoController == null) {
                //  setState(() {
                //    currentVideoController = favoriteHistory;
                //    currentVideoController!.setIsPlaying =
                //        !currentVideoController!.getIsPlaying;
                //  });
                //}
                //// You play another audio after first time.
                //else if (currentVideoController != favoriteHistory) {
                //  setState(() {
                //    currentVideoController!.setIsPlaying = false;
                //    favoriteHistory.setIsPlaying = !videoContoller.getIsPlaying;
                //    currentVideoController = favoriteHistory;
                //  });
                //}
                // You play and pause the same audio.
                //else {
                //  setState(() {
                //    currentVideoController!.setIsPlaying =
                //        !currentVideoController!.getIsPlaying;
                //  });
                //}
                //playVideoAsAudio.playAudio(currentVideoController!);
                //if (currentVideoController
                //        ?.getCurrentDurationPositionInSecond ==
                //    0) {
                //  print("listen");
                //  playVideoAsAudio.myAudioHandler.getPlayer.playingStream
                //      .listen((state) {
                //    currentVideoController!.setIsPlaying = state;
                //  });
                //  currentVideoController?.updateCurrentDurationPosition = 1;
                //} else {
                //  print("already listning");
                //}
              },
              child: favoriteHistory.isPlaying
                  ? Icon(
                      Icons.pause,
                      color: brandColor,
                    )
                  : Icon(
                      Icons.play_arrow,
                      color: brandColor,
                    ),
            ),
          ),
          //Builder(
          //  builder: (ctx) {
          //    return favoriteHistory.getIsLive
          //        ? const Text("")
          //        : audioSliderBar(
          //            height, width, playVideoAsAudio, favoriteHistory);
          //  },
          //),
        ],
      ),
    );
  }

  Future<void> getData() async {
    var data = await searchHistoryController.getAllFavorite();
    setState(() {
      allFavoriteHistory = data;
    });
  }
}
