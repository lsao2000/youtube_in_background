import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_in_background/pages/AudioPlayerHandler.dart';
import 'package:youtube_in_background/pages/Home.dart';
import 'package:youtube_in_background/pages/PlayVideoTest.dart';
void main()  {
    //final audio = await AudioService.init(builder: () => Audioplayerhandler(),
    //    config: AudioServiceConfig(
    //        androidNotificationChannelId:'com.example.app.channel.audio',
    //        androidNotificationChannelName: 'Audio playback',
    //        androidNotificationOngoing: true,
    //        ));
      runApp( MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
    //final Audioplayerhandler audioHandler;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Home(),
    );
  }
}
