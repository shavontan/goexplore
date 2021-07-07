import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'flutterfire.dart';

class ProfileTracker extends ChangeNotifier {

  String username = "";
  String profilePic = "";
  String backgroundPic = "";

  ProfileTracker() {
    _loadProfile();
  }

  _loadProfile() async {
    String username = await getUsername();
    String profilePic = await getProfilePic();
    String backgroundPic = await getBackground();
    this.username = username;
    this.profilePic = profilePic;
    this.backgroundPic = backgroundPic;
    notifyListeners();
  }

  Future<String> getUsername() async {
    String uid = await getCurrentUID();
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {return value['username'];});
  }

  Future<String> getProfilePic() async {
    String uid = await getCurrentUID();
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {return value['profilePic'];});
  }

  Future<String> getBackground() async {
    String uid = await getCurrentUID();
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {return value['backgroundPic'];});
  }

  void changeName(String newName) {
    this.username = newName;
    notifyListeners(); // affects watch
  }

  void changeProfilePic(String newURL) {
    this.profilePic = newURL;
    notifyListeners();
  }

  void changeBackgroundPic(String newURL) {
    this.backgroundPic = newURL;
    notifyListeners();
  }

}