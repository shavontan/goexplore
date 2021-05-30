import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'flutterfire.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import './profilepage.dart';

import 'package:random_color/random_color.dart';
import './bookmarksbar.dart';

// Link to DB

class Swipe extends StatefulWidget {

  final String category;
  final int price;
  final List<String> tags;

  Swipe(this.category, this.price, this.tags);

  @override
  _SwipeState createState() => _SwipeState(this.category, this.price, this.tags);
}

Stream<QuerySnapshot> getLocationStreamSnapshots(
    BuildContext context, String category, int price, List<String> tags) async* {
  final uid = await getCurrentUID();

  yield* FirebaseFirestore.instance
      .collection(category)
      .where('price', isLessThanOrEqualTo: price)
      .snapshots();

}

bool check(List<dynamic> doc, List<String> tag) {

  if (tag.every((item) => doc.contains(item)) && doc.length > 0 || tag.length == 0) {
    return true;
  } else {
    return false;
  }
}


class _SwipeState extends State<Swipe> {
  // Dynamically load cards from database

  final String category;
  final int price;
  final List<String> tags;

  _SwipeState(this.category, this.price, this.tags);

  List<Card> cards = [];

  @override
  Widget build(BuildContext context) {
    // Stack of cards that can be swiped. Set width, height, etc here.

    return Container(

      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.7,
      // Important to keep as a stack to have overlay of cards.

        child: StreamBuilder<QuerySnapshot>(
            stream: getLocationStreamSnapshots(context, this.category, this.price, this.tags),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              }

              List<dynamic> filtered = snapshot.data!.docs.where((d) =>
               check(d['tags'], tags)
              ).toList();

              if (filtered.isEmpty) {
                return Center(child: CircularProgressIndicator(),);
              }

              final randomDocs = filtered..shuffle();
              final length = randomDocs.length;

              for (int i = 0; i < length; i++) {
                cards.add(
                  Card(randomDocs[i])
                );
              }

              return Scaffold(
                  appBar: AppBar(
                      title: Text("Let's Explore!", style: TextStyle(color: Colors.black)),
                      backgroundColor: Color(0xB6C4CAE8),
                      elevation: 0.0,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.account_circle, color: Colors.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                            })
                      ],
                  ),
                  body: Stack(children: cards),
                  bottomNavigationBar: BookmarksBar(),
              );
            }
        )
      // child: Stack(
      //   children: cards,
      // ),
    );
  }
}

class Card extends StatelessWidget {
  // Made to distinguish cards
  // Add your own applicable data here
  final DocumentSnapshot doc;
  Card(this.doc);

  @override
  Widget build(BuildContext context) {

    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorBrightness: ColorBrightness.light,
        colorSaturation: ColorSaturation.lowSaturation,
    );

    return Swipable(
      // Set the swipable widget
      child: Center(
        child: Container(
          child: Column(children: [
        Container(height: 10),
          ConstrainedBox(
            child: Image.network(doc['imageURL']), //'assets/images/SGbackground.png',    // Change to location image – database
            constraints: BoxConstraints(maxWidth: 275, maxHeight: 170),
          ),
          Container(height: 5),
          ConstrainedBox(
            child: Text(
              doc['name'],
              style: GoogleFonts.kalam(fontSize: 27, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            constraints: BoxConstraints(maxWidth: 275, maxHeight: 100),
          ),
          Container(height: 5),
          ConstrainedBox(
            child: Text(
              doc['description'],
              style: GoogleFonts.patrickHand(
                fontSize: 19,
                color: Colors.black45,
              ),
            ),
            constraints: BoxConstraints(maxWidth: 250, maxHeight: 270),
          ),
          Container(height: 13),
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250, maxHeight: 50),
              child: Text(
                "Price range: " + doc['price'].toString(),
                style: GoogleFonts.patrickHand(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ))
          ]),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: _color,
          ),
        ),
      ),

      // onSwipeRight, left, up, down, cancel, etc...
    );
  }
}