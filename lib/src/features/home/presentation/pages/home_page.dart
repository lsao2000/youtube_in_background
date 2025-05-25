import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/video_image.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/video_info.dart';

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
      return ListView.builder(
          itemCount: controller.lstVideos.length,
          itemBuilder: (ctx, index) {
            HomeModel homeModel = controller.lstVideos[index];
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.02, vertical: Get.height * 0.01),
              child: Row(
                spacing: Get.width * 0.02,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  videoImage(Get.width, Get.height, homeModel),
                  videoInfo(
                      width: Get.width,
                      height: Get.height,
                      homeModel: homeModel)
                ],
              ),
            );
          });
    });
  }
}
