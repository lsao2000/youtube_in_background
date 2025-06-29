import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_inbackground_newversion/src/features/download/presentation/getx/download_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';

Widget showDownloadsOptions(
    BuildContext context, Map<String, List<StreamInfo>> data) {
  return AlertDialog(
    icon: Row(
      children: [
        const Expanded(child: Text("")),
        InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: data.entries.map((entry) {
          final key = entry.key;
          final streams = entry.value;
          return ExpansionTile(
            title: Text(key),
            children: streams.map((stream) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                title: entry.key == "mp3"
                    ? Text(
                        '${(stream.bitrate.kiloBitsPerSecond ~/ 10 * 10)} kbps - ${stream.size}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      )
                    : Text("${stream.qualityLabel} - ${stream.size}"),
                onTap: () {
                  // Handle download action
                  var homeController = Get.find<HomeController>();
                  var downloadController = Get.find<DownloadController>();
                  homeController.downloadAudio(
                    stream.bitrate.kiloBitsPerSecond ~/ 10 * 10,
                  );
                  downloadController.isDownloading.value = true;
                  downloadController.isDownloading.refresh();
                  Get.back();
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    ),
  );
}
