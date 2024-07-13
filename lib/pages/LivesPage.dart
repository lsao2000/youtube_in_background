
import 'package:flutter/material.dart';

class LivesPage extends StatefulWidget{
    const LivesPage({super.key});
    @override
    LivesPageState createState() => LivesPageState();
}
class LivesPageState extends State<LivesPage>{
    @override
    Widget build(BuildContext context) {
        return const Center(child:Text("Lives videos", style:TextStyle(fontSize: 33, color: Colors.orange)));
      }
}
