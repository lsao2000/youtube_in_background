class VideoModel {
  final String _videoId;
  final String _title;
  final String _views;
  final String _duration;
  final Duration _realDuration;
  final String _channelName;
  final bool _isLive;
  VideoModel(
      {required String videoId,
      required String title,
      required String views,
      required Duration realDuration,
      required String channelName,
      required bool isLive,
      required String duration})
      : _videoId = videoId,
        _title = title,
        _isLive = isLive,
        _channelName = channelName,
        _realDuration = realDuration,
        _views = views,
        _duration = duration;

  String get getVideoId => _videoId;
  String get getTitle => _title;
  String get getViews => _views;
  String get getDuration => _duration;
  Duration get getRealDuration => _realDuration;
  String get getChannelName => _channelName;
  bool get getIsLive => _isLive;
}
