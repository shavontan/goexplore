import 'package:flutter/material.dart';
import './flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarksBar extends StatefulWidget {

  @override
  _BookmarksBarState createState() => _BookmarksBarState();
}


class _BookmarksBarState extends State<BookmarksBar> {

  List<bool> isSelected = [false, false, false];

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Future.wait(generateToggleButtons()),
    //     builder: (context, snapshot) {
          return ToggleButtons(
            children: <Widget>[
              //...((snapshot.data! as List)[0] as List<Widget>),
              Icon(Icons.bookmark),
              Icon(Icons.bookmark),
              Icon(Icons.bookmark),

            ],
          selectedColor: Colors.black,
          fillColor: Colors.lightGreen[200],
          onPressed: (int index) {
              setState(() {
                isSelected[index] = !isSelected[index];

                print(isSelected);
              });
          },
          isSelected: isSelected,
          );
        // }
        // );
  }
}

 Future<List<dynamic>> getBookmarks() async {
  final uid = await getCurrentUID();

  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
        return ((value.data() as Map)['bookmarks']);
      });
}

// Future<List<dynamic>> generateToggleButtons() async {
//
//   List<dynamic> bookmarks = await getBookmarks();
//   final List<Widget> children = [];
//
//   for (int i = 0; i < bookmarks.length; i++) {
//     children.add(
//       Column(
//         children: [
//           Icon(Icons.bookmark),
//           Text(bookmarks[i]),
//         ]
//       )
//     );
//   }
//   return children;
// }

// class _BookmarksBarState extends State<BookmarksBar> {
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Future.wait([generateToggleButtons(), getBookmarks().then((val) {return val.length;})]),
//         builder: (context, snapshot) {
//           return ToggleButtons(
//             children: <Widget>[
//               ...((snapshot.data! as List)[0] as List<Widget>),
//
//             ],
//             selectedColor: Colors.black,
//             fillColor: Colors.lightGreen[200],
//             onPressed: (int index) {
//               print(generateToggleButtons());
//               setState(() {
//                 isSelected[index] = !isSelected[index];
//
//                 print(isSelected);
//               });
//             },
//             isSelected: isSelected,
//           );
//         }
//     );
//     return Container();
//   }
// }
//
// Future<List<dynamic>> getBookmarks() async {
//   final uid = await getCurrentUID();
//
//   return await FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .get()
//       .then((value) {
//     return ((value.data() as Map)['bookmarks']);
//   });
// }
//
// List<Widget> children = [];
// List<bool> isSelected = [];
// bool initialized = false;
//
// Stream<Widget> generateToggleButtons() async* {
//   List<dynamic> bookmarks = await getBookmarks();
//
//   if (!initialized) {
//     for (int i = 0; i < bookmarks.length; i++) {
//
//       if (i == bookmarks.length - 1) {
//         initialized = true;
//       }
//
//       isSelected.add(false);
//       children.add(
//           Column(
//               children: [
//                 Icon(Icons.bookmark),
//                 Text(bookmarks[i]),
//               ]
//           )
//       );
//     }
//   }
//
//   yield* ToggleButtons(
//     children: children,
//     isSelected: isSelected,
//     onPressed: (index) {
//       setState(() {
//         isSelected[index] = !isSelected[index];
//       });
//     },
//   );
// }

