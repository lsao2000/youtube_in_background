import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/controller/provider/playlist_provider.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class LivesPage extends StatefulWidget {
  const LivesPage({super.key});
  @override
  State<LivesPage> createState() => LivesPageState();
}

class LivesPageState extends State<LivesPage> {
  final double _minHeight = 80.0;
  final double _maxHeight = 250.0;
  double playlistBarHeight = 80; // Initial height of the widget
  double playlistBarBottomPosition = 0;
  dynamic lst = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var playlistProvider = Provider.of<PlaylistProvider>(context);
    return Stack(
      children: [
        // list of playlist
        ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        playlistProvider.updateShowFloating();
                        try {
                            var ls = await playlistProvider.searchYoutube();
                            print(ls.toList());
                          //setState(() async {});
                        } catch (e) {
                            print("error ${e.toString()}");
                        }
                      },
                      child: playlistImage(),
                    ),
                    playlistInfo(),
                  ],
                ),
              );
            }),
        // playlist playing show in bottom
        Builder(builder: (context) {
          return playlistProvider.showFloating
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    //onLongPressStart: (_) {
                    //  // Optionally, you can add some feedback when long press starts
                    //},
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        playlistBarHeight -= details.delta.dy;
                        playlistBarBottomPosition += details.delta.dy;
                        // Clamp the height within min and max bounds
                        if (playlistBarHeight < _minHeight)
                          playlistBarHeight = _minHeight;
                        if (playlistBarHeight > _maxHeight)
                          playlistBarHeight = _maxHeight;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      height: playlistBarHeight,
                      width: width, // Full width like the YouTube bottom bar
                      decoration: BoxDecoration(
                        color: Colors.black87,
                      ),
                      child: Stack(
                        children: [
                          // current playlist playing with title and album name.
                          Positioned(
                            top: 0,
                            height: 80,
                            child: Row(
                              children: [
                                ClipRect(
                                  child: Image.network(
                                    "https://img.youtube.com/vi/QWZ_LjzT39k/default.jpg",
                                    //width: width * 0.5,
                                    //scale: .1,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.05,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Text(
                                        "Name of the song is too long soss we need to wrap it",
                                        maxLines: 1,
                                        style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            color: brandColor),
                                      ),
                                    ),
                                    Text(
                                      "J cole",
                                      style: TextStyle(
                                          color: brandColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          // playlist Item showing with duration and image and video name.
                          Positioned(
                            height: 170,
                            top: 80,
                            left: 0,
                            right: 0,
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (ctx, index) {
                                return Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.04),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: placeHolderColor))),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            "https://img.youtube.com/vi/RksDIZmNiXY/default.jpg",
                                            width: width * 0.15,
                                            //scale: 1,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name of the song or the video $index",
                                                style: TextStyle(
                                                    color: brandColor),
                                              ),
                                              Container(
                                                color: Colors.black,
                                                child: Text(
                                                  "2:28",
                                                  style: TextStyle(
                                                      color: brandColor),
                                                ),
                                              )
                                              //https://www.youtube.com/watch?v=RksDIZmNiXY&t=62s&ab_channel=jsmdamanik
                                            ],
                                          ),
                                        )
                                      ],
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Text("");
        }),
      ],
    );
  }

  Widget playlistImage() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.45,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://img.youtube.com/vi/QWZ_LjzT39k/default.jpg",
                width: width * 0.45,
                scale: .1,
              ),
            ),
          ),
          Positioned(
            bottom: height * 0.01,
            right: width * 0.02,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.005, horizontal: width * 0.01),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4)),
              child: Row(children: [
                Icon(
                  Icons.playlist_play,
                  color: brandColor,
                ),
                Text(
                  "22",
                  style:
                      TextStyle(color: brandColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: width * 0.01,
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget playlistInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width * 0.4,
            child: Text(
              "let assume that this is a big title that we will wrap it and see what we can do",
              maxLines: 2,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Container(
            width: width * 0.4,
            margin: EdgeInsets.only(top: height * 0.005),
            child: Text(
              "Channel Name . Playlist",
              style: TextStyle(
                  color: placeHolderColor,
                  overflow: TextOverflow.fade,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          //Container(
          //  alignment: Alignment.topLeft,
          //  width: width * 0.4,
          //  child: InkWell(
          //    onTap: () {},
          //    child: Text(
          //      "show full playlist.",
          //      style: TextStyle(
          //          color: placeHolderColor,
          //          overflow: TextOverflow.fade,
          //          fontWeight: FontWeight.w800),
          //    ),
          //  ),
          //),
        ],
      ),
    );
  }
}
