import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flutterfire.dart';

import 'Bookmark.dart';

class BookmarkList extends StatefulWidget {

  @override
  _BookmarkListState createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getBookmarks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return new Scaffold(
            appBar: AppBar(
              title: Text('Your bookmarks', style: TextStyle(color: Colors.black)),
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
              itemCount: (snapshot.data! as List).length,
              itemBuilder: (BuildContext context, int index) =>
              //  buildCard(context, (snapshot.data! as List)[index])
                  new Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {

                      String uid = await getCurrentUID();
                      String bkName = snapshot.data![index];

                      snapshot.data!.removeAt(index);

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection(bkName)
                          .get()
                          .then((snapshot) {
                         for (DocumentSnapshot ds in snapshot.docs) {
                           ds.reference.delete();
                         }
                      });

                      List<dynamic> updatedList = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get()
                          .then((value) {
                        List<dynamic> list = (value.data() as Map)['bookmarks'];
                        list.removeWhere((item) => item == bkName);
                        return list;
                      });

                      setState(() {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({'bookmarks': updatedList});
                      });

                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: new Text("Bookmark deleted"),
                      ));
                    },
                    child: buildCard(context, (snapshot.data! as List)[index]),
                    // background: new Container(color: Colors.red),

                  )
            )
        );
      }
    );
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

Widget buildCard(BuildContext context, String name) {
  return Padding(padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: SizedBox(
                  child: Card(
                    child: TextButton(
                      child: Text(name, style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Bookmark(name)));
                      },
                    ),
                    color: Color(0xFFCCC3E8),
                  ),
                  height: 75,
                  width: 275,
                ));
}

// class BookmarkList extends StatefulWidget {
//   //const BookmarkList({Key key}) : super(key: key);
//
//   @override
//   _BookmarkListState createState() => _BookmarkListState();
// }
//
// class _BookmarkListState extends State<BookmarkList> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Your bookmarks', style: TextStyle(color: Colors.black)),
//           backgroundColor: Color(0xB6C4CAE8),
//           elevation: 0.0,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context, false);
//             },
//           ),
//         ),
//         body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(height: 50),
//                 SizedBox(
//                   child: Card(
//                     child: TextButton(
//                       child: Text("Bookmark 1", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
//                       onPressed: () {
//                         Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => Bookmark()));
//                       },
//                     ),
//                     color: Color(0xFFCCC3E8),
//                   ),
//                   height: 70,
//                   width: 275,
//                 ),
//                 Container(height: 20),
//                 SizedBox(
//                   child: Card(
//                     child: TextButton(
//                       child: Text("Bookmark 2", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
//                       onPressed: () {
//                         // NAVIGATE TO BOOKMARK 2
//                       },
//                     ),
//                     color: Color(0xFFCCC3E8),
//                   ),
//                   height: 70,
//                   width: 275,
//                 ),
//                 Container(height: 20),
//                 SizedBox(
//                   child: Card(
//                     child: TextButton(
//                       child: Text("Bookmark 3", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
//                       onPressed: () {
//                         // NAVIGATE TO BOOKMARK 3
//                       },
//                     ),
//                     color: Color(0xFFCCC3E8),
//                   ),
//                   height: 70,
//                   width: 275,
//                 ),
//                 Container(height: 20),
//                 SizedBox(
//                   child: Card(
//                     child: TextButton(
//                       child: Text("Bookmark 4", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
//                       onPressed: () {
//                         // NAVIGATE TO BOOKMARK 4
//                       },
//                     ),
//                     color: Color(0xFFCCC3E8),
//                   ),
//                   height: 70,
//                   width: 275,
//                 ),
//               ],
//             )
//         )
//     );
//   }
// }