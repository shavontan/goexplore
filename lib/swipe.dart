import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/SwipingTile.dart';
import 'Return.dart';
import 'flutterfire.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:random_color/random_color.dart';
import './bookmarksbar.dart';

import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';

// // import 'package:geolocation/geolocation.dart';
// // import 'package:location/location.dart';
//
// // beautiful popup imports
// import 'package:flutter_beautiful_popup/main.dart';
// import 'package:flutter_beautiful_popup/templates/Authentication.dart';
// import 'package:flutter_beautiful_popup/templates/BlueRocket.dart';
// import 'package:flutter_beautiful_popup/templates/Camera.dart';
// import 'package:flutter_beautiful_popup/templates/Coin.dart';
// import 'package:flutter_beautiful_popup/templates/Common.dart';
// import 'package:flutter_beautiful_popup/templates/Fail.dart';
// import 'package:flutter_beautiful_popup/templates/Geolocation.dart';
// import 'package:flutter_beautiful_popup/templates/Gift.dart';
// import 'package:flutter_beautiful_popup/templates/GreenRocket.dart';
// import 'package:flutter_beautiful_popup/templates/Notification.dart';
// import 'package:flutter_beautiful_popup/templates/OrangeRocket.dart';
// import 'package:flutter_beautiful_popup/templates/OrangeRocket2.dart';
// import 'package:flutter_beautiful_popup/templates/RedPacket.dart';
// import 'package:flutter_beautiful_popup/templates/Success.dart';
// import 'package:flutter_beautiful_popup/templates/Term.dart';
// import 'package:flutter_beautiful_popup/templates/Thumb.dart';

import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/permission/permission_handler.dart';

// Link to DB

class Swipe extends StatefulWidget {
  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  Swipe(this.category, this.price, this.tags, this.dist);

  @override
  _SwipeState createState() =>
      _SwipeState(this.category, this.price, this.tags, this.dist);
}

final globalKey = GlobalKey<BookmarksBarState>();

class _SwipeState extends State<Swipe> {
  // Dynamically load _Cards from database

  final String category;
  final int price;
  final List<String> tags;
  final double dist;
  bool confused = false;

  _SwipeState(this.category, this.price, this.tags, this.dist);

  List<Widget> _Cards = [];

  @override
  Widget build(BuildContext context) {
    // Stack of _Cards that can be swiped. Set width, height, etc here.

    return Container(

        // Important to keep as a stack to have overlay of _Cards.

        child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: getLocationStreamSnapshots(
                context, this.category, this.price, this.tags, this.dist),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final randomDocs = snapshot.data!..shuffle();
              final length = randomDocs.length;

              for (int i = 0; i < length; i++) {
                _Cards.add(_newCard(doc: randomDocs[i]));
              }

              return Scaffold(
                // appBar: AppBar(
                //   title: Text("Let's Explore!", style: TextStyle(color: Colors.black)),
                //   backgroundColor: Color(0xB6C4CAE8),
                //   elevation: 0.0,
                //   leading: IconButton(
                //     icon: Icon(Icons.arrow_back, color: Colors.white),
                //     onPressed: () {
                //       Navigator.pop(context, false);
                //     },
                //   ),
                //   // actions: [
                //   //   IconButton(
                //   //       icon: Icon(Icons.account_circle, color: Colors.white),
                //   //       onPressed: () {
                //   //         Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                //   //       })
                //   // ],
                // ),
                body: Stack(children: [
                  Return(),
                  ..._Cards,
                ]),
                //bottomNavigationBar: SingleChildScrollView(child: BookmarksBar(key: globalKey), scrollDirection: Axis.horizontal,),
              );
            })
        // child: Stack(
        //   children: _Cards,
        // ),
        );
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

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    widget.doc['imageList'].forEach((item) {
      images.add(item as String);
    });

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
                List<dynamic> bookmarks = await getBookmarks();
                String uid = await getCurrentUID();
                final List<bool> isSelected = globalKey.currentState!.isSelected;
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
                globalKey.currentState!.resetSelection();
              }

            // onSwipeRight, left, up, down, cancel, etc...
          ),
          Container(
              child: Column(children: [
                Container(height: MediaQuery.of(context).size.height / 1.08),
                SingleChildScrollView(
                  child: BookmarksBar(key: globalKey),
                  scrollDirection: Axis.horizontal,
                ),
              ])),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
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


// Stream<QuerySnapshot> getLocationStreamSnapshots(
//     BuildContext context, String category, int price, List<String> tags) async* {
//
//   yield* FirebaseFirestore.instance
//       .collection(category)
//       .where('price', isLessThanOrEqualTo: price)
//       .snapshots();
//
// }

Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots(
    BuildContext context,
    String category,
    int price,
    List<String> tags,
    double dist) async {
  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection(category)
      .where('price', isLessThanOrEqualTo: price)
      .get();
  //
  // Stream<QueryDocumentSnapshot> docsStream = Stream.fromIterable(qs
  //     .docs
  //     .where((d) => checkTags(d['tags'], tags)));

  Iterable<QueryDocumentSnapshot> docsStream =
      qs.docs.where((d) => checkTags(d['tags'], tags));

  // Init PermissionHandler
  // bool status;
  // PermissionHandler permissionHandler = PermissionHandler();
  // // Request location permissions
  // status = await permissionHandler.requestLocationPermission();
  //
  // if (!status) {
  //   return docsStream.toList();
  // }
  //
  // FusedLocationProviderClient locationService = FusedLocationProviderClient();
  // LocationRequest locationRequest = new LocationRequest();
  // locationRequest.numUpdates = 1;
  //
  // await locationService.requestLocationUpdates(locationRequest);
  // Location curr = await locationService.getLastLocation();
  // double lat = curr.latitude;
  // double long = curr.longitude;
  //
  //
  // List<QueryDocumentSnapshot> docsList = [];
  // for (QueryDocumentSnapshot d in docsStream) {
  //   if(await checkDist(d, dist, status, lat, long)) {
  //     docsList.add(d);
  //   }
  // }
  //
  // return docsList;

  return docsStream.toList();
}

bool checkTags(List<dynamic> doc, List<String> tag) {
  if (tag.contains('Indoor') && tag.contains('Outdoor')) {
    tag.remove('Indoor');
    tag.remove('Outdoor');
  }

  if (tag.contains('Physical') && tag.contains('Leisure')) {
    tag.remove('Physical');
    tag.remove('Leisure');
  }

  if (tag.any((item) => doc.contains(item)) && doc.length > 0 ||
      tag.length == 0) {
    return true;
  } else {
    return false;
  }
}

Future<bool> checkDist(QueryDocumentSnapshot doc, double requiredDist,
    bool status, double lat, double long) async {
  List<gc.Location> locations = await gc.locationFromAddress(doc['address']);
  double distanceInKM = Geolocator.distanceBetween(
          lat, long, locations[0].latitude, locations[0].longitude) *
      0.001;
  return distanceInKM < requiredDist;
}

// Future<String> getImageURL(String locationName) async {
//   String fileName = locationName + ".jpg";
//   final ref = FirebaseStorage.instance.ref().child()
// }
