import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_inbackground_newversion/src/core/styles/theme_colors.dart';
import 'package:youtube_inbackground_newversion/src/features/search/presentation/getx/search_controller.dart';

class SearchPage extends SearchDelegate {
  final SearchBarController searchBarController =
      Get.find<SearchBarController>();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: deepOrangeAccent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(fontSize: 16.0, color: Colors.white60),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: white,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      Future.any([searchBarController.addToHistory(query)])
          .whenComplete(() async {
        // Get.back();
        await searchBarController.searchForVideo(searchQuery: query);
      });
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchList();
  }

  Widget _buildSearchList() {
    return Obx(
      () => ListView.builder(
        itemCount: searchBarController.filteredList.length,
        itemBuilder: (context, index) {
//             String item = searchBarController.filteredList[index].getTitle;
//             return InkWell(
//               onTap: () async {
//                 debugPrint("resultats");
//                 if (query.isNotEmpty) {
//                   await searchBarController
//                       .addToHistory(query)
//                       .whenComplete(() {
//                     searchBarController.filteredList.refresh();
//                     searchBarController.allSearch.refresh();
//                     // Get.back();
//                   });
          final item = searchBarController.filteredList[index];
          return ListTile(
            title: Text(
              item.getTitle,
              style: TextStyle(
                color: grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            onTap: () async {
              await searchBarController.searchForVideo(
                  searchQuery: item.getTitle);
            },
          );
        },
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return query.isNotEmpty
        ? [
            IconButton(
              onPressed: () => query = "",
              icon: Icon(
                Icons.clear,
                color: white,
              ),
            ),
          ]
        : [];
  }

  @override
  void dispose() {
    Get.delete<SearchBarController>(); // Proper cleanup
    super.dispose();
  }
}
// class SearchPage extends SearchDelegate {
//   final SearchBarController searchBarController =
//       Get.find<SearchBarController>();
//
//   @override
//   Widget buildResults(BuildContext context) {
//     // searchBarController.search(query);
//     // return const SizedBox();
//     debugPrint("resultats search and go");
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Obx(() => ListView.builder(
//           itemCount: searchBarController.filteredList.value.length,
//           itemBuilder: (context, index) {
//             String item = searchBarController.filteredList[index].getTitle;
//             return InkWell(
//               onTap: () async {
//                 debugPrint("resultats");
//                 if (query.isNotEmpty) {
//                   await searchBarController
//                       .addToHistory(query)
//                       .whenComplete(() {
//                     searchBarController.filteredList.refresh();
//                     searchBarController.allSearch.refresh();
//                     // Get.back();
//                   });
//                 } else {
//                   var snackBar =
//                       const SnackBar(content: Text("add search text"));
//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: height * 0.015, horizontal: width * 0.02),
//                 child: Text(item,
//                     style: TextStyle(
//                       color: loading,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     )),
//               ),
//             );
//             // return ;
//           },
//         ));
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     searchBarController.search(query);
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Obx(() => ListView.builder(
//           itemCount: searchBarController.filteredList.value.length,
//           itemBuilder: (context, index) {
//             String item =
//                 searchBarController.filteredList.value[index].getTitle;
//             return InkWell(
//               onTap: () async {
//                 debugPrint("search and go");
//                 if (query.isNotEmpty) {
//                   await searchBarController.addToHistory(item);
//                   searchBarController.filteredList.refresh();
//                   searchBarController.allSearch.refresh();
//                   // Get.back();
//                 } else {
//                   var snackBar = SnackBar(content: Text("add search text"));
//                   ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     vertical: height * 0.015, horizontal: width * 0.02),
//                 child: Text(item,
//                     style: TextStyle(
//                       color: loading,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                     )),
//               ),
//             );
//             // return ;
//           },
//         ));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     searchBarController.dispose();
//   }
//
//   @override
//   void showResults(BuildContext context) async {
//     super.showResults(context);
//     if (query.isNotEmpty) {
//       await searchBarController.addToHistory(query).whenComplete(() {
//         debugPrint("complet");
//         searchBarController.filteredList.refresh();
//         searchBarController.allSearch.refresh();
//       });
//     } else {
//       var snackBar = SnackBar(content: Text("add search text"));
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       // const SnackBar(content: Text("add search text"));
//     }
//   }
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       query.isEmpty
//           ? const SizedBox()
//           : IconButton(
//               onPressed: () {
//                 query = "";
//               },
//               icon: Icon(
//                 Icons.clear,
//                 color: brandColor,
//               ),
//             ),
//       query.isEmpty
//           ? const SizedBox()
//           : IconButton(
//               onPressed: () async {
//                 await searchBarController.addToHistory(query);
//                 searchBarController.filteredList.refresh();
//                 searchBarController.allSearch.refresh();
//               },
//               icon: Icon(
//                 Icons.search,
//                 color: brandColor,
//               ),
//             ),
//     ];
//   }
//
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         Icons.arrow_back,
//         color: brandColor,
//       ),
//       onPressed: () {
//         Get.back();
//       },
//     );
//   }
// }
