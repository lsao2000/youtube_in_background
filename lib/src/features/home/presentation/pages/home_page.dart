import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                  controller.isVideoMinimized.value =
                      controller.wasMimizingView.value ? true : false;
                  controller.dragHeight.value =
                      controller.isVideoMinimized.value
                          ? controller.availableHeight.value * 0.14
                          : controller.availableHeight.value;
                },
                onVerticalDragUpdate: (details) {
                  final newHeight =
                      controller.dragHeight.value - details.primaryDelta!;
                  final maxHeight = controller.availableHeight.value;
                  final minHeight = Get.height * 0.1;
                  controller.dragHeight.value = newHeight;
                  if (newHeight >= minHeight && newHeight <= maxHeight) {
                    if (details.primaryDelta! > 0 &&
                        newHeight < maxHeight * 0.9) {
                      controller.wasMimizingView.value = true;
                      if (newHeight <= Get.height * 0.14) {
                        controller.isVideoMinimized.value = true;
                      }
                    } else if (details.primaryDelta! < 0 &&
                        newHeight > Get.height * 0.14) {
                      controller.isVideoMinimized.value = false;
                      controller.wasMimizingView.value = false;
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.decelerate,
                  decoration: BoxDecoration(color: white, boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      // withOpacity( 0.3), // Shadow color (black with opacity)
                      spreadRadius: 2, // How far the shadow extends
                      blurRadius: 5, // Softness of the shadow
                      offset: const Offset(0, 4), // Shadow position (x, y)
                    ),
                  ]),
                  height: controller.dragHeight.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: YoutubePlayer(
                                key: ValueKey(
                                    controller.youtubePlayerController.value),
                                controller:
                                    controller.youtubePlayerController.value,
                              ),
                            ),
                            if (controller.isVideoMinimized.value)
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.42,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.width * 0.04,
                                              vertical: Get.height * 0.01),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            controller.selectedVideo.value
                                                    ?.title ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                              controller.resetAll();
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: Get.width * .08,
                                        height: Get.width * .08,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Get.width * .1),
                                          child: Image.network(
                                            controller.selectedVideo.value
                                                    ?.channelImageUrl ??
                                                "",
                                            // "",
                                            width: Get.width * 0.04,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                            // height: Get.height * .035,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return SizedBox(
                                                  width: Get.width * 0.08,
                                                  height: Get.width * 0.08,
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!,
                                                    color: deepOrange,
                                                  ));
                                            },
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.37,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.02,
                                          ),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            controller.selectedVideo.value
                                                    ?.channelName ??
                                                '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                      if (!controller.isVideoMinimized.value) ...[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.04,
                                      vertical: Get.height * 0.01),
                                  child: Text(
                                    controller.selectedVideo.value?.title ?? "",
                                    maxLines: 2,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.03,
                                    ),
                                    SizedBox(
                                      width: Get.width * .08,
                                      height: Get.width * .08,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Get.width * .1),
                                        child: Image.network(
                                          controller.selectedVideo.value
                                                  ?.channelImageUrl ??
                                              "",
                                          width: Get.width * 0.04,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error),
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return SizedBox(
                                              width: Get.width * 0.08,
                                              height: Get.width * 0.08,
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!,
                                                color: deepOrange,
                                              ),
                                            );
                                          },
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.width * 0.04,
                                          vertical: Get.height * 0.01),
                                      child: SizedBox(
                                        width: Get.width * 0.37,
                                        child: Text(
                                          controller.selectedVideo.value
                                                  ?.channelName ??
                                              "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Text("")),
                                    IconButton(
                                      onPressed: () {
                                        controller.shareVideo();
                                      },
                                      icon: Icon(
                                        Icons.share,
                                        color: deepOrange,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        controller.showAvailableFormats();
                                      },
                                      icon: controller.isDownloading.value
                                          ? Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  width: Get.width * 0.06,
                                                  height: Get.height * 0.03,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: deepOrange,
                                                    value: controller
                                                            .downloadProgress
                                                            .value /
                                                        100,
                                                  ),
                                                ),
                                                controller.downloadProgress
                                                            .value ==
                                                        100
                                                    ? Icon(
                                                        Icons.download_done,
                                                        color: deepOrange,
                                                        size: Get.width * 0.04,
                                                      )
                                                    : SizedBox(
                                                        child: Icon(
                                                          size:
                                                              Get.width * 0.04,
                                                          Icons.download,
                                                          color: deepOrange,
                                                        ),
                                                      )
                                              ],
                                            )

                                          // CircularProgressIndicator(
                                          //     color: deepOrange,
                                          //     value: controller
                                          //             .downloadProgress.value /
                                          //         100,
                                          //
                                          //   )
                                          : Icon(
                                              Icons.download,
                                              color: deepOrange,
                                            ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.02,
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black26,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.04,
                                      vertical: Get.height * 0.01),
                                  child: Text(
                                    controller
                                            .selectedVideo.value?.description ??
                                        "",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      // overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
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
}
