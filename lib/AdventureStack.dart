import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_indexed_stack/lazy_indexed_stack.dart';
import 'CustomWidgets/AdventureTile.dart';
import './AdventurePage.dart';
import 'Return.dart';
import 'homepage.dart';
import 'package:google_fonts/google_fonts.dart';

// GlobalKey<AdventureState> advKey = GlobalKey<AdventureState>();

class AdventureStack extends StatefulWidget {
  const AdventureStack({Key? key}) : super(key: key);

  @override
  AdventureStackState createState() => AdventureStackState();
}

class AdventureStackState extends State<AdventureStack> {
  List<Widget> _stack = [];
  int _index = 0;
  void nextCard() => setState(() { _index += 1; first = false;});
  bool confused = false;

  bool first = true;
  List<QueryDocumentSnapshot> finalList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: getAdventureLocations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Adventure', style: TextStyle(color: Colors.black)),
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

          if (first) {
            finalList.addAll(randomDocs);
          }
          // for(int i = 0; i < finalList.length; i++) {
          //   print(finalList[i]['name']);
          // }

          return Scaffold(
              body: Stack(children: [
                SingleChildScrollView(
                    child: Stack(children: [
                      SizedBox(
                          child:
                          LazyIndexedStack(
                              reuse: false,
                              index: _index,
                              itemCount: finalList.length,
                              itemBuilder: (c, i) {
                                  if (i == finalList.length-1) {
                                  return Return();
                                  }

                                  List<String> imageList = [];
                                  for (int j = 0; j < finalList[i]['imageList'].length; j++) {
                                    imageList.add(finalList[i]['imageList'][j]);
                                  }

                                  return AdventureTile(
                                            imageURLs: imageList,
                                            name: finalList[i]['name'],
                                            address: finalList[i]['address'],
                                            description: finalList[i]['description'],
                                            imageURL_360: finalList[i]['360image']);

                              },
                          ),
                          height: MediaQuery.of(context).size.height),
                      Positioned(
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        top: 20,
                        left: 0,
                      ),
                      Positioned(
                        child: IconButton(
                            icon: Icon(Icons.help_outline, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                confused = true;
                                first = false;
                              });
                            }),
                        right: 20,
                        top: 20,
                      ),
                      Visibility(
                        child: Positioned.fill(
                          child: Align(
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
                                                            "This page displays adventure locations in an interactive way."),
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
                                                            "These locations are specially hand-picked to ensure the user gets to explore lesser-known sites in Singapore. User will earn double the points for visiting an adventure location, as compared to a normal location recommended by our system. "),
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
                                                                color: Colors.pinkAccent)),
                                                        TextSpan(text: "and "),
                                                        TextSpan(
                                                            text: "disables ",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.pinkAccent)),
                                                        TextSpan(
                                                            text:
                                                            "the ability to interact with the "),
                                                        TextSpan(
                                                            text: "360-view image",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.pinkAccent)),
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
                                                                color: Colors.pinkAccent)),
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
                                                                color: Colors.pinkAccent)),
                                                        TextSpan(text: "and "),
                                                        TextSpan(
                                                            text: "deactivates ",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.pinkAccent)),
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
                                                            text: "This screen provides "),
                                                        TextSpan(
                                                            text: "additional information",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.pinkAccent)),
                                                        TextSpan(
                                                            text:
                                                            ", like: name of location, a scrollable list of images, the location's address and additional written details."),
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
                                                            "To advance to the next adventure location/page, user must select: either "),
                                                        TextSpan(
                                                            text: "'No, not today'",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.red)),
                                                        TextSpan(text: ", or "),
                                                        TextSpan(
                                                            text: "'Let's Go!'",
                                                            style: GoogleFonts.delius(
                                                                color: Colors.green)),
                                                        TextSpan(text: "."),
                                                      ]),
                                                ),
                                                Container(height: 5),
                                                Text.rich(
                                                  TextSpan(
                                                      text: "",
                                                      style: GoogleFonts.delius(
                                                          fontSize: 12,
                                                          color: Colors.black38),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                            "'No, Not Today' – we will recommend a new adventure location, as this one does not suit your preferences."),
                                                      ]),
                                                ),
                                                Container(height: 5),
                                                Text.rich(
                                                  TextSpan(
                                                      text: "",
                                                      style: GoogleFonts.delius(
                                                          fontSize: 12,
                                                          color: Colors.black38),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text:
                                                            "'Let's Go!' – This adventure location will be saved to the user and when you scan the location's QR code, you will earn double the points!"),
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
                                          first = false;
                                        });
                                      },
                                    ),
                                    Container(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        visible: confused,
                      )
                    ])),
                // Adventure(_stack, key: advKey),
              ]));
        });
  }
}

Future<List<QueryDocumentSnapshot>> getAdventureLocations() async {
  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection('adventure')
      .get();
      return qs.docs.toList();
}

// class AdventureStackState extends State<AdventureStack> {
//   List<Widget> _stack = [];
//   int _index = 0;
//   void nextCard() => setState(() => _index += 1);
//   bool confused = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: getAdventureLocationStreamSnapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Scaffold(
//                 appBar: AppBar(
//                   title: Text('Adventure', style: TextStyle(color: Colors.black)),
//                   backgroundColor: Color(0xB6C4CAE8),
//                   elevation: 0.0,
//                   leading: IconButton(
//                     icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
//                     onPressed: () {
//                       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
//                       Navigator.pop(context);
//                     },
//                   ),),
//                 body: Center(child: CircularProgressIndicator()),
//                 backgroundColor: Colors.white);
//           }
//
//           final randomDocs = snapshot.data!.docs..shuffle();
//           for (int i = 0; i < randomDocs.length; i++) {
//             QueryDocumentSnapshot doc = randomDocs[i];
//             List<String> imagelist = [];
//             doc['imageList'].forEach((item) {
//               imagelist.add(item);
//             });
//
//
//             _stack.add(AdventureTile(
//                 imageURLs: imagelist,
//                 name: doc['name'],
//                 address: doc['address'],
//                 description: doc['description'],
//                 imageURL_360: doc['360image']));
//           }
//           _stack.add(Return());
//
//           return Scaffold(
//               body: Stack(children: [
//             SingleChildScrollView(
//                 child: Stack(children: [
//               SizedBox(
//                   child:
//                   IndexedStack(children: this._stack, index: _index),
//                   height: MediaQuery.of(context).size.height),
//               Positioned(
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               Positioned(
//                 child: IconButton(
//                     icon: Icon(Icons.help_outline, color: Colors.white),
//                     onPressed: () {
//                       setState(() {
//                         confused = true;
//                       });
//                     }),
//                 right: 20,
//                 top: 20,
//               ),
//               Visibility(
//                 child: Positioned.fill(
//                   child: Align(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(15.0),
//                       child: Container(
//                         color: Colors.white,
//                         height: 500,
//                         width: 275,
//                         child: Column(
//                           children: [
//                             Container(height: 10),
//                             SizedBox(
//                                 child: SingleChildScrollView(
//                                     child: Column(
//                                   children: [
//                                     Container(height: 10),
//                                     Text.rich(
//                                       TextSpan(
//                                         text: "Features about this page",
//                                         style: GoogleFonts.delius(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text:
//                                                     "This page displays adventure locations in an interactive way."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text:
//                                                     "These locations are specially hand-picked to ensure the user gets to explore lesser-known sites in Singapore. User will earn double the points for visiting an adventure location, as compared to a normal location recommended by our system. "),
//                                           ]),
//                                     ),
//                                     Container(height: 50),
//                                     Text.rich(
//                                       TextSpan(
//                                         text: "Double Tap",
//                                         style: GoogleFonts.delius(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(text: "This "),
//                                             TextSpan(
//                                                 text: "enables ",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(text: "and "),
//                                             TextSpan(
//                                                 text: "disables ",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(
//                                                 text:
//                                                     "the ability to interact with the "),
//                                             TextSpan(
//                                                 text: "360-view image",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(text: "."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(text: "Take note: the "),
//                                             TextSpan(
//                                                 text: "Lock Icon ",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(
//                                                 text:
//                                                     "(RED/GREEN) is a visual indicator of the current state of 360-view image (whether it is enabled or disabled). When the lock is red, interactivity is "),
//                                             TextSpan(
//                                                 text: "disabled",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.red)),
//                                             TextSpan(
//                                                 text:
//                                                     ", and when it is green, interactivity is "),
//                                             TextSpan(
//                                                 text: "enabled",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.green)),
//                                             TextSpan(text: "."),
//                                           ]),
//                                     ),
//                                     Container(height: 20),
//                                     Text.rich(
//                                       TextSpan(
//                                         text: "Press and hold",
//                                         style: GoogleFonts.delius(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(text: "This "),
//                                             TextSpan(
//                                                 text: "activates ",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(text: "and "),
//                                             TextSpan(
//                                                 text: "deactivates ",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(
//                                                 text:
//                                                     "the pop-up screen that provides additional information of this particular location."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text: "This screen provides "),
//                                             TextSpan(
//                                                 text: "additional information",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.pinkAccent)),
//                                             TextSpan(
//                                                 text:
//                                                     ", like: name of location, a scrollable list of images, the location's address and additional written details."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                             fontSize: 15,
//                                           ),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text:
//                                                     "To advance to the next adventure location/page, user must select: either "),
//                                             TextSpan(
//                                                 text: "'No, not today'",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.red)),
//                                             TextSpan(text: ", or "),
//                                             TextSpan(
//                                                 text: "'Let's Go!'",
//                                                 style: GoogleFonts.delius(
//                                                     color: Colors.green)),
//                                             TextSpan(text: "."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                               fontSize: 12,
//                                               color: Colors.black38),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text:
//                                                     "'No, Not Today' – we will recommend a new adventure location, as this one does not suit your preferences."),
//                                           ]),
//                                     ),
//                                     Container(height: 5),
//                                     Text.rich(
//                                       TextSpan(
//                                           text: "",
//                                           style: GoogleFonts.delius(
//                                               fontSize: 12,
//                                               color: Colors.black38),
//                                           children: <TextSpan>[
//                                             TextSpan(
//                                                 text:
//                                                     "'Let's Go!' – This adventure location will be saved to the user and when you scan the location's QR code, you will earn double the points!"),
//                                           ]),
//                                     ),
//                                   ],
//                                 )),
//                                 height: 420,
//                                 width: 250),
//                             Container(height: 10),
//                             TextButton(
//                               child: Text(
//                                 "Close",
//                                 style: GoogleFonts.itim(
//                                   color: Colors.black,
//                                   fontSize: 20,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   confused = false;
//                                 });
//                               },
//                             ),
//                             Container(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 visible: confused,
//               )
//             ])),
//             // Adventure(_stack, key: advKey),
//           ]));
//         });
//   }
// }
//
// // class AdventureStack extends StatelessWidget {
// //   List<Widget> _stack = [];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //
// //     return StreamBuilder<QuerySnapshot>(
// //         stream: getAdventureLocationStreamSnapshots(),
// //         builder: (context, snapshot) {
// //
// //           if (!snapshot.hasData) {
// //             return Center(child: CircularProgressIndicator());
// //           }
// //
// //           final randomDocs = snapshot.data!.docs..shuffle();
// //           for (int i = 0; i < randomDocs.length; i++) {
// //             QueryDocumentSnapshot doc = randomDocs[i];
// //             List<String> imagelist = [];
// //             doc['imageList'].forEach((item) {imagelist.add(item);});
// //             print(doc['name']);
// //             _stack.add(AdventureTile(imageURLs: imagelist, name: doc['name'], address: doc['address'],
// //                 description: doc['description'], imageURL_360: doc['360image']));
// //           }
// //           _stack.add(reloadPage());
// //
// //           return Scaffold(body: Stack(
// //             children: [
// //               Adventure(_stack, key: advKey),
// //               Positioned(
// //                 child: IconButton(
// //                   icon: Icon(Icons.arrow_back, color: Colors.white),
// //                   onPressed: () {
// //                     Navigator.pop(context);
// //                   },
// //                 ),
// //               ),
// //             ]
// //           ));
// //         }
// //     );
// //
// //   }
// //
// // }
//
// Stream<QuerySnapshot> getAdventureLocationStreamSnapshots() async* {
//   yield* FirebaseFirestore.instance.collection('adventure').snapshots();
// }


