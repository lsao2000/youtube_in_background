import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';
import 'package:youtube_inbackground_newversion/view/FavouritePage.dart';
import 'package:youtube_inbackground_newversion/view/HomePage.dart';
import 'package:youtube_inbackground_newversion/view/LivesPage.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
    int pageIndex = 0;
    List<Widget> lstNavigationPages = [ const HomePage(), const FavouritePage(), const LivesPage()];
    @override
    Widget build(BuildContext context) {
       double width = MediaQuery.of(context).size.width;
       double height = MediaQuery.of(context).size.height;
        return Scaffold(
            appBar: AppBar(
                backgroundColor: appBarColor,
                 actions: [
                     Container(
                         padding: EdgeInsets.symmetric(vertical: 0, horizontal: width * 0.02),
                     child:Icon(Icons.search, color: brandColor,size: width * 0.06,)
                         )
                 ],
                title: Text(widget.title,
                    style:  TextStyle(color: brandColor, fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
            ),
            body:lstNavigationPages[pageIndex],
            bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
                    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourite"),
                    BottomNavigationBarItem(icon: Icon(Icons.live_tv), label: "Lives")
                ],
                currentIndex:pageIndex ,
                backgroundColor: bottomBarColor,
                selectedItemColor: brandColor,
                selectedLabelStyle:const TextStyle(fontWeight: FontWeight.bold),
                onTap: (value){
                    setState((){
                        pageIndex = value;
                    });
                },
            ),
            );
    }
}
