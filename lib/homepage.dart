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
import 'ProfileTracker.dart';
import 'main.dart';

import 'package:back_button_interceptor/back_button_interceptor.dart';

GlobalKey<AdventureStackState> advKey = GlobalKey<AdventureStackState>();

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  String qrCode = 'Unknown';
  bool hasData = false;
  bool confused = false;

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
                      icon: Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          confused = true;
                        });
                      }),
                  IconButton(
                      icon: Icon(Icons.account_circle, color: Colors.white),
                      onPressed: () {
                        if (isLoggedIn()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              ProfilePage()
                                  // ChangeNotifierProvider(
                                  //     create: (context) => ProfileTracker(),
                                  //     child: ProfilePage()),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        }
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                      })
                ]),
            body: FutureBuilder(
                future: getPoints(),
                builder: (context, snapshot) {
                  return Stack(children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(height: 30),

                          Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Opacity(
                                  child: ConstrainedBox(
                                    child: ClipRRect(
                                      child: Image.asset(
                                          'assets/images/SGbackground.png'),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    constraints: BoxConstraints(
                                        maxWidth: 300, maxHeight: 200),
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Categories()));
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdventureStack(key: advKey)));
                                  },
                                )
                              ]),

                          Container(height: 100),

                          TextButton(
                            child: Text(
                              'Scan for points',
                              style: GoogleFonts.raviPrakash(
                                  fontSize: 20, color: Colors.amber),
                            ),

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
                                          content: Text(
                                              "You currently do not have an account. \n\nLog in or sign up now to start earning points!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              },
                                              child: Text("Proceed"),
                                            )
                                          ]);
                                    });
                              } else {
                                await _scan();
                                if (!qrCode.contains("G0ExPl0rE")) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text("Invalid QR code"),
                                            actions: <Widget>[
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"),
                                              )
                                            ]);
                                      });
                                } else {
                                  List<String> substrings = qrCode.split("(_)");
                                  bool onAdventure =
                                      await validAdventureLocation(
                                          substrings.elementAt(2));

                                  if (substrings.length != 4) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text("Invalid QR code"),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                )
                                              ]);
                                        });
                                  } else if (await alreadyVisitedToday(
                                      substrings.elementAt(2))) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  "Already scanned QR code"),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                )
                                              ]);
                                        });
                                  } else if (await isValidLocation(
                                      substrings.elementAt(1),
                                      substrings.elementAt(2))) {
                                    bool onAdventure =
                                        await validAdventureLocation(
                                            substrings.elementAt(2));
                                    updateHistory(substrings.elementAt(2),
                                        substrings.elementAt(3));
                                    removeAdventureLocation(
                                        substrings.elementAt(2));
                                    updateVisitedToday(substrings.elementAt(2));

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Collection(
                                                location:
                                                    substrings.elementAt(2),
                                                URL: substrings.elementAt(3),
                                                onAdventure: onAdventure)));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text("Invalid QR code"),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                )
                                              ]);
                                        });
                                  }
                                }
                              }
                            },
                          ),

                          UserPoints(
                            points: userPoints.points,
                          )

                          // ADD POINTS WIDGET ---------------------------------------------------------------------------------------------------------
                        ],
                      ),
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
                                            text: "Profile Page",
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
                                                        "Navigate to your profile page by "),
                                                TextSpan(
                                                    text: "clicking ",
                                                    style: GoogleFonts.delius(
                                                        color:
                                                            Colors.pinkAccent)),
                                                TextSpan(
                                                    text:
                                                        "on the icon on the "),
                                                TextSpan(
                                                    text:
                                                        "right of the App Bar",
                                                    style: GoogleFonts.delius(
                                                        color:
                                                            Colors.pinkAccent)),
                                                TextSpan(
                                                    text:
                                                        ". (Top right of the screen)"),
                                              ]),
                                        ),
                                        Container(
                                          height: 5,
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
                                                        "Profile Page contains all the user information, such as: user settings, user's bookmarks, history page and Points redemption"),
                                              ]),
                                        ),
                                        Container(height: 20),
                                        Text.rich(
                                          TextSpan(
                                            text: "Yes, I have an idea",
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
                                                        "Select this option when you have a "),
                                                TextSpan(
                                                    text:
                                                        "general idea of where you want to travel to",
                                                    style: GoogleFonts.delius(
                                                        color:
                                                            Colors.pinkAccent)),
                                                TextSpan(
                                                    text:
                                                        ". (For example, you would like to visit a restaurant that serves Chinese food at an affordable price)"),
                                              ]),
                                        ),
                                        Container(height: 20),
                                        Text.rich(
                                          TextSpan(
                                            text: "No, take me on an adventure",
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
                                                        "Select this option when you "),
                                                TextSpan(
                                                    text: "feel adventurous",
                                                    style: GoogleFonts.delius(
                                                        color:
                                                            Colors.pinkAccent)),
                                                TextSpan(
                                                    text:
                                                        ". You don't have a particular location you want to visit and would like to explore the lesser-known places in Singapore."),
                                              ]),
                                        ),
                                        Container(height: 5),
                                        Text.rich(
                                          TextSpan(
                                            text: "",
                                            style: GoogleFonts.delius(
                                              fontSize: 12,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      "We hand-pick a variety of locations in Singapore that we believe are not well-known and would like to bring more attention! ",
                                                  style: GoogleFonts.delius(
                                                      color: Colors.black45)),
                                            ],
                                          ),
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
                                                      "Take note that scanning QR codes of adventure locations while you are on that adventure will earn you "),
                                              TextSpan(
                                                text: "double the points",
                                                style: GoogleFonts.delius(
                                                    color: Colors.pinkAccent),
                                              ),
                                              TextSpan(text: "!")
                                            ],
                                          ),
                                        ),
                                        Container(height: 20),
                                        Text.rich(
                                          TextSpan(
                                            text: "Scanning QR Code",
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
                                                        "When you have arrived at a location that is recommended by us, "),
                                                TextSpan(
                                                    text: "scan the QR code ",
                                                    style: GoogleFonts.delius(
                                                        color:
                                                            Colors.pinkAccent)),
                                                TextSpan(
                                                    text: "to earn points."),
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
                                                        "Points can be exchanged for vouchers and promotions by going to ProfilePage > Manage your points."),
                                              ]),
                                        ),
                                        Container(
                                          height: 5,
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
                                                        "Take note that you can only scan that particular QR code once a day."),
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
                })));
  }
}

Future<int> getPoints() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    return value['points'];
  });
}

Future<bool> isValidLocation(String category, String locationName) async {
  bool valid = false;
  await FirebaseFirestore.instance
      .collection(category)
      .doc(locationName)
      .get()
      .then((doc) {
    if (doc.exists) {
      valid = true;
    }
  });
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

  bool visited = await docRef.get().then((doc) {
    if (doc.exists) {
      return true;
    }
    return false;
  });

  if (visited) {
    List<dynamic> times = await docRef.get().then((doc) {
      return doc['dates'];
    });
    times.add(Timestamp.now());
    docRef.update({'dates': times});
  } else {
    docRef.set({
      'name': locationName,
      'imageURL': imageURL,
      'dates': [Timestamp.now()]
    });
  }
}

// update visitedToday after scanning
void updateVisitedToday(String locationName) async {
  String uid = await getCurrentUID();
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'visitedToday': FieldValue.arrayUnion([locationName])
  });
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
      .then((doc) {
    return doc['visitedToday'];
  });
}

Future<bool> alreadyVisitedToday(String locationName) async {
  List<dynamic> visitedToday = await locationsVisitedToday();
  return visitedToday.contains(locationName);
}
