import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:youtube_inbackground_newversion/view/home/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("home"),
    );
  }
}
