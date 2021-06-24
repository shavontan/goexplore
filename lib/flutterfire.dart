import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/firebase.dart';

Future<bool> signIn(String email, String password) async {
  try {
    User currentUser = FirebaseAuth.instance.currentUser as User;
    if (currentUser.isAnonymous) {
      FirebaseAuth.instance.currentUser!.delete();
    }

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    await anonymousSignIn();
    print(e);
    return false;
  }
}

Future<void> anonymousSignIn() async {
  UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

bool isVerified() {
  User user = FirebaseAuth.instance.currentUser as User;

  if (user.emailVerified) {
    return true;
  } return false;
}

bool isLoggedIn() {
  User user = FirebaseAuth.instance.currentUser as User;

  if (user == null) {
    return false;
  }

  if (!user.isAnonymous) {
    return user.emailVerified;
  }
  return false;
}

Future<bool> register(String email, String password, String username, BuildContext context) async {
  try{
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    User currentUser = firebaseAuth.currentUser as User;
    if (currentUser.isAnonymous) {
      firebaseAuth.currentUser!.delete();
    }

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    User user = firebaseAuth.currentUser as User;
    user.sendEmailVerification();

    // firestore stuff
    user.updateProfile(displayName: username);
    userSetup(username, email);

    return true;

    // final currentUser = FirebaseAuth.instance.currentUser as User;
    // final credential = EmailAuthProvider.credential(email: email, password: password);
    // await currentUser.linkWithCredential(credential);
    // currentUser.sendEmailVerification();
    //
    // currentUser.updateProfile(displayName: username);
    // userSetup(username, email);

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

Future<String> getCurrentUID() async {
  return FirebaseAuth.instance.currentUser!.uid;
}

