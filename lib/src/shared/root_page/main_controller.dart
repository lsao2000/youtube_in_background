import 'package:get/get.dart';

class MainController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  RxString currentTab = "/home".obs;
  void changeTab(int index) {
    currentTabIndex.value = index;
    update();
    switch (currentTabIndex.value) {
      case 0:
        currentTab.value = "/home";
        update();
        break;
      case 1:
        currentTab.value = "/favorite";
        update();
        break;
    }
  }
}
