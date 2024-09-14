import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_in_background/services/service_locator.dart';
import 'notifiers/play_button_notifier.dart';
import 'notifiers/progress_notifier.dart';
import 'notifiers/repeat_button_notifier.dart';
import 'services/playlist_repository.dart';

class PageManager {
    // Listeners: Updates going to the UI
    final currentSongTitleNotifier = ValueNotifier<String>('');
    final playlistNotifier = ValueNotifier<List<String>>([]);
    final progressNotifier = ProgressNotifier();
    final repeatButtonNotifier = RepeatButtonNotifier();
    final isFirstSongNotifier = ValueNotifier<bool>(true);
    final playButtonNotifier = PlayButtonNotifier();
    final isLastSongNotifier = ValueNotifier<bool>(true);
    final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
    final _audioHandler = getIt<AudioHandler>();
    // Events: Calls coming from the UI
    void init() async {
        await _loadPlaylist();
        _listenToChangesInPlaylist();
        _listenToPlaybackState();
        _listenToCurrentPosition();
        _listenToBufferedPosition();
        _listenToTotalDuration();
    }
    Future<void> _loadPlaylist() async {
        final songRepository = getIt<PlaylistRepository>();
        final playlist = await songRepository.fetchInitialPlaylist();
        final mediaItems = playlist
                .map((song) => MediaItem(
                        id: song['id'] ?? '',
                        album: song['album'] ?? '',
                        title: song['title'] ?? '',
                        extras: {'url': song['url']},
                        artUri:Uri.parse('https://img.youtube.com/vi/XRDfETqZvJM/default.jpg')
                        //https://img.youtube.com/vi/XRDfETqZvJM/0.jpg
                ))
                .toList();
        _audioHandler.addQueueItems(mediaItems);
    }
    void _listenToChangesInPlaylist() {
        _audioHandler.queue.listen((playlist) {
            if (playlist.isEmpty) return;
            final newList = playlist.map((item) => item.title).toList();
            playlistNotifier.value = newList;
        });
    }
    void _listenToPlaybackState() {
        _audioHandler.playbackState.listen((playbackState) {
            final isPlaying = playbackState.playing;
            final processingState = playbackState.processingState;
            if (processingState == AudioProcessingState.loading ||
                processingState == AudioProcessingState.buffering) {
                playButtonNotifier.value = ButtonState.loading;
            } else if (!isPlaying) {
                playButtonNotifier.value = ButtonState.paused;
            } else if (processingState != AudioProcessingState.completed) {
                playButtonNotifier.value = ButtonState.playing;
            } else {
                _audioHandler.seek(Duration.zero);
                _audioHandler.pause();
            }
        });
    }
    void _listenToCurrentPosition() {
        AudioService.position.listen((position) {
            final oldState = progressNotifier.value;
            progressNotifier.value = ProgressBarState(
                current: position,
                buffered: oldState.buffered,
                total: oldState.total,
            );
        });
    }
    void _listenToBufferedPosition() {
        _audioHandler.playbackState.listen((playbackState) {
            final oldState = progressNotifier.value;
            progressNotifier.value = ProgressBarState(
                current: oldState.current,
                buffered: playbackState.bufferedPosition,
                total: oldState.total,
            );
        });
    }
    void _listenToTotalDuration() {
        _audioHandler.mediaItem.listen((mediaItem) {
            final oldState = progressNotifier.value;
            progressNotifier.value = ProgressBarState(
                current: oldState.current,
                buffered: oldState.buffered,
                total: mediaItem?.duration ?? Duration.zero,
            );
        });
    }
    void seek(Duration position) => _audioHandler.seek(position);
    void play() => _audioHandler.play();
    void pause() => _audioHandler.pause();
    void previous() {}
    void next() {}
    void repeat() {}
    void shuffle() {}
    void add() {}
    void remove() {}
    void dispose() {}
}
