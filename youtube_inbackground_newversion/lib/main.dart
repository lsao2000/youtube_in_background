import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/model/PlayVideAsAudio.dart';
import 'package:youtube_inbackground_newversion/view/MainPage.dart';
//import 'package:youtube_inbackground_newversion/view/test.dart';
void main() {
  runApp(
     //const MyApp()
      ChangeNotifierProvider(create:(_)=> PlayVideoAsAudio() ,
          child:const MyApp(),)
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      //home: const TestBackgroundAudio(),
      home: const MainPage(title: 'Y&B'),
    );
  }
}


