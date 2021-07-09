// edit this: Bookmark --> Adventure


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/newBookmarkTile.dart';

class OnAdventure extends StatefulWidget {

  @override
  OnAdventureState createState() => OnAdventureState();
}

final listKey = GlobalKey<AnimatedListState>();


class OnAdventureState extends State<OnAdventure> {
  String bookmarkName = "";   // remove this – only temp (change all this.bookmarkName below to get Adventure locations data)

  void refresh() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: getBookmarkLocations(this.bookmarkName),      // Change this!!
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Your Current Adventures", style: TextStyle(color: Colors.black)),
                  backgroundColor: Color(0xB6C4CAE8),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                      Navigator.pop(context);
                    },
                  ),),
                body: Center(child: CircularProgressIndicator()),
                backgroundColor: Colors.white);
          }

          return Scaffold(
              appBar: AppBar(
                title: Text("Your Current Adventures", style: TextStyle(color: Colors.black)),
                backgroundColor: Color(0xB6C4CAE8),
                elevation: 0.0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) =>
                      Dismissible(
                          key: UniqueKey(),
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child:
                              BookMarkTile(name: snapshot.data!.docs[index]['name'],
                                imageURL_360: snapshot.data!.docs[index]['360image'],
                                description: snapshot.data!.docs[index]['description'],
                                address: snapshot.data!.docs[index]['address'],
                                imgURLs: snapshot.data!.docs[index]['imageList'],)
                            // BookmarkTile(
                            //   bookmarkName: this.bookmarkName,
                            //   image: Image.network(snapshot.data!.docs[index]['imageURL']),
                            //   title: snapshot.data!.docs[index]['name'],
                            //   shortDescription: snapshot.data!.docs[index]['description'],
                            //   estimatedPrice: snapshot.data!.docs[index]['price'],
                            // )
                          ),
                          onDismissed: (direction) async {
                            String locationName = snapshot.data!.docs[index]['name'];
                            removeItem(this.bookmarkName, locationName);

                            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                              content: new Text("Location removed"),
                            ));
                          },
                          background: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Container(color: Colors.red),
                          )
                      )
              )
          );
        }
    );
  }
}

void removeItem(String bookmarkName, String locationName) async {
  String uid = await getCurrentUID();
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(bookmarkName)
      .doc(locationName)
      .delete();
}

Stream<QuerySnapshot> getBookmarkLocations(String bookmarkName) async* {

  String uid = await getCurrentUID();

  yield* FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection(bookmarkName)
      .snapshots();
}