import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';
import 'package:youtube_inbackground_newversion/view/favorite/FavouritePage.dart';
import 'package:youtube_inbackground_newversion/view/home/home_page.dart';
import 'package:youtube_inbackground_newversion/view/search/SearchPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageIndex = 0;
  List<Widget> lstNavigationPages = [
    // const HomePage(),
    const HomePage(),
    const FavouritePage(),
    //const LivesPage()
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SearchPage()));
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: width * 0.08,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: TextStyle(
              color: brandColor, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: lstNavigationPages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favourite"),
          //BottomNavigationBarItem(
          //    icon: Icon(Icons.playlist_play), label: "Playlist")
        ],
        currentIndex: pageIndex,
        backgroundColor: bottomBarColor,
        selectedItemColor: brandColor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
      ),
    );
  }
}
