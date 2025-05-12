import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeController extends GetxController {
  final YoutubeExplode yt = YoutubeExplode();
  late VideoSearchList lstSearch;

  // late
  @override
    void onInit() {
      super.onInit();
    }
}
