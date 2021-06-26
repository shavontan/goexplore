import 'package:flutter/material.dart';

import './flutterfire.dart';
import './main.dart';

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

class SignUpPage extends StatelessWidget {
// class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _username = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
           leadingWidth: 30,
           // centerTitle: false,
           titleSpacing: 0,
          title: Text('Login', style: TextStyle(color: Colors.black, fontSize: 15)),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.chevron_left_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
    )),
          // leading: SingleChildScrollView(scrollDirection: Axis.horizontal,
          //     child:
          //   FlatButton.icon(
          //   label: Text("Login"),
          //   icon: Icon(Icons.chevron_left_outlined, color: Colors.black),
          //   onPressed: () {
          //     print("pressed");
          //     Navigator.pop(context);
          //   },
          // )),),
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
                                                    MyApp2(),
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
