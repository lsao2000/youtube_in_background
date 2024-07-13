
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
    const FavouritePage({super.key});
    @override
    FavouritePageState createState() => FavouritePageState();
}
class FavouritePageState extends State<FavouritePage> {
    @override
      Widget build(BuildContext context) {
          return const Center(child: Text("Favourite Page", style: TextStyle(fontSize: 33, color: Colors.orange)));
      }
}
