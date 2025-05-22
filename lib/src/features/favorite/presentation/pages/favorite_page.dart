import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:youtube_inbackground_newversion/src/features/favorite/presentation/getx/favorite_controller.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});
  final FavoriteController controller = Get.put(FavoriteController());
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Favorite"),
    );
  }
}
