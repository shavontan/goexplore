import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './flutterfire.dart';
import './homepage.dart';
import './SignUpPage.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:panorama/panorama.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'CustomWidgets/PointTracker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await anonymousSignIn();

  runApp(MyApp2());
}

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

    return ChangeNotifierProvider(
        create: (context) => TrackPoints(),
        child: MaterialApp(
      title: 'Testing GoExplore',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: LoginScreen(),
      ),
    ));
  }
}

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => TrackPoints(),
        child: MaterialApp(
          title: 'Testing GoExplore',
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: HomePage(),
          ),
        ));
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

    return Scaffold(body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(height: 10),
                Container(
                  child: Image.asset('assets/images/Logo.png'),
                  alignment: Alignment.center,
                ),
                Container(height: 20),
                Text("GoExplore",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.blueAccent,
                    )),
                Container(height: 40),
                Container(
                  child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.blueGrey),
                          hintText: 'Email'),
                      style: TextStyle(
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
                  ),
                  alignment: Alignment.center,
                  width: 300,
                ),
                Container(height: 20),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: TextButton(
                        onPressed: () async {

                          bool shouldNavigate = await signIn(_email.text, _password.text);
                          bool verified = isVerified();
                          if (shouldNavigate && verified) {

                            if (await shouldUpdateVisitedToday()) {
                              resetVisitedToday();
                            }
                            updateLastLoggedIn();

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
                        child: Text('Login', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 20)),
                        style: ButtonStyle()
                    )
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      child: TextButton(
                          onPressed: () async {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SignUpPage(),),);
                            },
                          child: Text('Sign up now', style: TextStyle(fontSize: 15)),
                      style: ButtonStyle()),
                      width: 130,
                      height: 50,
                      alignment: Alignment.center,
                    )),
              ],
            ))));
  }
}