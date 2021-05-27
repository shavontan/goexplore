import 'package:flutter/material.dart';

import './flutterfire.dart';
import './main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * (1 / 16),
                    right: MediaQuery.of(context).size.width * (1 / 16)),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * (7 / 8)),
                    child: Column(children: [
                      //Padding(
                      // padding: EdgeInsetsGeometry,),
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(labelText: "Email: "),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Password "),
                        obscureText: true,
                        controller: _password,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Confirm Password "),
                        obscureText: true,
                        controller: _confirmPassword,
                      ),
                      Container(height: 80),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Username: "),
                        controller: _username,
                      ),
                      TextButton(
                          onPressed: () async {
                            if (_password.text == _confirmPassword.text) {
                              bool shouldRegister = await register(_email.text,
                                  _password.text, _username.text, context);
                              if (shouldRegister) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          title: Text(
                                              "Please verify the email address for " +
                                                  _email.text),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyApp(),
                                                  ),
                                                );
                                              },
                                              child: Text("OK"),
                                            )
                                          ]);
                                    });
                                // else: pop-up – account alr registered under this email
                              }
                            }
                            // else : pop-up screen: confirm password does not match password
                            else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text("Passwords do not match"),
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
                          },
                          child: Text('Sign up'))
                    ])))));
  }
}
