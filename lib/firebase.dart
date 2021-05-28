import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String username, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User user = FirebaseAuth.instance.currentUser as User;
  String uid = user.uid.toString();

  users.doc(uid).set({
    'uid': uid,
    'username': username,
    'email': email,
    'points': 0,
    'onAdventure': false,
  });
  return;
}