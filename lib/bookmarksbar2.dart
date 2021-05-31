import 'package:flutter/material.dart';
import './flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bookmarksbar.dart';

// class BookmarksBar2 extends StatefulWidget {
//
//   @override
//   _BookmarksBar2State createState() => _BookmarksBar2State();
// }

Future<List<dynamic>> getBookmarks() async {
  final uid = await getCurrentUID();

  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    return ((value.data() as Map)['bookmarks']);
  });
}

class BookmarksBar2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getBookmarks(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return CircularProgressIndicator();
      }
      return BookmarksBar((snapshot.data! as List).length);
    });
  }
}
