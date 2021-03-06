import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:goexplore/ProfileTracker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './flutterfire.dart';
import './homepage.dart';
import './SignUpPage.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:panorama/panorama.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'CustomWidgets/PointTracker.dart';
import 'RecommenderSystem.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await anonymousSignIn();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp2()));
  // runApp(Temp());
}

// class Temp extends StatelessWidget {
//   const Temp({Key? key}) : super(key: key);
//
//   Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots() async {
//     var qs = await FirebaseFirestore.instance
//         .collection('recreation')
//         .get();
//
//     return qs.docs.toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home:
//     Scaffold(body:
//     Center(child: TextButton(child: Text("press"),
//       onPressed: () async {
//       List<QueryDocumentSnapshot> list = await getLocationStreamSnapshots();
//       print(list.length);
//       int length = list.length;
//         for (int i = 0; i < length; i++) {
//           print(list[i]['name']);
//         }
//     },)),
//     )
//       ,);
//   }
// }


void resetVisitedToday() async {
  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection('users')
      .get();
  qs.docs.forEach((doc) async {
    doc.reference.update({'visitedToday':[]});
  });
}

Future<bool> shouldUpdateVisitedToday() async {
  String uid = await getCurrentUID();
  DateTime lastLoggedIn = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {
        return doc['lastLoggedIn'].toDate();
      });
  if (lastLoggedIn.day != DateTime.now().day) {
    return true;
  }
  return false;
}

void updateLastLoggedIn() async {
  String uid = await getCurrentUID();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'lastLoggedIn': Timestamp.now()});
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TrackPoints()),
          ChangeNotifierProvider(create: (context) => ProfileTracker()),
        ],
        child: MaterialApp(
          title: 'Testing GoExplore',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: LoginScreen(),
          ),
        )
    );

    // return ChangeNotifierProvider(
    //     create: (context) => TrackPoints(),
    //     child: MaterialApp(
    //   title: 'Testing GoExplore',
    //   theme: ThemeData(
    //     primarySwatch: Colors.pink,
    //   ),
    //   home: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: LoginScreen(),
    //   ),
    // ));
  }
}

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrackPoints()),
        ChangeNotifierProvider(create: (context) => ProfileTracker()),
      ],
      child: MaterialApp(
        title: 'Testing GoExplore',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Scaffold(
          backgroundColor: Colors.white,
          body: HomePage(),
        ),
      )
    );

    // return ChangeNotifierProvider(
    //     create: (context) => TrackPoints(),
    //     child: MaterialApp(
    //       title: 'Testing GoExplore',
    //       theme: ThemeData(
    //         primarySwatch: Colors.pink,
    //       ),
    //       home: Scaffold(
    //         backgroundColor: Colors.white,
    //         body: HomePage(),
    //       ),
    //     ));
  }
}

// class LoginScreen extends StatefulWidget {
//   //const LoginScreen({Key key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

class LoginScreen extends StatelessWidget {
// class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Login page', style: GoogleFonts.delius(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
              Navigator.pop(context);
            },
          ),),
        backgroundColor: Colors.white,
        body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 10),

                // IconButton(
                //     icon: Icon(Icons.arrow_back, color: Colors.white),
                //     onPressed: () {
                //       Navigator.pop(context, false);
                //     },
                //   ),

                Container(
                  child: Image.asset('assets/images/Logo.png'),
                  alignment: Alignment.center,
                ),
                Container(height: 20),
                Text("GoExplore",
                    style: GoogleFonts.neucha(
                      fontSize: 70,
                      color: Colors.blueAccent,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold
                    )),
                Container(height: 40),
                Container(
                  child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.blueGrey),
                          hintText: 'Email'),
                      style: GoogleFonts.delius(
                        color: Colors.grey,
                      )),
                  alignment: Alignment.center,
                  width: 300,

                ),
                Container(
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Colors.blueGrey),
                        hintText: 'Password',
                        ),
                    style: GoogleFonts.delius(),
                  ),
                  alignment: Alignment.center,
                  width: 300,
                ),
                Container(height: 5),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: TextButton(
                        onPressed: () async {

                          bool shouldNavigate = await signIn(_email.text.trim(), _password.text);
                          bool verified = isVerified();

                          if (shouldNavigate && verified) {

                            if (await shouldUpdateVisitedToday()) {
                              resetVisitedToday();
                            }
                            updateLastLoggedIn();

                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(builder: (context) => MyApp2()),
                            //         (Route<dynamic> route) => false);

                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MyApp2()));
                          } else if (!shouldNavigate) {
                            // incorrect password/email
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                  title: Text("Incorrect email or password"),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),)
                                  ]
                              );
                            });
                          } else if (!verified) {
                            // unverified email
                            showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                  title: Text("Please verify your email"),
                                  actions: <Widget>[
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"),)
                                  ]
                              );
                            });
                          }
                        }, // GO TO HOME PAGE
                        child: Text('Login', style: GoogleFonts.delius(color: Colors.lightBlueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                        style: ButtonStyle()
                    )
                ),
                Container(height: 30),
                Row(
                    children: [
                      Container(width: 60,),
                      Text("Don't have an account?"),
                      Container(width: 0),
                      TextButton(
                          onPressed: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUpPage(),),);
                            },
                          child: Text('Sign up now', style: TextStyle(fontSize: 15)),
        ),]),
              ],
            ))));
  }
}