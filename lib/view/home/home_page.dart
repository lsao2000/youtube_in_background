import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Search Something",
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: placeHolderColor),
      ),
    );
  }
}
