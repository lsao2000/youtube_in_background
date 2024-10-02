import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/controller/search_history_controller.dart';
import 'package:youtube_inbackground_newversion/model/PlayVideAsAudio.dart';
import 'package:youtube_inbackground_newversion/model/search_history.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  late SearchHistoryController searchHistoryController;
  List<SearchHistory> allSearch = [];
  @override
  void initState() {
    super.initState();
    searchHistoryController = SearchHistoryController();
    refreshAllSearch();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final playVideoAsAudio =
        Provider.of<PlayVideoAsAudio>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            SizedBox(
              width: width * 0.75,
              height: height * 0.06,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: placeHolderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: placeHolderColor)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: placeHolderColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: placeHolderColor),
                  ),
                ),
                cursorColor: placeHolderColor,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) async {
                  var searchWord = searchController.text.toString();
                  playVideoAsAudio.searchYoutube(searchWord);
                  searchHistoryController.addToHistory(searchWord);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: height * 0.03,
        ),
        SizedBox(
          width: width,
          height: height * 0.6,
          child: ListView.builder(
            itemCount: allSearch.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.04),
                  child: Text(allSearch[index].search,
                      style: TextStyle(
                        color: loading,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ),
                onTap: () {
                  searchController.text = allSearch[index].search;
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text("do you want to delete this"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              searchHistoryController
                                  .deleteItem(allSearch[index].search_id!);
                              refreshAllSearch();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("No")),
                        ],
                      );
                    },
                  );
                  print("you want to delete it");
                },
              );
            },
          ),
        ),
      ])),
    );
  }

  void refreshAllSearch() async {
    final data = await searchHistoryController.getAllSearch();
    setState(() {
      allSearch = data;
      allSearch = allSearch.reversed.toList();
    });
  }
}
