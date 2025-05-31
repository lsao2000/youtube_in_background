import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/video_image.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/video_info.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
            child: CircularProgressIndicator(
          color: deepOrangeAccent,
        ));
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
      return Stack(
        children: [
          ListView.builder(
              itemCount: controller.lstVideos.length,
              itemBuilder: (ctx, index) {
                HomeModel homeModel = controller.lstVideos[index];
                return InkWell(
                  onTap: () {
                    controller.updateSelectedVideo(homeModel: homeModel);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.02,
                        vertical: Get.height * 0.01),
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
                  ),
                );
              }),
          Obx(() {
            if (controller.selectedVideo.value == null) {
              return const SizedBox();
            }
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  final currentHeight = controller.dragHeight.value;
                  final screenHeight = Get.height;

                  if (currentHeight > screenHeight * 0.5) {
                    // Snap to full height if more than halfway
                    controller.dragHeight.value = screenHeight * 0.826;
                    controller.isVideoMinimized.value = false;
                  } else if (currentHeight <= screenHeight * 0.5) {
                    // Snap to minimized height if less than halfway but above threshold
                    controller.dragHeight.value = screenHeight * 0.1;
                    controller.isVideoMinimized.value = true;
                  } else {
                    // Close completely if dragged below threshold
                    // controller.selectedVideo.value = null;
                  }
                },
                onVerticalDragUpdate: (details) {
                  final newHeight =
                      controller.dragHeight.value - details.primaryDelta!;
                  // final maxHeight = Get.height * 0.83;
                  final maxHeight = Get.height * 0.83;

                  final minHeight = Get.height * 0.1;

                  if (newHeight >= minHeight && newHeight <= maxHeight) {
                    controller.dragHeight.value = newHeight;
                    controller.isVideoMinimized.value = false;
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: controller.dragHeight.value,
                  color: Colors.red,
                  child:
                      // Column(
                      //
                      // )
                      // controller.isVideoMinimized.value
                      //     ? _buildMinimizedRow(controller)
                      //     : _buildExpandedColumn(controller)
                      Column(
                    children: [
                      // Draggable handle
                      Container(
                        height: Get.height * 0.01,
                        color: Colors.grey[300],
                        child: Center(
                          child: Container(
                            width: 40,
                            height: Get.height * 0.002,
                            decoration: BoxDecoration(
                              color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                      // Video player section
                      Flexible(
                          // flex: controller.isVideoMinimized.value ? 3 : 0,
                          fit: FlexFit.tight,
                          // height: controller.isVideoMinimized.value
                          //     ? Get.height * 0.09
                          //     : Get.width * 9 / 16, // 16:9 aspect ratio
                          // width: Get.width * 0.4,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                  child: YoutubePlayer(
                                controller:
                                    controller.youtubePlayerController.value,
                              )),
                              // if (controller.isVideoMinimized.value)
                              //   // Padding(
                              //   //   padding: const EdgeInsets.all(8.0),
                              //   //   child:
                              //   SizedBox(
                              //     width: Get.width * 0.05,
                              //   ),
                              if (controller.isVideoMinimized.value)
                                SizedBox(
                                    width: Get.width * 0.5,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.04,
                                          vertical: Get.height * 0.01),
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        controller.selectedVideo.value?.title ??
                                            '',
                                        // style: TextStyle(fontSize: 16),
                                        // ),
                                      ),
                                    ))
                            ],
                          )),
                      // Additional content (only visible when expanded)
                      if (!controller.isVideoMinimized.value) ...[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Your video info content here
                                // Example:
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    controller.selectedVideo.value?.title ?? '',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                // Add more content as needed
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          })
        ],
      );
    });
  }

  Widget _buildExpandedColumn(HomeController controller) {
    return Column(
      children: [
        // Draggable Handle
        Container(
          height: 24,
          alignment: Alignment.center,
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        // Video Player (Large)
        AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(
            controller: controller.youtubePlayerController.value,
          ),
        ),

        // Video Info
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedVideo.value?.title ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      controller.selectedVideo.value?.channelName ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Spacer(),
                    Text(
                      controller.selectedVideo.value?.viewCount ?? '',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Add more info/buttons as needed
                _buildActionButtons(controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(HomeController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: Icon(Icons.thumb_up, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.thumb_down, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        Obx(() => IconButton(
              icon: Icon(
                controller.selectedVideo.value?.isFavorite == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => controller.addAndRemoveFavorite(
                videoId: controller.selectedVideo.value!.videoId,
              ),
            )),
      ],
    );
  }

  Widget _buildMinimizedRow(HomeController controller) {
    return Row(
      children: [
        // Video Player (Small)
        Container(
          width: Get.width * 0.4,
          height: double.infinity,
          child: YoutubePlayer(
            controller: controller.youtubePlayerController.value,
            aspectRatio: 16 / 9,
          ),
        ),

        // Video Info
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.selectedVideo.value?.title ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  controller.selectedVideo.value?.channelName ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        // Close/Minimize Button
        IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => controller.selectedVideo.value = null,
        ),
      ],
    );
  }
}
