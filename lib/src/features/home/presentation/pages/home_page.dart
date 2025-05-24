import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.lstVideos.isEmpty) {
        return Center(
          child: Text(
            "Search Something",
            style: TextStyle(
                fontSize: Get.width * 0.05,
                fontWeight: FontWeight.bold,
                color: grey.withAlpha(120)),
          ),
        );
      }
      return const Center(
        child: Text("somethingElse"),
      );
    });
  }
}
