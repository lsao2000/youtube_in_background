class FavoriteVideoHistory {
  late String videoId;
  late String titleVideo;
  late String videoWatchers;
  late String videoDuration;
  late Duration realDuration;
  late String videoChannel;
  late bool isLive;
  late double progressValue;
  late String imgUrl;
  int _currentDurationPositionInSecond = 0;
  bool isPlaying = false;
  FavoriteVideoHistory({
    required this.titleVideo,
    required this.videoId,
    required this.videoWatchers,
    required this.imgUrl,
    required this.isLive,
    required this.videoDuration,
    required this.videoChannel,
    required this.realDuration,
  });
  set updateIsPlaying(bool value) {
    isPlaying = value;
  }

  int get getCurrentDurationPositionInSecond => _currentDurationPositionInSecond;

  set updateCurrentDurationPosition(int positionInSecond) {
    _currentDurationPositionInSecond = positionInSecond;
  }

  set updateProgressValue(double value) {
    progressValue = value;
  }

  Map<String, dynamic> toJson() {
    return {
      "videoId": videoId,
      "titleVideo": titleVideo,
      "videoWatchers": videoWatchers,
      "imgUrl": imgUrl,
      "isLive": isLive ? 1 : 0,
      "videoDuration": videoDuration,
      "videoChannel": videoChannel,
      "realDuration": realDuration.inSeconds,
    };
  }

  static FavoriteVideoHistory fromJson(Map<String, dynamic> data) {
    return FavoriteVideoHistory(
        titleVideo: data["titleVideo"],
        videoId: data["videoId"],
        videoWatchers: data["videoWatchers"],
        imgUrl: data["imgUrl"],
        isLive: data["isLive"] == 1 ? true : false,
        videoDuration: data["videoDuration"],
        videoChannel: data["videoChannel"],
        realDuration: Duration(seconds: data["realDuration"]));
  }
}
