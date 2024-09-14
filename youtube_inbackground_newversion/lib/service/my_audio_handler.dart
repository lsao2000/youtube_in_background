import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler{
    final AudioPlayer _player = AudioPlayer();
    MyAudioHandler(){
        _notifyAudioHandlerAboutPlaybackEvent();
        _listenForDurationChanges();
    }
    void _notifyAudioHandlerAboutPlaybackEvent(){
        _player.playbackEventStream.listen((event) {
            final playingAudio = _player.playing;
            playbackState.add(playbackState.value.copyWith(
                    controls: [
                        MediaControl.skipToPrevious,
                        playingAudio ? MediaControl.pause : MediaControl.play,
                        MediaControl.skipToNext
                    ],
                    systemActions: const {
                        MediaAction.seek,
                    },
                    playing: playingAudio,
                    updatePosition: _player.position,
                    bufferedPosition: _player.bufferedPosition,
                    speed: _player.speed,
                    queueIndex: event.currentIndex,
                    processingState: {
                        ProcessingState.idle: AudioProcessingState.idle,
                        ProcessingState.loading : AudioProcessingState.loading,
                        ProcessingState.ready : AudioProcessingState.ready,
                        ProcessingState.buffering : AudioProcessingState.buffering,
                        ProcessingState.completed : AudioProcessingState.completed
                    }[_player.processingState]!,
            )
            );
        });
    }
    AudioPlayer get getPlayer => _player;
    // This code for playing audio with the given url.
    Future<void> setUrl(String url) => _player.setUrl(url);
    @override
    Future<void> play() => _player.play();
    @override
    Future<void> stop() => _player.stop();
    @override
    Future<void> pause() => _player.pause();
    @override
    Future<void> seek(Duration position) => _player.seek(position);
    @override
    Future<void> addQueueItems(List<MediaItem> mediaItems) async {
        //final audioSource = mediaItems.map((mediaItem) => AudioSource.uri(Uri.parse(mediaItem.extras!['url'] as String), tag: mediaItem));
        final newQueue = queue.value..addAll(mediaItems);
        queue.add(newQueue);
    }
    void _listenForDurationChanges() {
        _player.durationStream.listen((duration) {
            final index = _player.currentIndex;
            final newQueue = queue.value;
            if(index == null || newQueue.isEmpty) return ;
            final oldMediaItem = newQueue[index];
            final newMediaItem = oldMediaItem.copyWith(duration: duration);
           newQueue[index] = newMediaItem;
           queue.add(newQueue);
           mediaItem.add(newMediaItem);
        });
    }
}
