
import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayVideoAsAudio {
    late String searchWord;
    YoutubeExplode yt = YoutubeExplode();
    AudioPlayer audioPlayer = AudioPlayer();
    PlayVideoAsAudio({required this.searchWord});

    Future<void> searchYoutube() async {
        VideoSearchList lstSearch = await yt.search.search(searchWord);
        List<Video> lstVideos = lstSearch.toList(growable: true);

    }

}
