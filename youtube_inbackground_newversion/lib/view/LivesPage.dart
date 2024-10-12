import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/provider/playlist_provider.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class LivesPage extends StatefulWidget {
  const LivesPage({super.key});
  @override
  State<LivesPage> createState() => LivesPageState();
}

class LivesPageState extends State<LivesPage> {
  //bool isRed = true;
  final double _minHeight = 80.0;
  final double _maxHeight = 250.0;
  double playlistBarHeight = 80; // Initial height of the widget
  double playlistBarBottomPosition = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
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
                      onTap: () {
                        print("play this playlist $index");
                        Provider.of<PlaylistProvider>(context, listen: false)
                            .updateShowFloating();
                      },
                      child: playlistImage(),
                    ),
                    playlistInfo(),
                  ],
                ),
              );
            }),
        Positioned(
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
                  duration: Duration(milliseconds: 300),
                  height: playlistBarHeight,
                  width: width, // Full width like the YouTube bottom bar
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          height: 80,
                        child:
                            Row(
                          children: [
                            ClipRect(
                              child: Image.network(
                                "https://img.youtube.com/vi/QWZ_LjzT39k/default.jpg",
                                //width: width * 0.5,
                                //scale: .1,
                              ),
                            ),

                          ],
                        ),
                      ),
                      Positioned(
                              height: playlistBarHeight - 100,
                          top: 100,
                          left: 0,
                          right: 0,
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (ctx, index) {
                            return Text("music number ${index + 1}", style: TextStyle(color: brandColor),);
                          },
                        ),
                      ),
                    ],
                  )

                  //Center(
                  //  child: Text(
                  //    'Drag to Resize',
                  //    style: TextStyle(color: Colors.white, fontSize: 18),
                  //  ),
                  //),
                  ),
            ))
        //Positioned(
        //
        //  bottom: 0,
        //  height: height * 0.07,
        //  width: width,
        //  child: Container(
        //    color: Colors.pink,
        //    child:
        //Row(
        //      children: [
        //        ClipRect(
        //          child: Image.network(
        //            "https://img.youtube.com/vi/QWZ_LjzT39k/default.jpg",
        //            //width: width * 0.5,
        //            //scale: .1,
        //          ),
        //        )
        //      ],
        //    ),
        //  ),
        //),
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
            margin: EdgeInsets.only(top: height * 0.02),
            child: Text(
              "Channel Name . Playlist",
              style: TextStyle(
                  color: placeHolderColor,
                  overflow: TextOverflow.fade,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            width: width * 0.4,
            child: InkWell(
              onTap: () {},
              child: Text(
                "show full playlist.",
                style: TextStyle(
                    color: placeHolderColor,
                    overflow: TextOverflow.fade,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void intilizeVariables(var height, var width) {}
}
