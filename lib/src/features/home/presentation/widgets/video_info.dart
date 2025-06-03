import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';

Widget videoInfo(
    {required double width,
    required double height,
    required HomeModel homeModel}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: height * 0.005),
        width: width * 0.42,
        child: Text(
          homeModel.title,
          maxLines: 3,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Get.width * 0.1),
            child: Image.network(
              homeModel.channelImageUrl,
              // "",
              width: Get.width * 0.04,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              // height: Get.height * .035,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return SizedBox(
                    width: Get.width * 0.04,
                    height: Get.width * 0.04,
                    child: CircularProgressIndicator(
                      value: loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!,
                      color: deepOrange,
                    ));
              },
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: Get.width * 0.01,
          ),
          SizedBox(
            width: Get.width * 0.35,
            child: Text(
              homeModel.channelName,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.005),
        child: Text(
          "${homeModel.viewCount} views",
          style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              overflow: TextOverflow.ellipsis),
        ),
      ),
      // SizedBox(
      //   height: Get.height * 0.02,
      // ),
      !homeModel.isLive
          ? const Text("")
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: Colors.red),
              padding: EdgeInsets.symmetric(horizontal: width * 0.009),
              child: Row(
                children: [
                  Icon(
                    Icons.circle_rounded,
                    color: white,
                    size: ((Get.height + Get.width) / 2) * 0.014,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text("LIVE",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: white)),
                ],
              ),
            ),
      // Row(
      //     children: [
      //       Container(
      //         padding: EdgeInsets.symmetric(
      //             horizontal: width * 0.005, vertical: height * 0.01),
      //         child:
      //             Icon(Icons.circle, color: Colors.red, size: width * 0.05),
      //       ),
      //       const Text("Live",
      //           style: TextStyle(fontWeight: FontWeight.bold)),
      //     ],
      //   ),
    ],
  );
}
