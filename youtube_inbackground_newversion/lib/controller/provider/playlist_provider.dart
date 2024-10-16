import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/model/playlist_video.dart';

class PlaylistProvider extends ChangeNotifier {
  bool showFloating = false;
  YoutubeExplode yt = YoutubeExplode();
  List<PlaylistVideo> listPlaylistVideo = [];
  void updateShowFloating() {
    showFloating = !showFloating;
    notifyListeners();
  }

  Future<List<SearchResult>> searchYoutube() async {
    //Playlist lst = await yt.playlists.getVideos("").toList();
    //Playlist s = await yt.playlists.get("music");
    SearchList s = await yt.search.searchContent("ncs music");
    List<SearchResult> playlistsList = [];
    playlistsList.addAll(s.whereType<SearchPlaylist>().toList());
    while (playlistsList.length < 20 && s.nextPage() != null) {
      try {
        SearchList? result = await s.nextPage();
        if (result!.whereType<SearchPlaylist>().toList().isNotEmpty) {
          playlistsList.addAll(result.whereType<SearchPlaylist>().toList());
        }
      } catch (e) {
        print("error");
      }
    }
    List<Map<String, String>> lstInfo = [];
    List<String> lsOne =
        playlistsList.toString().split("SearchResult.playlist");
    lsOne.removeAt(0);
    //print("length ${lsOne.length}");
    for (var i = 0; i < lsOne.length; i++) {
      List<String> lsTwo = lsOne[i].toString().split(",");
      //print(lsTwo.toString());
      String videoCount = "";
      String title = "";
      for (var j = 0; j < lsTwo.length; j++) {
        if (lsTwo[j].contains("videoCount")) {
          videoCount = lsTwo[j];
        } else if (lsTwo[j].contains("title:")) {
          title = lsTwo[j];
        }
      }
      Map<String, String> data = {"title": title, "videoCount": videoCount};
      print(data);
      lstInfo.add(data);
    }

    //var playlists = s.whereType<SearchPlaylist>().toList();

    //print("length : ${playlistsList.length}");
    print(lstInfo);
    return playlistsList;
  }
}
