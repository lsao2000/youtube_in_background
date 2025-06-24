import 'dart:async';
// import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class MainController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  RxString currentTab = "/home".obs;
  StreamSubscription? streamSubscription;
  String? sharedUrl;

  @override
  void onInit() {
    super.onInit();
    _initSharingIntent();
  }

  void _initSharingIntent() {
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // sharedUrl = value.first.path;
        // debugPrint("Shared URL: ${value.first.path}");
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text("Shared URL: ${value.first.path}"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        // sharedUrl = value.first.path;
        // debugPrint("Shred URL: ${value.first.path}");
        currentTabIndex.value = 2; // Switch to favorite tab
        currentTab.value = "/downloads"; // Navigate to downloads page
        update();
      }
    }, onError: (err) {
      debugPrint("Error receiving shared media: $err");
    });
  }

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
      case 2:
        currentTab.value = "/downloads";
        update();
        break;
    }
  }
}
