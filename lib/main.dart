import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing GoExplore',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  //const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  child: TextField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.blueGrey),
                          hintText: 'Username/email'),
                      style: TextStyle(
                        color: Colors.grey,
                      )),
                  alignment: Alignment.center,
                  width: 300,
                ),
                Container(
                  child: TextField(
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
                        onPressed: (){}, // GO TO HOME PAGE
                        child: Text('Login', style: TextStyle(color: Colors.lightBlueAccent, fontSize: 20)),
                        style: ButtonStyle()
                    )
                ),
                Container(height: 50),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      child: Text('Sign up now', style: TextStyle(fontSize: 15)),
                      width: 130,
                      height: 25,
                      alignment: Alignment.center,
                    )),
                Container(height: 20),
              ],
            )));
  }
}

