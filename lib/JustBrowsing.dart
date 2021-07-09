import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/SwipingTile.dart';
import 'Return.dart';
import 'flutterfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import './bookmarksbar.dart';

// Link to DB

Stopwatch stopwatch = new Stopwatch();

class JustBrowsing extends StatefulWidget {

  JustBrowsing();

  @override
  _JustBrowsingState createState() =>
      _JustBrowsingState();
}

final justBrowsingKey = GlobalKey<BookmarksBarState>();

class _JustBrowsingState extends State<JustBrowsing> {
  // Dynamically load _Cards from database
  bool confused = false;

  List<Widget> _Cards = [];
  List<String> locationNames = [];

  @override
  Widget build(BuildContext context) {
    // Stack of _Cards that can be swiped. Set width, height, etc here.

    return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getAllLocations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('', style: TextStyle(color: Colors.black)),
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

          final randomDocs = snapshot.data!..shuffle();
          final length = randomDocs.length;

          for (int i = 0; i < length; i++) {
            _Cards.add(_newCard(doc: randomDocs[i]));
          }

          stopwatch.reset();
          stopwatch.start();
          return Scaffold(
            body: Stack(children: [
              Return(),
              ..._Cards,
            ]),
            //bottomNavigationBar: SingleChildScrollView(child: BookmarksBar(key: globalKey), scrollDirection: Axis.horizontal,),
          );
        });

  }
}

// class _Card extends StatelessWidget {
//   // Made to distinguish _Cards
//   // Add your own applicable data here
//   final DocumentSnapshot doc;
//   _Card(this.doc);
//   // bool confused = false;
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> images = [];
//     doc['imageList'].forEach((item) {
//       images.add(item as String);
//     });
//
//     return Stack(
//         children: [
//           Swipable(
//           // Set the swipable widget
//           child: SwipingTile(
//             address: doc['address'],
//             description: doc['description'],
//             imageURL_360: doc['360image'],
//             imageURLs: images,
//             name: doc['name'],
//           ),
//           onSwipeDown: (finalPosition) async {
//             List<dynamic> bookmarks = await getBookmarks();
//             String uid = await getCurrentUID();
//             final List<bool> isSelected = globalKey.currentState!.isSelected;
//             for (int i = 0; i < isSelected.length; i++) {
//               if (isSelected[i]) {
//                 String bookmarkName = bookmarks[i] as String;
//                 FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(uid)
//                     .collection(bookmarkName)
//                     .doc(doc['name'])
//                     .set({
//                   'name': doc['name'],
//                   'description': doc['description'],
//                   'price': doc['price'],
//                   'address': doc['address'],
//                   'tags': doc['tags'],
//                   'imageList': doc['imageList'],
//                   '360image': doc['360image'],
//                 });
//               }
//             }
//             globalKey.currentState!.resetSelection();
//           }
//
//           // onSwipeRight, left, up, down, cancel, etc...
//           ),
//           Container(
//           child: Column(children: [
//         Container(height: MediaQuery.of(context).size.height / 1.08),
//         SingleChildScrollView(
//           child: BookmarksBar(key: globalKey),
//           scrollDirection: Axis.horizontal,
//         ),
//       ])),
//       Positioned(
//         child: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context, false);
//           },
//         ),
//       ),
//           // Positioned(
//           //     child: IconButton(
//           //         icon: Icon(Icons.help_outline, color: Colors.white),
//           //         onPressed: () {
//           //           setState(() {
//           //             confused = true;
//           //           });
//           //         }),
//           //     right: 20,
//           //     top: 20
//           // ),
//           // Visibility(
//           //   child: Center(
//           //     child: ClipRRect(
//           //       borderRadius: BorderRadius.circular(15.0),
//           //       child: Container(
//           //         color: Colors.white,
//           //         height: 500,
//           //         width: 275,
//           //         child: Column(
//           //           children: [
//           //             Container(height: 10),
//           //             SizedBox(
//           //                 child: SingleChildScrollView(
//           //                     child: Column(
//           //                       children: [
//           //                         Container(height: 10),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                             text: "Features about this page",
//           //                             style: GoogleFonts.delius(
//           //                                 fontSize: 18,
//           //                                 fontWeight: FontWeight.bold),
//           //                           ),
//           //                         ),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "This page displays recommended locations (suited to user's preferences) in an interactive way."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 50),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                             text: "Double Tap",
//           //                             style: GoogleFonts.delius(
//           //                                 fontSize: 18,
//           //                                 fontWeight: FontWeight.bold),
//           //                           ),
//           //                         ),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(text: "This "),
//           //                                 TextSpan(
//           //                                     text: "enables ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(text: "and "),
//           //                                 TextSpan(
//           //                                     text: "disables ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "the ability to interact with the "),
//           //                                 TextSpan(
//           //                                     text: "360-view image",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(text: "."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(text: "Take note: the "),
//           //                                 TextSpan(
//           //                                     text: "Lock Icon ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "(RED/GREEN) is a visual indicator of the current state of 360-view image (whether it is enabled or disabled). When the lock is red, interactivity is "),
//           //                                 TextSpan(
//           //                                     text: "disabled",
//           //                                     style: GoogleFonts.delius(
//           //                                         color: Colors.red)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     ", and when it is green, interactivity is "),
//           //                                 TextSpan(
//           //                                     text: "enabled",
//           //                                     style: GoogleFonts.delius(
//           //                                         color: Colors.green)),
//           //                                 TextSpan(text: "."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 20),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                             text: "Press and hold",
//           //                             style: GoogleFonts.delius(
//           //                                 fontSize: 18,
//           //                                 fontWeight: FontWeight.bold),
//           //                           ),
//           //                         ),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(text: "This "),
//           //                                 TextSpan(
//           //                                     text: "activates ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(text: "and "),
//           //                                 TextSpan(
//           //                                     text: "deactivates ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "the pop-up screen that provides additional information of this particular location."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "This screen provides "),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "additional information",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     ", like: name of location, a scrollable list of images, the location's address and additional written details."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 20),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                             text: "Swipe left/right",
//           //                             style: GoogleFonts.delius(
//           //                                 fontSize: 18,
//           //                                 fontWeight: FontWeight.bold),
//           //                           ),
//           //                         ),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 12,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "when 360-view is disabled",
//           //                                     style: GoogleFonts.delius(
//           //                                         fontWeight:
//           //                                         FontWeight.bold)),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "Discards this location recommendation as it is "),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "not suited to your preferences",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(text: "."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "We will then automatically provide a new location recommendation for you!"),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 20),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                             text: "Select Bookmarks + Swipe down",
//           //                             style: GoogleFonts.delius(
//           //                                 fontSize: 17,
//           //                                 fontWeight: FontWeight.bold),
//           //                           ),
//           //                         ),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 11,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "when 360-view is disabled",
//           //                                     style: GoogleFonts.delius(
//           //                                         fontWeight:
//           //                                         FontWeight.bold)),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text: "Select ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "the bookmark(s) you wish to save this location to (at the bottom of the screen)."),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "Then when you swipe down, the current location is "),
//           //                                 TextSpan(
//           //                                     text: "saved ",
//           //                                     style: GoogleFonts.delius(
//           //                                         color:
//           //                                         Colors.pinkAccent)),
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "to the bookmark(s) selected."),
//           //                               ]),
//           //                         ),
//           //                         Container(height: 5),
//           //                         Text.rich(
//           //                           TextSpan(
//           //                               text: "",
//           //                               style: GoogleFonts.delius(
//           //                                 fontSize: 15,
//           //                               ),
//           //                               children: <TextSpan>[
//           //                                 TextSpan(
//           //                                     text:
//           //                                     "We will then automatically provide a new location recommendation for you!"),
//           //                               ]),
//           //                         ),
//           //                       ],
//           //                     )),
//           //                 height: 420,
//           //                 width: 250),
//           //             Container(height: 10),
//           //             TextButton(
//           //               child: Text(
//           //                 "Close",
//           //                 style: GoogleFonts.itim(
//           //                   color: Colors.black,
//           //                   fontSize: 20,
//           //                 ),
//           //               ),
//           //               onPressed: () {
//           //                 setState(() {
//           //                   confused = false;
//           //                 });
//           //               },
//           //             ),
//           //             Container(height: 10),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           //   visible: confused,
//           // )
//     ]);
//   }
// }

class _newCard extends StatefulWidget {
  final DocumentSnapshot doc;

  const _newCard({required this.doc});


  @override
  __newCardState createState() => __newCardState();
}

class __newCardState extends State<_newCard> {
  bool confused = false;
  // final globalKey = GlobalKey<BookmarksBarState>();
  String category = "";

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    widget.doc['imageList'].forEach((item) {
      images.add(item as String);
    });

    if (widget.doc['isFnb'] == true) {
      category = "fnb";
    } else {
      category = "recreation";
    }

    return Stack(
        children: [
          Swipable(
            // Set the swipable widget
            child: SwipingTile(
              address: widget.doc['address'],
              description: widget.doc['description'],
              imageURL_360: widget.doc['360image'],
              imageURLs: images,
              name: widget.doc['name'],
            ),
            onSwipeDown: (finalPosition) async {
              stopwatch.stop();
              double time = stopwatch.elapsedMilliseconds / 1000;
              updateAvgTimeSeen(this.category, widget.doc['name'], time);
              stopwatch.reset();
              stopwatch.start();

              List<dynamic> bookmarks = await getBookmarks();
              String uid = await getCurrentUID();
              final List<bool> isSelected = justBrowsingKey.currentState!.isSelected;
              for (int i = 0; i < isSelected.length; i++) {
                if (isSelected[i]) {
                  String bookmarkName = bookmarks[i] as String;
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection(bookmarkName)
                      .doc(widget.doc['name'])
                      .set({
                    'name': widget.doc['name'],
                    'description': widget.doc['description'],
                    'price': widget.doc['price'],
                    'address': widget.doc['address'],
                    'tags': widget.doc['tags'],
                    'imageList': widget.doc['imageList'],
                    '360image': widget.doc['360image'],
                  });
                }
              }
              justBrowsingKey.currentState!.resetSelection();
            },
            onSwipeLeft: (finalPosition) async {
              stopwatch.stop();
              double time = stopwatch.elapsedMilliseconds / 1000;
              updateAvgTimeSeen(this.category, widget.doc['name'], time);
              stopwatch.reset();
              stopwatch.start();
            },
            onSwipeRight: (finalPosition) async {
              stopwatch.stop();
              double time = stopwatch.elapsedMilliseconds / 1000;
              updateAvgTimeSeen(this.category, widget.doc['name'], time);
              stopwatch.reset();
              stopwatch.start();
            },

            onSwipeUp: (finalPosition) async {
              stopwatch.stop();
              double time = stopwatch.elapsedMilliseconds / 1000;
              updateAvgTimeSeen(this.category, widget.doc['name'], time);
              stopwatch.reset();
              stopwatch.start();
            },

            // onSwipeRight, left, up, down, cancel, etc...
          ),
          Container(
              child: Column(children: [
                Container(height: MediaQuery.of(context).size.height / 1.08),
                SingleChildScrollView(
                  child: BookmarksBar(key: justBrowsingKey),
                  scrollDirection: Axis.horizontal,
                ),
              ])),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.lightBlueAccent),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ),
          Positioned(
              child: IconButton(
                  icon: Icon(Icons.help_outline, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      confused = true;
                    });
                  }),
              right: 20,
              top: 20
          ),
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
                                              "This page displays recommended locations (suited to user's preferences) in an interactive way."),
                                        ]),
                                  ),
                                  Container(height: 50),
                                  Text.rich(
                                    TextSpan(
                                      text: "Double Tap",
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
                                              text: "enables ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "and "),
                                          TextSpan(
                                              text: "disables ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the ability to interact with the "),
                                          TextSpan(
                                              text: "360-view image",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: "Take note: the "),
                                          TextSpan(
                                              text: "Lock Icon ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "(RED/GREEN) is a visual indicator of the current state of 360-view image (whether it is enabled or disabled). When the lock is red, interactivity is "),
                                          TextSpan(
                                              text: "disabled",
                                              style: GoogleFonts.delius(
                                                  color: Colors.red)),
                                          TextSpan(
                                              text:
                                              ", and when it is green, interactivity is "),
                                          TextSpan(
                                              text: "enabled",
                                              style: GoogleFonts.delius(
                                                  color: Colors.green)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Press and hold",
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
                                              text: "activates ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "and "),
                                          TextSpan(
                                              text: "deactivates ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the pop-up screen that provides additional information of this particular location."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "This screen provides "),
                                          TextSpan(
                                              text:
                                              "additional information",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              ", like: name of location, a scrollable list of images, the location's address and additional written details."),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Swipe left/right",
                                      style: GoogleFonts.delius(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 12,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "when 360-view is disabled",
                                              style: GoogleFonts.delius(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "Discards this location recommendation as it is "),
                                          TextSpan(
                                              text:
                                              "not suited to your preferences",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "We will then automatically provide a new location recommendation for you!"),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Select Bookmarks + Swipe down",
                                      style: GoogleFonts.delius(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 11,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "when 360-view is disabled",
                                              style: GoogleFonts.delius(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Select ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the bookmark(s) you wish to save this location to (at the bottom of the screen)."),
                                          TextSpan(
                                              text:
                                              "Then when you swipe down, the current location is "),
                                          TextSpan(
                                              text: "saved ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "to the bookmark(s) selected."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "We will then automatically provide a new location recommendation for you!"),
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
        ]);
  }
}

Future<List<double>> getUserTimes(String category) async {
  String uid = await getCurrentUID();
  String field = category + "AvgTime";
  List<dynamic> avgList = await FirebaseFirestore
      .instance.collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[field];});
  List<double> result = [];

  for (int i = 0; i < avgList.length; i++) {
    result.add(avgList[i] as double);
  }

  return result;
}

Future<List<DocumentSnapshot>> getLocations(String category, List<String> locationNames) async {
  List<DocumentSnapshot> result = [];

  for (int i = 0; i < locationNames.length; i++) {
    await FirebaseFirestore.instance
        .collection(category)
        .doc(locationNames[i])
        .get()
        .then((d) {result.add(d);});
  }

  return result;
}

Future<void> updateAvgTimeSeen(String category, String locationName, double time) async {
  String uid = await getCurrentUID();

  String categoryAvgTime = category + "AvgTime";
  String categorySeen = category + "Seen";

  List<dynamic> avgList = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[categoryAvgTime];});

  int locationID = await FirebaseFirestore.instance
      .collection(category)
      .doc(locationName)
      .get()
      .then((doc) {return doc['id'];});

  List<dynamic> seenList = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[categorySeen];});

  seenList[locationID] = seenList[locationID] + 1;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({categorySeen: seenList});

  avgList[locationID] = (avgList[locationID] + time) / seenList[locationID];

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({categoryAvgTime: avgList});
}

Future<List<QueryDocumentSnapshot>> getAllLocations() async {

  QuerySnapshot qsRecreation = await FirebaseFirestore.instance
      .collection('recreation')
      .get();

  List<QueryDocumentSnapshot> recreationDocs = qsRecreation.docs.toList();

  QuerySnapshot qsFnb = await FirebaseFirestore.instance
      .collection('fnb')
      .get();

  List<QueryDocumentSnapshot> fnbDocs = qsFnb.docs.toList();

  recreationDocs.addAll(fnbDocs);

  return recreationDocs;
}


