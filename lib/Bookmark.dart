import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/newBookmarkTile.dart';

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

  void refresh() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getBookmarkLocations(this.bookmarkName),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(widget.bookmarkName, style: TextStyle(color: Colors.black)),
                  backgroundColor: Color(0xB6C4CAE8),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                      Navigator.pop(context);
                    },
                  ),),
                body: Center(child: CircularProgressIndicator()),
                backgroundColor: Colors.white);
          }

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
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child:
                                BookMarkTile(name: snapshot.data!.docs[index]['name'],
                                  imageURL_360: snapshot.data!.docs[index]['360image'],
                                  description: snapshot.data!.docs[index]['description'],
                                  address: snapshot.data!.docs[index]['address'],
                                  imgURLs: snapshot.data!.docs[index]['imageList'],)
                              // BookmarkTile(
                              //   bookmarkName: this.bookmarkName,
                              //   image: Image.network(snapshot.data!.docs[index]['imageURL']),
                              //   title: snapshot.data!.docs[index]['name'],
                              //   shortDescription: snapshot.data!.docs[index]['description'],
                              //   estimatedPrice: snapshot.data!.docs[index]['price'],
                              // )
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
                          child: Container(color: Colors.red,
                              //child: Center(child: Text("Delete?", style: GoogleFonts.nanumGothic(fontSize: 30, fontWeight: FontWeight.w600),))),
                              child: Row(children: [
                                Container(width: MediaQuery.of(context).size.width / 8),
                                Icon(Icons.delete, size: 35,),
                                Container(width: MediaQuery.of(context).size.width / 1.8),
                                Icon(Icons.delete, size: 35),
                              ])),
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