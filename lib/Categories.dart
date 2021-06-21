import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ListPageBuilder.dart';
import 'swipe.dart';
import 'RecreationFilterPage.dart';
import 'ListPage.dart';

// class Categories extends StatefulWidget {
//   @override
//   _CategoriesState createState() => _CategoriesState();
// }

class Categories extends StatelessWidget {
// class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Category:', style: TextStyle(color: Colors.black)),
            backgroundColor: Color(0xB6C4CAE8),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, false);
              },
            )),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    height: 245,
                    width: 300,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ListPageBuilder('recreation', 100, [], 100)));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Swipe('recreation', 2, [])));
                          // print("tapped");
                        },
                        child: Card(
                            child: Stack(children: [
                              Positioned.fill(
                                child: Opacity(
                                  child: Image.asset('assets/images/F&B.png'),
                                  opacity: 0.4,
                                ),
                              ),
                              Positioned(
                                child: ConstrainedBox(
                                  child: Text(
                                    "Food & Beverages", // BUY 1 GET 1 FREE
                                    style: GoogleFonts.reenieBeanie(
                                      fontSize: 60,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  constraints:
                                  BoxConstraints(maxWidth: 300, maxHeight: 200),
                                ),
                                top: 60,
                                left: 5,
                              ),
                            ])))),
                SizedBox(
                    height: 245,
                    width: 300,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(15.0),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => RecreationFilter()));
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Swipe('recreation', 2, [], double.infinity)));
                        },
                        child: Card(
                            child: Stack(children: [
                              Positioned.fill(
                                child: Opacity(
                                  child: Image.asset('assets/images/Recreation.png'),
                                  opacity: 0.4,
                                ),
                              ),
                              Positioned(
                                child: ConstrainedBox(
                                  child: Text(
                                    "Recreation", // BUY 1 GET 1 FREE
                                    style: GoogleFonts.reenieBeanie(
                                      fontSize: 60,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  constraints:
                                  BoxConstraints(maxWidth: 300, maxHeight: 200),
                                ),
                                top: 90,
                                left: 40,
                              ),
                            ])))),
              ],
            )));
  }
}