import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/localDatabase/search_history_controller.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_video_as_audio.dart';
import 'package:youtube_inbackground_newversion/model/VideoContoller.dart';
import 'package:youtube_inbackground_newversion/model/favorite_video_history.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  VideoContoller? currentVideoController;
  final ScrollController _scrollController = ScrollController();
  late SearchHistoryController searchHistoryController;
  @override
  void initState() {
    super.initState();
    try {
      searchHistoryController = SearchHistoryController();
    } catch (e) {
        log(e.toString());
        //print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    PlayVideoAsAudio playVideoAsAudio = Provider.of<PlayVideoAsAudio>(context);
    if (int.parse(playVideoAsAudio.runtimeTime.toString()) == 0) {
      return Center(
        child: Text(
          "Search Something",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: placeHolderColor),
        ),
      );
    }
    if (playVideoAsAudio.allLstVideos.isEmpty) {
      return Center(
        child: SizedBox(
          width: width * 0.15,
          height: height * 0.08,
          child: CircularProgressIndicator(
            color: loading,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(
          width: width,
          height: height * 0.83,
          child: ListView.builder(
              controller: _scrollController,
              itemCount: playVideoAsAudio.allLstVideos.length,
              itemBuilder: (context, index) {
                VideoContoller videoContoller =
                    playVideoAsAudio.allLstVideos[index];
                _scrollController.addListener(() {
                  addMore(playVideoAsAudio);
                });
                playVideoAsAudio.myAudioHandler.getPlayer.playerStateStream
                    .listen((state) {
                  if (state.processingState == ProcessingState.completed) {
                    setState(() {
                      videoContoller.updateProgressValue = 0;
                    });
                    playVideoAsAudio.myAudioHandler.getPlayer
                        .seek(Duration.zero);
                    playVideoAsAudio.myAudioHandler.getPlayer.pause();
                    videoContoller.setIsPlaying = false;
                  }
                });
                return InkWell(
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          videoImage(
                              width, height, videoContoller, playVideoAsAudio),
                          videoInfo(
                              width, height, videoContoller, playVideoAsAudio),
                        ],
                      )),
                );
              }),
        )
      ]),
    );
    //}
    //);
  }

  Widget videoImage(double width, double height, VideoContoller videoContoller,
      PlayVideoAsAudio playVideoAsAudio) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://img.youtube.com/vi/${videoContoller.getVideoId}/default.jpg",
              width: width * 0.485,
              scale: .1,
            ),
          ),
          Builder(
            builder: (ctx) {
              return videoContoller.getIsLive
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
                          videoContoller.getVideoDuration,
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
                // posibilities of pause and play button in videoContoller.
                // You play audio for the first time.
                if (currentVideoController == null) {
                  setState(() {
                    currentVideoController = videoContoller;
                    currentVideoController!.setIsPlaying =
                        !currentVideoController!.getIsPlaying;
                  });
                }
                //// You play another audio after first time.
                else if (currentVideoController != videoContoller) {
                  setState(() {
                    currentVideoController!.setIsPlaying = false;
                    videoContoller.setIsPlaying = !videoContoller.getIsPlaying;
                    currentVideoController = videoContoller;
                  });
                }
                // You play and pause the same audio.
                else {
                  setState(() {
                    currentVideoController!.setIsPlaying =
                        !currentVideoController!.getIsPlaying;
                  });
                }
                playVideoAsAudio.playAudio(currentVideoController!);
                if (currentVideoController
                        ?.getCurrentDurationPositionInSecond ==
                    0) {
                  print("listen");
                  playVideoAsAudio.myAudioHandler.getPlayer.playingStream
                      .listen((state) {
                    currentVideoController!.setIsPlaying = state;
                  });
                  currentVideoController?.updateCurrentDurationPosition = 1;
                } else {
                  print("already listning");
                }
              },
              child: videoContoller.getIsPlaying
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
          Builder(
            builder: (ctx) {
              return videoContoller.getIsLive
                  ? const Text("")
                  : audioSliderBar(
                      height, width, playVideoAsAudio, videoContoller);
            },
          ),
          favoriteButton(height, width, videoContoller),
        ],
      ),
    );
  }

  Widget favoriteButton(
      double height, double width, VideoContoller videoContoller) {
    return Positioned(
      top: height * 0.01,
      right: width * 0.02,
      child: InkWell(
        onTap: () async {
          FavoriteVideoHistory favoriteVideoHistory = FavoriteVideoHistory(
              titleVideo: videoContoller.getTitleVideo,
              videoId: videoContoller.getVideoId,
              videoWatchers: videoContoller.getVideoWatchers,
              imgUrl:
                  "https://img.youtube.com/vi/${videoContoller.getVideoId}/default.jpg",
              isLive: videoContoller.getIsLive,
              videoDuration: videoContoller.getVideoDuration,
              videoChannel: videoContoller.getVideoChannel,
              realDuration: videoContoller.getRealDuration);
          searchHistoryController.addToFavorite(favoriteVideoHistory);
        },
        child: Icon(
          Icons.favorite,
          color: brandColor,
        ),
      ),
    );
  }

  Widget audioSliderBar(double height, double width,
      PlayVideoAsAudio playVideoAsAudio, VideoContoller videoContoller) {
    return Builder(
      builder: (ctx) {
        return videoContoller.getIsPlaying
            ? Positioned(
                bottom: height * 0.007,
                child: SizedBox(
                  width: width * 0.47,
                  child: StreamBuilder<Duration>(
                    stream: playVideoAsAudio
                        .myAudioHandler.getPlayer.positionStream,
                    builder: (context, snapshot) {
                      var position = snapshot.data?.inSeconds.toDouble() ==
                              videoContoller.getRealDuration.inSeconds
                                  .toDouble()
                          ? Duration.zero
                          : snapshot.data ?? Duration.zero;
                      videoContoller.updateProgressValue =
                          position.inSeconds.toDouble();
                      return SliderTheme(
                          data: SliderThemeData(
                              overlayShape: SliderComponentShape.noOverlay),
                          child: videoContoller.getIsPlaying
                              ? Slider(
                                  label: "${videoContoller.getProgrssValue}",
                                  divisions: (videoContoller
                                          .getRealDuration.inSeconds ~/
                                      5),
                                  thumbColor: bottomBarColor,
                                  activeColor: bottomBarColor,
                                  min: 0.0,
                                  max: videoContoller.getIsLive
                                      ? 2000
                                      : videoContoller.getRealDuration.inSeconds
                                          .toDouble(),
                                  value: playVideoAsAudio.myAudioHandler
                                      .getPlayer.position.inSeconds
                                      .toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      videoContoller.updateProgressValue =
                                          value;
                                      playVideoAsAudio.myAudioHandler.getPlayer
                                          .seek(
                                              Duration(seconds: value.toInt()));
                                      //playVideoAsAudio.audioPlayer.seek(Duration(seconds: value.toInt()));
                                    });
                                  })
                              : Slider(
                                  label: "${videoContoller.getProgrssValue}",
                                  divisions:
                                      (videoContoller.getRealDuration.inSeconds ~/
                                          5),
                                  thumbColor: bottomBarColor,
                                  activeColor: bottomBarColor,
                                  min: 0,
                                  max: videoContoller.getRealDuration.inSeconds
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

  Widget videoInfo(double width, double height, VideoContoller videoContoller,
      PlayVideoAsAudio playVideoAsAudio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.005),
          width: width * 0.42,
          child: Text(
            videoContoller.getTitleVideo,
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
            "${videoContoller.getVideoWatchers} views",
            style: TextStyle(
              fontSize: width * 0.03,
            ),
          ),
        ),
        !videoContoller.getIsLive
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

  void addMore(PlayVideoAsAudio playVideoAsAudio) {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("you reach the end of the scroll");
      playVideoAsAudio.addMoreVideo();
    }
  }
}
