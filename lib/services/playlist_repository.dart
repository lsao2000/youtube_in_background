abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherSong();
}

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length = 3}) async {
    return List.generate(length, (index) => _nextSong());
  }

  @override
  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = 0;
  static const _maxSongNumber = 16;

  Map<String, String> _nextSong() {
    _songIndex = (_songIndex % _maxSongNumber) + 1;
    return {
      'id': _songIndex.toString().padLeft(3, '0'),
      'image':'@mipmap/ic_launcher',
      'title': 'Song $_songIndex',
      'album': 'Lahcen test',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
      //'Uri':'https://img.youtube.com/vi/XRDfETqZvJM/0.jpg'
    };
  }
}
