import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/getx/home_controller.dart';

Widget favoriteButton(double height, double width, HomeModel homeModel) {
  var controller = Get.find<HomeController>();
  return Positioned(
      top: height * 0.01,
      right: width * 0.02,
      child: Builder(builder: (ctx) {
        if (homeModel.isLoadingFavorite) {
          return SizedBox(
            child: CircularProgressIndicator(
              color: deepOrange,
            ),
          );
        }
        return InkWell(
          onTap: () async {
              debugPrint("clicked");
            await controller.addAndRemoveFavorite(videoId: homeModel.videoId);
          },
          child: Builder(builder: (ctx) {
            if (homeModel.isFavorite) {
              return Icon(
                Icons.favorite,
                color: deepOrange,
              );
            }
            return Icon(
              Icons.favorite,
              color: white,
            );
          }),
        );
      })
      // }
      // )
      );
}
