import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/routes/route_pages.dart';
import 'package:youtube_inbackground_newversion/src/features/home/home_dependency_injections.dart';
import 'package:youtube_inbackground_newversion/src/features/search/search_dependency_injections.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initSearchDependy();
  initHomeDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePages.initialPage,
      getPages: RoutePages.routes,
    );
  }
}
