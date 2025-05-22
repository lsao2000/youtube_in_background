import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/shared/root_page/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
