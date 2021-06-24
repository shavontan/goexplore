import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'ProfilePage.dart';
import 'AdventurePage.dart';
import 'CustomWidgets/UserPoints.dart';
import 'Categories.dart';
import 'PointsCollection.dart';
import 'package:provider/provider.dart';
import 'CustomWidgets/PointTracker.dart';


import './swipe.dart';

import 'AdventureStack.dart';
import 'main.dart';

GlobalKey<AdventureStackState> advKey = GlobalKey<AdventureStackState>();

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCode = 'Unknown';
  bool hasData = false;

  Future<void> _scan() async {
    var codeScanner = await BarcodeScanner.scan();
    setState(() {
      qrCode = codeScanner;
      hasData = true;
    });

  }

  @override
  Widget build(BuildContext context) {
    final userPoints = context.watch<TrackPoints>();

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text('HomePage', style: TextStyle(color: Colors.black)),
                backgroundColor: Color(0xB6C4CAE8),
                elevation: 0.0,
                // leading: IconButton(
                //   icon: Icon(Icons.arrow_back, color: Colors.white),
                //   onPressed: () {
                //     Navigator.pop(context, false);
                //   },
                // ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.account_circle, color: Colors.white),
                      onPressed: () {
                        if (isLoggedIn()) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp(),),);
                        }
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                      })
                ]),
            body: FutureBuilder(
                future: getPoints(),
                builder: (context, snapshot) {
                  return SingleChildScrollView(
                    child: Column(
                    children: [
                      Container(height: 30),

                      Stack(alignment: AlignmentDirectional.center, children: [
                      Opacity(
                        child: ConstrainedBox(
                          child: ClipRRect(
                            child: Image.asset('assets/images/SGbackground.png'),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          constraints:
                            BoxConstraints(maxWidth: 300, maxHeight: 200),
                        ),
                        opacity: 0.5,
                      ),
                      ConstrainedBox(
                        child: Text(
                        'Do you know what you want to do today?',
                        style: GoogleFonts.raviPrakash(
                          fontSize: 40,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        ),
                        constraints: BoxConstraints(maxWidth: 300),
                      ),
                    ]),

                    Container(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          child: ConstrainedBox(
                            child: Text(
                              'Yes, I have an idea!',
                              style: GoogleFonts.raviPrakash(
                                  fontSize: 20, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            constraints: BoxConstraints(maxWidth: 130),
                          ),
                          onPressed: () {



                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Categories()));
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Swipe('recreation', 2, []))); // temp path, to delete
                          },
                        ),
                        TextButton(
                          child: ConstrainedBox(
                            child: Text(
                              'No, take me on an adventure!',
                              style: GoogleFonts.raviPrakash(
                                  fontSize: 20, color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                            constraints: BoxConstraints(maxWidth: 130),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AdventureStack(key: advKey))
                            );
                          },
                        )
                      ]),

                    Container(height: 100),

                      TextButton(
                        child: Text('Scan for points',
                          style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.amber),),

                        // ADDED THIS: ----------------------------------------------------------------------------------------------------  ***

                        onPressed: () async {
                          // if (anonymous user) {
                          //   POPUP MESSAGE OR GO TO SIGNUP/LOGIN
                          // } else {
                          if (!isLoggedIn()) {
                            showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Uh Oh!"),
                                  content: Text("You currently don't have an account. \n\nLog in or sign up now to start earning points!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                      Navigator.pop(context);
                                      },
                                      child: Text("Cancel", style: TextStyle(color: Colors.grey)),),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => MyApp()));
                                      },
                                    child: Text("Proceed"),)
                              ]);
                          });}

                          else {
                          await _scan();
                          if (!qrCode.contains("G0ExPl0rE")) {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(title: Text("Invalid QR code"), actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),)
                              ]);
                            }
                            );
                          } else {
                            List<String> substrings = qrCode.split("(_)");
                            bool onAdventure = await validAdventureLocation(substrings.elementAt(2));

                            if (substrings.length != 4) {
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(title: Text("Invalid QR code"), actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),)
                                ]);
                              }
                              );
                            } else if (await alreadyVisitedToday(substrings.elementAt(2))) {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(title: Text("Already scanned QR code"), actions: <Widget>[
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),)
                              ]);
                            }
                          );
                          } else if (await isValidLocation(substrings.elementAt(1), substrings.elementAt(2))) {
                          bool onAdventure = await validAdventureLocation(substrings.elementAt(2));
                          updateHistory(substrings.elementAt(2), substrings.elementAt(3));
                          removeAdventureLocation(substrings.elementAt(2));
                          updateVisitedToday(substrings.elementAt(2));

                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  Collection(location: substrings.elementAt(2), URL: substrings.elementAt(3), onAdventure: onAdventure)));


                          } else {
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(title: Text("Invalid QR code"), actions: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                child: Text("OK"),)
                                ]);
                            });
                          }
                        }}
                        },
                      ),

                      UserPoints(points: userPoints.points,)

                  // ADD POINTS WIDGET ---------------------------------------------------------------------------------------------------------
                ],
              ),
            );
                }
        )
        )
    );
  }
}

Future<int> getPoints() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['points'];});
}


Future<bool> isValidLocation(String category, String locationName) async {
  bool valid = false;
  await FirebaseFirestore.instance
      .collection(category)
      .doc(locationName)
      .get()
      .then((doc) {if (doc.exists) {
    valid = true;
  }});
  return valid;
}

// after scanning (1)
Future<bool> validAdventureLocation(String locationName) async {
  List<dynamic> advLocations = await getAdvLocations();
  bool valid = advLocations.contains(locationName);
  return valid;
}
// (2)
void removeAdventureLocation(String locationName) async {
  String uid = await getCurrentUID();
  List<dynamic> advLocations = await getAdvLocations();
  if (advLocations.contains(locationName)) {
    advLocations.remove(locationName);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'adventureLocations': advLocations});
  }
}

void updateHistory(String locationName, String imageURL) async {
  String uid = await getCurrentUID();
  DocumentReference docRef = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('history')
      .doc(locationName);

  bool visited = await docRef
      .get()
      .then((doc) {
    if (doc.exists) {
      return true;
    } return false;
  });

  if (visited) {
    List<dynamic> times = await docRef.get().then((doc) {return doc['dates'];});
    times.add(Timestamp.now());
    docRef.update({'dates':times});
  } else {
    docRef.set({'name':locationName, 'imageURL':imageURL, 'dates':[Timestamp.now()]});
  }
}

// update visitedToday after scanning
void updateVisitedToday(String locationName) async {
  String uid = await getCurrentUID();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'visitedToday': FieldValue.arrayUnion([locationName])});
}

// void resetVisitedToday() async {
//   QuerySnapshot qs = await FirebaseFirestore.instance
//       .collection('users')
//       .get();
//   qs.docs.forEach((doc) async {
//     doc.reference.update({'visitedToday':[]});
//   });
// }

Future<List<dynamic>> locationsVisitedToday() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc['visitedToday'];});
}

Future<bool> alreadyVisitedToday(String locationName) async {
  List<dynamic> visitedToday = await locationsVisitedToday();
  return visitedToday.contains(locationName);
}





