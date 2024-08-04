
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    YoutubeExplode yt = YoutubeExplode();
    List<String> lst = ["ks", "lskd", "sjkd" , "kjsjd" , " slksd", "shs","ks", "lskd", "sjkd" , "kjsjd" , " slksd", "shs", "ks", "lskd", "sjkd" , "kjsjd" , " slksd", "shs"];

    TextEditingController searchController = TextEditingController();
    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.sizeOf(context).width;
        double height = MediaQuery.sizeOf(context).height;
        String title = "The title of the video is here";
        return SingleChildScrollView(
                child: Column(
                    children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                                Container(
                                    padding: EdgeInsets.symmetric(vertical:height * .009, horizontal: width * 0.015),
                                    width: width * 0.8,
                                    height: height * 0.07,
                                    child:TextFormField(
                                        controller: searchController,
                                        textAlign: TextAlign.left,
                                        decoration: InputDecoration(
                                            hintText: "Seach For Videos",
                                            //hintStyle: ,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide: const BorderSide(color: Colors.grey),
                                            ),
                                            focusedBorder:  OutlineInputBorder(
                                                borderRadius:BorderRadius.circular(8),
                                                borderSide: const BorderSide(color: Colors.grey)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide:const BorderSide(color: Colors.grey),),
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                borderSide:const BorderSide(color: Colors.grey),
                                            ),
                                        ),
                                        cursorColor: Colors.grey,
                                    )
                                ),
                                InkWell(
                                    child:const Icon(Icons.search),
                                    onTap: (){
                                        print("taped");
                                        //printToConsole("");
                                    },
                                ),
                            ],
                        ),
                        SizedBox(
                            width: width,
                            height: height ,
                            child: ListView.builder(
                                itemCount: lst.length,
                                itemBuilder: (context, index){
                                    return InkWell(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.02),
                                            child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                    SizedBox(
                                                        child:ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child:Image.network("https://img.youtube.com/vi/XRDfETqZvJM/default.jpg",
                                                            width: 200,
                                                            scale: .1
                                                            ),
                                                        ),
                                                    ),
                                                     Column(
                                                         children: [
                                                             Container(
                                                                 padding: EdgeInsets.symmetric(vertical: height * 0.02),
                                                                 width: width * 0.42,
                                                                 child: const Text("The title oof the video is heref the video is here",
                                                                     maxLines: 2,
                                                                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),),)
                                                        ],
                                                    ),
                                            ],)
                                        ),
                                    );
                                }
                            )
                        ,)
                    ]
                ),
            ) ;
    }
}
