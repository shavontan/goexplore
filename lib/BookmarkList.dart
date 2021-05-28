import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class BookmarkList extends StatefulWidget {
  //const BookmarkList({Key key}) : super(key: key);

  @override
  _BookmarkListState createState() => _BookmarkListState();
}

class _BookmarkListState extends State<BookmarkList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your bookmarks', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 50),
                SizedBox(
                  child: Card(
                    child: TextButton(
                      child: Text("Bookmark 1", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
                      onPressed: () {
                        // NAVIGATE TO BOOKMARK 1
                      },
                    ),
                    color: Color(0xFFCCC3E8),
                  ),
                  height: 70,
                  width: 275,
                ),
                Container(height: 20),
                SizedBox(
                  child: Card(
                    child: TextButton(
                      child: Text("Bookmark 2", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
                      onPressed: () {
                        // NAVIGATE TO BOOKMARK 2
                      },
                    ),
                    color: Color(0xFFCCC3E8),
                  ),
                  height: 70,
                  width: 275,
                ),
                Container(height: 20),
                SizedBox(
                  child: Card(
                    child: TextButton(
                      child: Text("Bookmark 3", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
                      onPressed: () {
                        // NAVIGATE TO BOOKMARK 3
                      },
                    ),
                    color: Color(0xFFCCC3E8),
                  ),
                  height: 70,
                  width: 275,
                ),
                Container(height: 20),
                SizedBox(
                  child: Card(
                    child: TextButton(
                      child: Text("Bookmark 4", style: GoogleFonts.quicksand(fontSize: 30, color: Colors.black54)),
                      onPressed: () {
                        // NAVIGATE TO BOOKMARK 4
                      },
                    ),
                    color: Color(0xFFCCC3E8),
                  ),
                  height: 70,
                  width: 275,
                ),
              ],
            )
        )
    );
  }
}