import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/features/favorite/presentation/pages/favorite_page.dart';
import 'package:youtube_inbackground_newversion/src/features/home/presentation/pages/home_page.dart';
import 'package:youtube_inbackground_newversion/src/shared/root_page/main_binding.dart';
import 'package:youtube_inbackground_newversion/src/shared/root_page/main_page.dart';

class RoutePages {
  static const initialPage = "/";
  static final routes = [
    GetPage(name: '/', page: () => MainPage(), binding: MainBinding()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/favorite', page: () => FavoritePage()),
    // GetPage(name: "/search", page: () => const ())
  ];
}
