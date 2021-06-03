import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/BookmarkTile.dart';



class Bookmark extends StatefulWidget {

  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookmark 1', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: Column(       // EDIT THIS TO MAKE A LIST (of locations) INSTEAD
          children: [
            BookmarkTile(
              image: Image.asset('assets/images/SGbackground.png'),
              title: "Gardens by the bay",
              shortDescription: "Pretty flowers and nice light show – very kid-friendly",
              estimatedPrice: 2,
            ),
            Container(height: 20),
            BookmarkTile(
              image: Image.asset('assets/images/SGbackground.png'),
              title: "America",
              shortDescription: "another country",
              estimatedPrice: 3,
            ),
            Container(height: 20),
            BookmarkTile(
              image: Image.asset('assets/images/SGbackground.png'),
              title: "Marriot",
              shortDescription: "hotel",
              estimatedPrice: 3,
            ),
            Container(height: 20),
          ],
        )
    );
  }
}