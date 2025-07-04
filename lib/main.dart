import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/routes/route_pages.dart';
import 'package:youtube_inbackground_newversion/src/features/download/download_dependency_injections.dart';
import 'package:youtube_inbackground_newversion/src/features/home/home_dependency_injections.dart';
import 'package:youtube_inbackground_newversion/src/features/search/search_dependency_injections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (Platform.isLinux) {
  //   // await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  // }
  // DD69-C273
  try {
    await initHomeDependency();
    await initDownloadDependencyInjections();
    // initSearchDependy();
  } catch (e) {
    debugPrint(e.toString());
  }
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
