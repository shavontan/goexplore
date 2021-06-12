import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'ProfilePage.dart';
import 'AdventurePage.dart';
import 'CustomWidgets/UserPoints.dart';
import 'Categories.dart';
import 'PointsCollection.dart';

import './swipe.dart';

import 'AdventureStack.dart';


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
    return MaterialApp(home: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text('HomePage', style: TextStyle(color: Colors.black)),
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
                      icon: Icon(Icons.account_circle, color: Colors.white),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
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
                            MaterialPageRoute(builder: (context) => AdventureStack())
                            );
                          },
                        )
                      ]),

                    Container(height: 100),

                      TextButton(
                        child: Text('Scan for points',
                          style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.amber),),

                        // ADDED THIS: ----------------------------------------------------------------------------------------------------  ***

                        onPressed: () {
                          // if (anonymous user) {
                          //   POPUP MESSAGE OR GO TO SIGNUP/LOGIN
                          // } else {
                          _scan();
                        },
                      ),

                      //Container(height: 10),

                      Visibility(
                        child: TextButton(
                          child: Text('Redeem Points now',
                            style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.amber),),

                          // ADDED THIS: ----------------------------------------------------------------------------------------------------  ***

                          onPressed: () {
                            if (qrCode.runtimeType != String || !qrCode.contains("G0ExPl0rE_")) {
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
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => Collection(qrResult: qrCode)));
                            }
                          },
                        ),
                        visible: hasData,
                      ),


                  UserPoints(points: snapshot.data as int,)

                  // ADD POINTS WIDGET ---------------------------------------------------------------------------------------------------------
                ],
              ),
            );}
        )
        )
    ));
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
