import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/EditProfile.dart';
import './flutterfire.dart';
import './main.dart';

class ChangePassword extends StatelessWidget {
// class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 30,
            // centerTitle: false,
            titleSpacing: 0,
            title: Text('Edit Profile',
                style: TextStyle(color: Colors.black, fontSize: 15)),
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
                        decoration:
                            InputDecoration(labelText: "Current Password "),
                        obscureText: true,
                        controller: _oldPassword,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "New Password "),
                        obscureText: true,
                        controller: _password,
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: "Repeat New Password "),
                        obscureText: true,
                        controller: _confirmPassword,
                      ),
                      Container(height: 20),

                      TextButton(
                          onPressed: () async {
                            // validate current password
                            var currentUser = FirebaseAuth.instance.currentUser;
                            String email = "";
                            if (currentUser != null) {
                              email = currentUser.email!;
                            }

                            AuthCredential credential =
                                EmailAuthProvider.credential(
                                    email: email, password: _oldPassword.text);

                            currentUser!
                                .reauthenticateWithCredential(credential)
                                .then((value) {

                              if (_password.text == _confirmPassword.text) {
                                if (_password.text != "") {
                                  // update

                                  currentUser.updatePassword(_password.text).then((_){

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  "Password updated successfully."),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                )
                                              ]);
                                        });


                                  }).catchError((error){

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  "Password can't be changed"),
                                              content: Text(error.toString()),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                )
                                              ]);
                                        });

                                  });
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
                            }).catchError((e) {
                              print(e);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text("Incorrect Password"),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"),
                                          )
                                        ]);
                                  });
                            });

                          },
                          child: Text('Done')),
                      Row(children: [
                        Text("Forgot your password?"),
                        TextButton(
                            child: Text("Reset now",
                            style: TextStyle(decoration: TextDecoration.underline)),
                            onPressed: () async {
                              var currentUser =
                                  FirebaseAuth.instance.currentUser;
                              String email = "";
                              if (currentUser != null) {
                                email = currentUser.email!;
                              }

                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email);

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text(
                                            "Email Sent"),
                                        content: Text("A password reset email has been sent to $email.\n\nPlease follow the instructions stated in the email to reset your password."),

                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"),
                                          )
                                        ]);
                                  });
                            })
                      ]),
                    ])))));
  }
}
