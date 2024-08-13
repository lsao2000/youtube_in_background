class VideoContoller {
    late final String _videoId;
    late final String _titleVideo;
    late final String  _videoWatches;
    late final String _videoDuration;
    late final String _videoChannel;
    late final  bool _isLive ;
    bool _isPlaying = false;
    VideoContoller({required String videoId, required String titleVideo , required String videoWatchers , required String videoDuration, required String videoChannel, required bool isLive})
            :_videoId = videoId, _titleVideo = titleVideo, _videoChannel = videoChannel, _videoDuration = videoDuration, _videoWatches = videoWatchers, _isLive = isLive;
    String get getVideoId => _videoId;
    String get getTitleVideo => _titleVideo;
    String get getVideoWatchers => _videoWatches;
    String get getVideoDuration => _videoDuration;
    String get getVideoChannel => _videoChannel;
    bool get getIsPlaying => _isPlaying;
    bool get getIsLive => _isLive;
    set setIsPlaying (bool value) {
        _isPlaying = value;
    }
    @override
      bool operator ==(Object other) => identical(this, other) ||
      (other is VideoContoller &&
          runtimeType == other.runtimeType && other._videoId == _videoId );
    @override
    int get hashCode => _videoId.hashCode;
}
