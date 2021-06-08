import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/BookmarkTile.dart';

class Bookmark extends StatefulWidget {

  String bookmarkName;
  Bookmark(this.bookmarkName);

  @override
  BookmarkState createState() => BookmarkState(this.bookmarkName);
}

final listKey = GlobalKey<AnimatedListState>();


class BookmarkState extends State<Bookmark> {
  String bookmarkName;
  BookmarkState(this.bookmarkName);

  void refresh() => setState(() => {print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getBookmarkLocations(this.bookmarkName),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          print(snapshot.data!.docs.length);

          return Scaffold(
              appBar: AppBar(
                title: Text(this.bookmarkName, style: TextStyle(color: Colors.black)),
                backgroundColor: Color(0xB6C4CAE8),
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      Dismissible(
                        key: UniqueKey(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(28, 0, 0, 0),
                            child:
                              BookmarkTile(
                                bookmarkName: this.bookmarkName,
                                image: Image.network(snapshot.data!.docs[index]['imageURL']),
                                title: snapshot.data!.docs[index]['name'],
                                shortDescription: snapshot.data!.docs[index]['description'],
                                estimatedPrice: snapshot.data!.docs[index]['price'],
                              )
                          ),
                        onDismissed: (direction) async {
                          String locationName = snapshot.data!.docs[index]['name'];
                          removeItem(this.bookmarkName, locationName);

                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                            content: new Text("Location removed"),
                          ));
                        },
                       background: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Container(color: Colors.red),
                       )
                      )
              )
          );
        }
    );
  }
}

void removeItem(String bookmarkName, String locationName) async {
  String uid = await getCurrentUID();
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(bookmarkName)
      .doc(locationName)
      .delete();
}

Stream<QuerySnapshot> getBookmarkLocations(String bookmarkName) async* {

  String uid = await getCurrentUID();

  yield* FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(bookmarkName)
      .snapshots();
}

// class Bookmark extends StatefulWidget {
//
//   @override
//   _BookmarkState createState() => _BookmarkState();
// }
//
// class _BookmarkState extends State<Bookmark> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Bookmark 1', style: TextStyle(color: Colors.black)),
//           backgroundColor: Color(0xB6C4CAE8),
//           elevation: 0.0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//           ),
//         ),
//         body: Column(       // EDIT THIS TO MAKE A LIST (of locations) INSTEAD
//           children: [
//             BookmarkTile(
//               image: Image.asset('assets/images/SGbackground.png'),
//               title: "Gardens by the bay",
//               shortDescription: "Pretty flowers and nice light show – very kid-friendly",
//               estimatedPrice: 2,
//             ),
//             Container(height: 20),
//             BookmarkTile(
//               image: Image.asset('assets/images/SGbackground.png'),
//               title: "America",
//               shortDescription: "another country",
//               estimatedPrice: 3,
//             ),
//             Container(height: 20),
//             BookmarkTile(
//               image: Image.asset('assets/images/SGbackground.png'),
//               title: "Marriot",
//               shortDescription: "hotel",
//               estimatedPrice: 3,
//             ),
//             Container(height: 20),
//           ],
//         )
//     );
//   }
// }