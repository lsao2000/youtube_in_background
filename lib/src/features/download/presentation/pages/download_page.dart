import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/download/domain/models/downloaded_video_model.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({super.key});
  final downloadController = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: downloadController.downloadedVideos.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (ctx, index) {
          DownloadedVideoModel? item =
              downloadController.downloadedVideos[index];
          return Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: Get.width * 0.2,
                        height: Get.height * 0.1,
                        foregroundDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Get.width * 0.01),
                          color: Colors.black.withAlpha(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Get.width * 0.01),
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Image.network(item.thumbnailUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.1,
                        height: Get.height * 0.05,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Get.width * 0.2),
                          child: Image.network(
                            item.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: Get.height * 0.04,
                          child: Row(
                            children: [
                              Icon(Icons.audiotrack, color: deepOrange),
                              const SizedBox(width: 4.0),
                              Text(
                                customDurationText(
                                    Duration(seconds: item.duration)),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Linear Progress Indicator(
                        //   value: 38 / 100.0,
                        //   background Color: Colors.grey[300],
                        //   color: deepOrange,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -10,
                top: -8,
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.red),
                  onPressed: () {
                    // downloadController.deleteDownloadedVideo(item.videoId);
                  },
                ),
              ),
            ],
          );
        });
  }

  String customDurationText(Duration duration) {
    try {
      if (duration.inSeconds == 0) {
        return "0";
      }
      String duratinString = duration.toString();
      List<String> lstDuration = duratinString.split(":");
      if (int.parse(lstDuration.first.toString()) == 0) {
        lstDuration.removeAt(0);
      }
      lstDuration.first = int.parse(lstDuration.first).toString();
      lstDuration.last = lstDuration.last.split(".")[0];
      return lstDuration.join(":");
    } catch (e) {
      return duration.toString();
    }
  }
}
