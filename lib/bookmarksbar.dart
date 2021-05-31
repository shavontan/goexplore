import 'package:flutter/material.dart';
import './flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'bookmarksbar2.dart';

class BookmarksBar extends StatefulWidget {

  final int length;
  BookmarksBar(this.length);
  @override
  _BookmarksBarState createState() => _BookmarksBarState(this.length);
}

class _BookmarksBarState extends State<BookmarksBar> {

  final int length;
  _BookmarksBarState(this.length);
  final List<bool> isSelected = [];

  @override
  void initState() {

    for (int i = 0; i < this.length; i++) {
      isSelected.add(false);
    }

   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateToggleButtons(isSelected),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Row(children: [ToggleButtons(
            children: <Widget>[
              ...(snapshot.data! as List<Widget>),
            ],
          selectedColor: Colors.black,
          fillColor: Colors.lightGreen[200],
          onPressed: (int index) {
              setState(() {
                isSelected[index] = !isSelected[index];
              });
          },
          isSelected: isSelected,
          ),
          MaterialButton(child: Icon(Icons.add_box),
            onPressed: () async {
              String uid = await getCurrentUID();
             // FirebaseFirestore.instance.collection('users').doc(uid).update({'bookmarks': FieldValue.arrayUnion(['TEST'])});

              setState (() {

              });
            },)]);
        }
        );
  }
}

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

Future<List<dynamic>> generateToggleButtons(List<bool> list) async {

  List<dynamic> bookmarks = await getBookmarks();
  final List<Widget> children = [];

  if (list.length < bookmarks.length) {
    list.add(false);
  }

  for (int i = 0; i < bookmarks.length; i++) {
    children.add(
      Column(
        children: [
          Icon(Icons.bookmark),
          Text(bookmarks[i]),
        ]
      )
    );
  }
  return children;
}



