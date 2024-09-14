import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
    const FavouritePage({super.key});
    @override
    FavouritePageState createState() => FavouritePageState();

}
class FavouritePageState extends State<FavouritePage> {
    @override
      void initState() {
        super.initState();
      }
    @override
      Widget build(BuildContext context) {
         return  Center(
             child: FloatingActionButton(
                 onPressed:(){
                   try{
                     print("pressed");
                   }catch(e){
                     print("ohh no we got error");
                    }

                 },
                 child: const Text("show notification"),), );
      }
}
