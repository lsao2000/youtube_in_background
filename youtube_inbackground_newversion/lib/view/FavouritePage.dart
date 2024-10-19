import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/localDatabase/search_history_controller.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_favorite_audio.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_video_as_audio.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});
  @override
  FavouritePageState createState() => FavouritePageState();
}

class FavouritePageState extends State<FavouritePage> {
  FavoriteVideoHistory? currentFavoriteVideoHistory;
  late SearchHistoryController searchHistoryController;
  List<FavoriteVideoHistory> allFavoriteHistory = [];
  @override
  void initState() {
    super.initState();
    searchHistoryController = SearchHistoryController();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    //PlayFavoriteAudio playFavoriteAudio = Provider.of<PlayFavoriteAudio>(context);
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
                  vidoeImageInfo(
                      width, height, favoriteHistory, playVideoAsAudio),
                  videoInfo(width, height, favoriteHistory)
                ],
              ));
        });
  }

  Widget videoInfo(
      double width, double height, FavoriteVideoHistory favoriteHistory) {
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

  Widget vidoeImageInfo(double width, double height,
      FavoriteVideoHistory favoriteHistory, PlayVideoAsAudio playVideoAsAudio) {
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
                playVideoAsAudio.playFavoriteAudio(favoriteHistory);
                // posibilities of pause and play button in videoContoller.
                // You play audio for the first time.
                if (currentFavoriteVideoHistory == null) {
                  setState(() {
                    currentFavoriteVideoHistory = favoriteHistory;
                    currentFavoriteVideoHistory!.isPlaying =
                        !currentFavoriteVideoHistory!.isPlaying;
                  });
                }
                //// You play another audio after first time.
                else if (currentFavoriteVideoHistory != favoriteHistory) {
                  setState(() {
                    currentFavoriteVideoHistory!.isPlaying = false;
                    favoriteHistory.isPlaying = !favoriteHistory.isPlaying;
                    currentFavoriteVideoHistory = favoriteHistory;
                  });
                }
                // You play and pause the same audio.
                else {
                  setState(() {
                    currentFavoriteVideoHistory!.isPlaying =
                        !currentFavoriteVideoHistory!.isPlaying;
                  });
                }
                playVideoAsAudio.playFavoriteAudio(currentFavoriteVideoHistory!);
                if (currentFavoriteVideoHistory?.getCurrentDurationPositionInSecond == 0) {
                  //print("listen");
                  playVideoAsAudio.myAudioHandler.getPlayer.playingStream
                      .listen((state) {
                    currentFavoriteVideoHistory!.isPlaying = state;
                  });
                  currentFavoriteVideoHistory?.updateCurrentDurationPosition = 1;
                } else {
                  print("already listning");
                }

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
          //    return favoriteHistory.isLive ? const Text("") :
          //            const Text("not live");
          //            //audioSliderBar(height, width, playVideoAsAudio, favoriteHistory);
          //  },
          //),
          Positioned(
            top: height * 0.01,
            right: width * 0.02,
            child: InkWell(
              onTap: () {
                String videoId = favoriteHistory.videoId;
                searchHistoryController.deleteFavoriteHistory(videoId: videoId);
                setState(() {
                  refreshData();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.deepOrange),
                child: Icon(
                  Icons.remove,
                  color: brandColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget audioSliderBar(
      double height,
      double width,
      PlayVideoAsAudio playVideoAsAudio,
      FavoriteVideoHistory favoriteVideoHistory) {
    return Builder(
      builder: (ctx) {
        return favoriteVideoHistory.isPlaying
            ? Positioned(
                bottom: height * 0.007,
                child: SizedBox(
                  width: width * 0.47,
                  child: StreamBuilder<Duration>(
                    stream: playVideoAsAudio
                        .myAudioHandler.getPlayer.positionStream,
                    builder: (context, snapshot) {
                      var position = snapshot.data?.inSeconds.toDouble() ==
                              favoriteVideoHistory.realDuration.inSeconds
                                  .toDouble()
                          ? Duration.zero
                          : snapshot.data ?? Duration.zero;
                      favoriteVideoHistory.updateProgressValue =
                          position.inSeconds.toDouble();
                      return SliderTheme(
                          data: SliderThemeData(
                              overlayShape: SliderComponentShape.noOverlay),
                          child: favoriteVideoHistory.isPlaying
                              ? Slider(
                                  label:
                                      "${favoriteVideoHistory.progressValue}",
                                  divisions: (favoriteVideoHistory
                                          .realDuration.inSeconds ~/
                                      5),
                                  thumbColor: bottomBarColor,
                                  activeColor: bottomBarColor,
                                  min: 0.0,
                                  max: favoriteVideoHistory.isLive
                                      ? 2000
                                      : favoriteVideoHistory
                                          .realDuration.inSeconds
                                          .toDouble(),
                                  value: playVideoAsAudio.myAudioHandler
                                      .getPlayer.position.inSeconds
                                      .toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      favoriteVideoHistory.updateProgressValue =
                                          value;
                                      playVideoAsAudio.myAudioHandler.getPlayer
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                    });
                                  })
                              : Slider(
                                  label:
                                      "${favoriteVideoHistory.progressValue}",
                                  divisions: (favoriteVideoHistory
                                          .realDuration.inSeconds ~/
                                      5),
                                  thumbColor: bottomBarColor,
                                  activeColor: bottomBarColor,
                                  min: 0,
                                  max: favoriteVideoHistory
                                      .realDuration.inSeconds
                                      .toDouble(),
                                  value: 0,
                                  onChanged: (value) {}));
                    },
                  ),
                ),
              )
            : const Text("");
      },
    );
  }

  Future<void> refreshData() async {
    var data = await searchHistoryController.getAllFavorite();
    setState(() {
      allFavoriteHistory = data;
    });
  }
}
