import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/utils/audio_services.dart';

class HomeController extends ChangeNotifier {
  final YoutubeExplode youtubeExplode = YoutubeExplode();
  late VideoSearchList lstVideoSearch;
  late AudioServices audioServices;
  HomeController() {
  }
  Future<void> getAudioHandler()async {
  }
}
