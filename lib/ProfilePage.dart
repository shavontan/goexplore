import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './history.dart';
import 'BookmarkList.dart';
import 'EditProfile.dart';
import 'PointsRedemptionPage.dart';
import 'ProfileTracker.dart';
import 'package:provider/provider.dart';
import 'main.dart';

// class ProfilePage extends StatefulWidget {
//   //const ProfilePage({Key key}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

class ProfilePage extends StatelessWidget {
// class _ProfilePageState extends State<ProfilePage> {
  // GET DATA FROM STORAGE

  @override
  Widget build(BuildContext context) {

    final trackProfile = context.watch<ProfileTracker>();
    return FutureBuilder(
        future: Future.wait([getUsername(), getProfilePic(), getBackground()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
                  Stack(overflow: Overflow.visible, children: [
                    Image.network(trackProfile.backgroundPic,
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.cover
                    ),
                    // Image.asset('assets/images/SGbackground.png', // Custom backdrop picture
                    //     height: MediaQuery.of(context).size.height / 3,
                    //     fit: BoxFit.cover),
                    Positioned(
                      child: CircleAvatar(
                        backgroundImage:
                        NetworkImage(trackProfile.profilePic),
                        //AssetImage('assets/images/SGbackground.png'), // Profile picture
                        radius: 80.0,
                      ),
                      top: MediaQuery.of(context).size.height / 3 - 100,
                      left: (MediaQuery.of(context).size.width - 160) / 2,
                    ),
                    Positioned(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ),
                  ]),
                  Container(height: 70),
                  Text(trackProfile.username, style: GoogleFonts.cabinSketch(fontSize: 30)),
                  Container(height: 25),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Edit Profile',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      EditProfile(),
                                      ));
                            },
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Your bookmarks',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => BookmarkList())
                              );
                            },
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Manage your points',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => PointsRedemptionPage()));
                            },
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('History',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => History(),),);
                            },
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Log out',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () async {

                              await signOut();
                              // await anonymousSignIn();


                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => MyApp2()),
                              //         (Route<dynamic> route) => false);

                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp2()));
                            },
                          )),
                    ),
                  ),
                ])
              //)
            )
        )
    );});
  }
}

Future<String> getUsername() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['username'];});
}

Future<String> getProfilePic() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['profilePic'];});
}

Future<String> getBackground() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['backgroundPic'];});
}




