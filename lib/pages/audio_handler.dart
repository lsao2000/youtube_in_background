import 'package:audio_service/audio_service.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}
class MyAudioHandler extends BaseAudioHandler {

    @override
      Future<void> play() {
        // TODO: implement play
        return super.play();
      }
    @override
      Future<void> stop() {
        // TODO: implement stop
        return super.stop();
      }
    @override
      Future<void> pause() {
        // TODO: implement pause
        return super.pause();
      }
}
