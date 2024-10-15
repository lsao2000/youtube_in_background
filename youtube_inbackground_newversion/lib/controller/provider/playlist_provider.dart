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
        playlistsList.addAll(result!.whereType<SearchPlaylist>().toList());
      } catch (e) {
        print("error");
      }
    }
    List<Map<String, String>> lstInfo = [];
    List<String> lsOne =
        playlistsList.toString().split("SearchResult.playlist");
    for (var i = 0; i < lsOne.length; i++) {
      List<String> lsTwo = lsOne[i].toString().split(",");
      String videoCount = "";
      String title = "";
      for (var i = 0; i < lsTwo.length; i++) {
        if (lsTwo[i].contains("videoCount")) {
          videoCount = lsTwo[i];
        } else if (lsTwo[i].contains("title:")) {
          title = lsTwo[i];
        }
      }
      lstInfo.add({"title": title, "videoCount": videoCount});
    }

    //var playlists = s.whereType<SearchPlaylist>().toList();

    print("length : ${playlistsList.length}");
    print(lstInfo);
    return playlistsList;
  }
}
