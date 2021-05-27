import 'package:flutter/material.dart';

import './flutterfire.dart';
import './main.dart';

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
                TextFormField(
                  decoration: InputDecoration(labelText: "Confirm Password "),
                  obscureText: true,
                  controller: _confirmPassword,),
                Container(height: 20),
                TextFormField(decoration: InputDecoration(labelText: "Username: ")),
                TextButton(
                    onPressed: () async {
                      if (_password.text == _confirmPassword.text) {
                          bool shouldRegister = await register(_email.text, _password.text);
                          if (shouldRegister) {
                            createAlertDialog(context, "Please verify the email address for " + _email.text);
                            // else: pop-up – account alr registered under this email
                          }
                      }
                      // else : pop-up screen: confirm password does not match password
                       else {
                         print("Error");
                       }
                    },
                    child: Text('Sign up'))
              ]
      )
      )

    );
  }
}
