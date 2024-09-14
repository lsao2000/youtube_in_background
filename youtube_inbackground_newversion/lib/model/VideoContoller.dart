class VideoContoller {
    late final String _videoId;
    late final String _titleVideo;
    late final String  _videoWatches;
    late final String _videoDuration;
    late final Duration _realDuration;
    late final String _videoChannel;
    late final  bool _isLive ;
    int _currentDurationPositionInSecond = 0;
    late double _progressValue;
    bool _isPlaying = false;
    VideoContoller({required String videoId, required String titleVideo , required String videoWatchers , required String videoDuration, required String videoChannel, required bool isLive, required Duration realDuration})
            :_videoId = videoId, _titleVideo = titleVideo, _videoChannel = videoChannel, _videoDuration = videoDuration, _videoWatches = videoWatchers, _isLive = isLive, _realDuration = realDuration;
    String get getVideoId => _videoId;
    String get getTitleVideo => _titleVideo;
    String get getVideoWatchers => _videoWatches;
    String get getVideoDuration => _videoDuration;
    String get getVideoChannel => _videoChannel;
    bool get getIsPlaying => _isPlaying;
    bool get getIsLive => _isLive;
    int get getCurrentDurationPositionInSecond => _currentDurationPositionInSecond;
    Duration get getRealDuration => _realDuration;
    double get getProgrssValue => _progressValue;
    set setIsPlaying (bool value) {
        _isPlaying = value;
    }
    set updateProgressValue (double value) {
        _progressValue = value;
    }
    set updateCurrentDurationPosition(int positionInSecond){
        _currentDurationPositionInSecond = positionInSecond;
    }
    @override
      bool operator ==(Object other) => identical(this, other) ||
      (other is VideoContoller &&
          runtimeType == other.runtimeType && other._videoId == _videoId );
    @override
    int get hashCode => _videoId.hashCode;
}
