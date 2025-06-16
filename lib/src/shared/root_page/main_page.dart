import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/search/presentation/view/search_page.dart';
import 'package:youtube_inbackground_newversion/src/shared/root_page/main_controller.dart';
import 'package:youtube_inbackground_newversion/src/features/favorite/presentation/pages/favorite_page.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/pages/home_page.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class MainPage extends GetView<MainController> {
  MainPage({super.key});
  final pages = [HomePage(), FavoritePage()];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () async {
              // init();
              await showSearch(context: context, delegate: SearchPage());
              // Get.toNamed("");
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: Get.height * 0.04,
            ),
          ),
        ],
        title: Text(
          "BackTube",
          style: TextStyle(
              // fontFamily: "inter",
              color: brandColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() => pages[controller.currentTabIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: controller.changeTab,
            currentIndex: controller.currentTabIndex.value,
            backgroundColor: bottomBarColor,
            selectedItemColor: brandColor,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favorite"),
            ],
          )),
    );
  }
}
