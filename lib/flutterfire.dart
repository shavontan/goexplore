import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/firebase.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

bool isVerified() {
  User user = FirebaseAuth.instance.currentUser as User;

  if (user.emailVerified) {
    return true;
  } return false;
}

Future<bool> register(String email, String password, String username, BuildContext context) async {
  try{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = firebaseAuth.currentUser as User;
    user.sendEmailVerification();

    // firestore stuff
    user.updateProfile(displayName: username);
    userSetup(username, email);

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');

      showDialog(context: context, builder: (context) {
        return AlertDialog(
            title: Text("The password provided is too weak."),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),)
            ]
        );
      });
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      showDialog(context: context, builder: (context) {
        return AlertDialog(
            title: Text("The account already exists for that email."),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),)
            ]
        );
      });
      return false;
    } else {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),)
            ]
        );
      });
      return false;
    }
    return false;
  }
}
