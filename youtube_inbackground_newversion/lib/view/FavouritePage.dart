import 'package:flutter/material.dart';
import 'package:youtube_inbackground_newversion/service/notifcation_services.dart';

class FavouritePage extends StatefulWidget {
    const FavouritePage({super.key});
    @override
    FavouritePageState createState() => FavouritePageState();

}
class FavouritePageState extends State<FavouritePage> {
    late final NotifcationServices notifcationServices;
    @override
      void initState() {
        super.initState();
        notifcationServices = NotifcationServices();
      }
    @override
      Widget build(BuildContext context) {
         return  Center(
             child: FloatingActionButton(
                 onPressed:(){
                   try{
                     print("pressed");
                         notifcationServices.handleNotificationFunction();
                   }catch(e){
                    }
                   
                 },
                 child: const Text("show notification"),), );
      }
}
