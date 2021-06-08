import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../flutterfire.dart';
import '../Bookmark.dart';


class BookmarkTile extends StatefulWidget {
  final Widget image;
  final String title;
  final String shortDescription;
  final int estimatedPrice;
  final String bookmarkName;

  const BookmarkTile(
      {required this.bookmarkName,
        required this.image,
        required this.title,
        required this.shortDescription,
        required this.estimatedPrice});

  @override
  _BookmarkTileState createState() => _BookmarkTileState();
}



class _BookmarkTileState extends State<BookmarkTile> {
  String getPriceRange(int i) {
    if (i == 1) {
      return "low";
    } else if (i == 2) {
      return "medium";
    } else if (i == 3) {
      return "high";
    } else {
      return "Error: incorrect 'estimatePrice' input";
    }
  }

  @override
  Widget build(BuildContext context) {
    String priceRange = getPriceRange(widget.estimatedPrice);

    return SizedBox(
        height: 150,
        width: 300,
        child: Card(
            color: Color(0xFFF8CBCB),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              children: [
                Container(
                  width: 10,
                ),
                ConstrainedBox(
                    child: widget.image,
                    constraints: BoxConstraints(maxHeight: 140, maxWidth: 140)),
                Container(width: 20),
                Column(
                  children: [
                    Spacer(flex: 3),
                    ConstrainedBox(
                      child: Text(widget.title,
                          style: GoogleFonts.quando(fontSize: 15)),
                      constraints: BoxConstraints(
                        maxWidth: 120,
                      ),
                    ),
                    Spacer(flex: 2),
                    ConstrainedBox(
                      child: Text(widget.shortDescription,
                          style: GoogleFonts.quando(
                              fontSize: 9, color: Colors.black54)),
                      constraints: BoxConstraints(
                        maxWidth: 110,
                      ),
                    ),
                    Spacer(flex: 2),
                    ConstrainedBox(
                      child: Text("Price range: $priceRange     ",
                          style: GoogleFonts.quando(fontSize: 10)),
                      constraints: BoxConstraints(
                        maxWidth: 110,
                      ),
                    ),
                    Spacer(flex: 3),
                  ],
                )
              ],
            )
        ),
    );
  }
}

// void removeItem(String bookmarkName, String locationName) async {
//   String uid = await getCurrentUID();
//   FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection(bookmarkName)
//       .doc(locationName)
//       .delete();
// }