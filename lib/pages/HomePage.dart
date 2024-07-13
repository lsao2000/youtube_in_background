import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
    const HomePage({super.key});
    @override
    HomePageState createState() => HomePageState();
}
class HomePageState extends State<HomePage> {

   @override
     Widget build(BuildContext context) {
         return const Center(child: Text("home", style: TextStyle(fontSize: 33, color: Colors.orange),),);
     }
}
