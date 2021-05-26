import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import './flutterfire.dart';
import '/main.dart';


class SignUpPage extends StatefulWidget {
  //const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child:Column(
              children:[
                TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: "Email: ")),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password "),
                  obscureText: true,
                  controller: _password,),
                Container(height: 20),
                TextFormField(decoration: InputDecoration(labelText: "Username: ")),
                TextButton(
                    onPressed: () async {
                      bool shouldRegister = await register(_email.text, _password.text);
                      if (shouldRegister) {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginScreen(),)
                        );
                      }

                    },
                    child: Text('Sign up'))
              ]
      )
      )

    );
  }
}
