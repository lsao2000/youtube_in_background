import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_favorite_audio.dart';
import 'package:youtube_inbackground_newversion/controller/provider/play_video_as_audio.dart';
import 'package:youtube_inbackground_newversion/controller/provider/playlist_provider.dart';
import 'package:youtube_inbackground_newversion/view/MainPage.dart';
//import 'package:youtube_inbackground_newversion/view/test.dart';
void main() {
  runApp(
      MyApp()
  );
      //const MyApp()
      //ChangeNotifierProvider(
    //create: (_) => PlayVideoAsAudio(),
    //child: const MyApp(),
  //));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => PlayVideoAsAudio()),
        ChangeNotifierProvider(create: (ctx) => PlaylistProvider()),
        ChangeNotifierProvider(create: (ctx) => PlayFavoriteAudio()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainPage(title: 'Y&B'),
      ),
    );
  }
}
