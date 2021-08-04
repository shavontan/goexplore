import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class BookmarksBar extends StatefulWidget {
  const BookmarksBar({Key? key}) : super(key: key);

  // final int length;
  //
  // BookmarksBar(this.length);

  // BookmarksBar();

  @override
  BookmarksBarState createState() => BookmarksBarState();
}

final TextEditingController _newBookmark = TextEditingController();
final _formKey = GlobalKey<FormState>();

class BookmarksBarState extends State<BookmarksBar> {
  final List<bool> isSelected = [];

  void reset() {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = false;
    }
  }

  void resetSelection() => setState(() => reset());

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn()) {

      return MaterialButton(
          child: Icon(Icons.add_box),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Uh Oh!"),
                    content: Text("You currently do not have an account.\n\nLog in or sign up now to start adding to bookmarks!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen()));
                        },
                        child: Text("Proceed"),
                      )
                    ],
                  );
                });
          });
    }

    return FutureBuilder(
        future: generateToggleButtons(isSelected),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          }

          return SingleChildScrollView(child: Row(children: [
            ToggleButtons(
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
              // elevation: 5,
              //   unselectedFillColor: Colors.transparent,
            ),
            MaterialButton(
              child: Icon(Icons.add_box),
              onPressed: () async {
                String uid = await getCurrentUID();

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(actions: <Widget>[
                        TextFormField(
                          key: _formKey,
                          controller: _newBookmark,
                          decoration: InputDecoration(
                            hintText: "Enter bookmark name",
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_newBookmark.text.trim().isNotEmpty) {
                              Navigator.pop(context);
                              if (_newBookmark.text.trim().isNotEmpty) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .update({
                                  'bookmarks': FieldValue.arrayUnion(
                                      [_newBookmark.text.trim()])
                                });
                                setState(() {});
                              }
                              _newBookmark.clear();
                            }
                          },
                          child: Text("Done"),
                        ),
                      ]);
                    });
              },
            )
          ]));
        });
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
  int diff = bookmarks.length - list.length;

  for (int i = 0; i < diff; i++) {
    list.add(false);
  }

  final List<Widget> children = [];

  for (int i = 0; i < bookmarks.length; i++) {
    children.add(Column(children: [
      Icon(Icons.bookmark),
      Text(bookmarks[i], style: GoogleFonts.delius(fontWeight: FontWeight.normal),),
    ]));
  }
  return children;
}
