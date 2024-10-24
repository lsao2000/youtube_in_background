import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config:  const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,

    ),
  );
}

class MyAudioHandler extends BaseAudioHandler {
    final _player = AudioPlayer();
    final _playlist = ConcatenatingAudioSource(children: []);
    MyAudioHandler() {
        _loadEmptyPlaylist();
        _notifyAudioHandlerAboutPlaybackEvents();
        _listenForDurationChanges();
    }

    Future<void> _loadEmptyPlaylist() async {
        try {
            await _player.setAudioSource(_playlist);
        } catch (e) {
            print("Error: $e");
        }
    }
    @override
    Future<void> addQueueItems(List<MediaItem> mediaItems) async {
        // manage Just Audio
        final audioSource = mediaItems.map(_createAudioSource);
        _playlist.addAll(audioSource.toList());
        // notify system
        final newQueue = queue.value..addAll(mediaItems);
        queue.add(newQueue);
    }

    UriAudioSource _createAudioSource(MediaItem mediaItem) {
        return AudioSource.uri(
            Uri.parse(mediaItem.extras!['url'] as String),
            tag: mediaItem,
        );
    }
    Future<void> setUrl(String url) => _player.setUrl(url);
    @override
    Future<void> pause() => _player.pause();
    @override
    Future<void> play() => _player.play();
    void _notifyAudioHandlerAboutPlaybackEvents() {
        _player.playbackEventStream.listen((PlaybackEvent event) {
            final playing = _player.playing;
            playbackState.add(playbackState.value.copyWith(
                    controls: [
                        MediaControl.skipToPrevious,
                        if (playing) MediaControl.pause else MediaControl.play,
                        MediaControl.stop,
                        MediaControl.skipToNext,
                    ],
                    systemActions: const {
                        MediaAction.seek,
                    },
                    androidCompactActionIndices: const [0, 1, 3],
                    processingState: const {
                        ProcessingState.idle: AudioProcessingState.idle,
                        ProcessingState.loading: AudioProcessingState.loading,
                        ProcessingState.buffering: AudioProcessingState.buffering,
                        ProcessingState.ready: AudioProcessingState.ready,
                        ProcessingState.completed: AudioProcessingState.completed,
                    }[_player.processingState]!,
                    playing: playing,
                    updatePosition: _player.position,
                    bufferedPosition: _player.bufferedPosition,
                    speed: _player.speed,
                    queueIndex: event.currentIndex,
                    ));
        });
    }
    @override
    Future<void> seek(Duration position) => _player.seek(position);
    void _listenForDurationChanges() {
        _player.durationStream.listen((duration) {
            final index = _player.currentIndex;
            final newQueue = queue.value;
            if (index == null || newQueue.isEmpty) return;
            final oldMediaItem = newQueue[index];
            final newMediaItem = oldMediaItem.copyWith(duration: duration);
            newQueue[index] = newMediaItem;
            queue.add(newQueue);
            mediaItem.add(newMediaItem);
        });
    }
}
