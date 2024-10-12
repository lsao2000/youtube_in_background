import 'package:flutter/material.dart';

class PlaylistProvider extends ChangeNotifier {
    bool showFloating = false;
   void updateShowFloating(){
        showFloating = !showFloating;
        notifyListeners();
    }
}
