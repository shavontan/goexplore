import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String username, String email) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  User user = FirebaseAuth.instance.currentUser as User;
  String uid = user.uid.toString();
  List<double> recreationAvgTime = List.filled(24, 0, growable: true);
  List<double> fnbAvgTime = List.filled(26, 0, growable: true);
  List<int> recreationSeen = List.filled(24, 0, growable: true);
  List<int> fnbSeen = List.filled(26, 0, growable: true);


  users.doc(uid).set({
    'uid': uid,
    'username': username,
    'email': email,
    'points': 0,
    'adventureLocations': [],
    'visitedToday': [],
    'bookmarks': [],
    'lastLoggedIn': Timestamp.now(),
    'recreationAvgTime': recreationAvgTime,
    'fnbAvgTime': fnbAvgTime,
    'recreationSeen': recreationSeen,
    'fnbSeen': fnbSeen,
    'profilePic': "",
    'backgroundPic': "",
  });
  return;
}