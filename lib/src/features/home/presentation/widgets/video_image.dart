import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/helper/image_helper.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/home/domain/models/home_model.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/widgets/favorite_button.dart';

Widget videoImage(double width, double height, HomeModel homeModel) {
  return SizedBox(
    child: Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            ImageHelper().getHighQualityImageUrl(imgUrl: homeModel.videoId),
            errorBuilder: (context, error, stackTrace) => Image.network(
                width: width * 0.485,
                height: height * 0.17,
                fit: BoxFit.cover,
                ImageHelper().getDefaultImageUrl(imgUrl: homeModel.videoId)),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return SizedBox(
                height: height * 0.17,
                width: width * 0.485,
                child: Center(
                  child: CircularProgressIndicator(
                      color: deepOrange,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null),
                ),
              );
            },
            width: width * 0.485,
            height: height * 0.17,
            fit: BoxFit.fill,
          ),
        ),
        favoriteButton(height, width, homeModel),
        Builder(
          builder: (ctx) {
            return homeModel.isLive
                ?
                // Positioned(
                //    right: width * .01,
                //    bottom: height * 0.01,
                //    child:
                //  )
                const SizedBox()
                : Positioned(
                    right: width * .01,
                    bottom: height * 0.01,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withAlpha(120),
                          borderRadius: BorderRadius.circular(4)),
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: height * 0.01),
                      child: Text(
                        homeModel.durationAsString.split(".").first,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
          },
        ),
      ],
    ),
  );
}
