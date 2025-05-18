import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/utils/audio_services.dart';
import 'package:youtube_inbackground_newversion/view/home/home_controller.dart';

class HomeServices {
  Future<AudioServices?> initiliazeAudioHandler() async {
    try {
      return await AudioService.init(
          builder: () => AudioServices(),
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.mycompany.myapp.audio',
            androidNotificationChannelName: 'Audio Service Demo',
            androidNotificationOngoing: true,
            androidStopForegroundOnPause: true,
          ));
    } catch (e) {
      debugPrint("Error in initializing audio service: ${e.toString()}");
      return null;
    }
  }
}
