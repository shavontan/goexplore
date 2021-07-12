import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flutterfire.dart';

import 'Bookmark.dart';
import 'package:lazy_indexed_stack/lazy_indexed_stack.dart';

class BookmarkList extends StatefulWidget {
  @override
  _BookmarkListState createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  bool confused = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getBookmarks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your bookmarks', style: TextStyle(color: Colors.black)),
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

          return new Scaffold(
              appBar: AppBar(
                  title: Text('Your bookmarks',
                      style: TextStyle(color: Colors.black)),
                  backgroundColor: Color(0xB6C4CAE8),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.help_outline, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            confused = true;
                          });
                        })
                  ]),
              body: Stack(children: [
                ListView.builder(
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

                            List<dynamic> updatedList = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .doc(uid)
                                .get()
                                .then((value) {
                              List<dynamic> list =
                                  (value.data() as Map)['bookmarks'];
                              list.removeWhere((item) => item == bkName);
                              return list;
                            });

                            setState(() {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .update({'bookmarks': updatedList});
                            });

                            ScaffoldMessenger.of(context)
                                .showSnackBar(new SnackBar(
                              content: new Text("Bookmark deleted"),
                            ));
                          },
                          child: buildCard(
                              context, (snapshot.data! as List)[index]),
                          // background: new Container(color: Colors.red),
                        )),
                Visibility(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        color: Colors.white,
                        height: 500,
                        width: 275,
                        child: Column(
                          children: [
                            Container(height: 10),
                            SizedBox(
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    Container(height: 10),
                                    Text.rich(
                                      TextSpan(
                                        text: "Features about this page",
                                        style: GoogleFonts.delius(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: "",
                                          style: GoogleFonts.delius(
                                            fontSize: 15,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "This page displays all the locations you have bookmarked."),
                                          ]),
                                    ),
                                    Container(height: 50),
                                    Text.rich(
                                      TextSpan(
                                        text: "Tap (Tile):",
                                        style: GoogleFonts.delius(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: "",
                                          style: GoogleFonts.delius(
                                            fontSize: 15,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    "This will bring you to a new page that provides"),
                                            TextSpan(
                                                text: " extra information ",
                                                style: GoogleFonts.delius(
                                                    color: Colors.pinkAccent)),
                                            TextSpan(
                                                text:
                                                    "about this particular location"),
                                          ]),
                                    ),
                                    Container(height: 20),
                                    Text.rich(
                                      TextSpan(
                                        text: "Swipe (Tile):",
                                        style: GoogleFonts.delius(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: "",
                                          style: GoogleFonts.delius(
                                            fontSize: 15,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: "This "),
                                            TextSpan(
                                                text: "removes ",
                                                style: GoogleFonts.delius(
                                                    color: Colors.pinkAccent)),
                                            TextSpan(
                                                text:
                                                    "the particular location from this collection of bookmarks."),
                                          ]),
                                    ),
                                  ],
                                )),
                                height: 420,
                                width: 250),
                            Container(height: 10),
                            TextButton(
                              child: Text(
                                "Close",
                                style: GoogleFonts.itim(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  confused = false;
                                });
                              },
                            ),
                            Container(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  visible: confused,
                )
              ]));
        });
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
  return Padding(
      padding: EdgeInsets.fromLTRB(45, 10, 45, 10),
      child: SizedBox(
        child: Card(
          child: TextButton(
            child: Text(name,
                style:
                    GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
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
