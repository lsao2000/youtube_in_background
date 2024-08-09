import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_inbackground_newversion/model/PlayVideAsAudio.dart';
import 'package:youtube_inbackground_newversion/utils/colors.dart';
import 'package:youtube_inbackground_newversion/view/HomePage.dart';

class SearchPage extends StatefulWidget{
    const SearchPage({super.key});
    @override
    SearchPageState createState() => SearchPageState() ;
}

class SearchPageState extends State<SearchPage> {
    TextEditingController searchController = TextEditingController();
    //late PlayVideoAsAudio playVideoAsAudio ;

    @override
      void initState() {
        super.initState();
        //playVideoAsAudio = PlayVideoAsAudio();
      }
    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        final playVideoAsAudio = Provider.of<PlayVideoAsAudio>(context, listen: false);
        return Scaffold(
            appBar: AppBar(
                title:Row(children: [
                    SizedBox(
                        width: width * 0.75,
                        height: height * 0.06,
                        child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:  BorderSide(color: placeHolderColor),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderRadius:BorderRadius.circular(8),
                                    borderSide:  BorderSide(color: placeHolderColor)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: placeHolderColor),),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: placeHolderColor),
                                ),
                            ),
                            cursorColor: placeHolderColor,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) async {
                                 playVideoAsAudio.searchYoutube(searchController.text.toString());
                                Navigator.pop(context);
                            },
                            ),
                    ),
                ],) ,
            ),
        );
    }
}

