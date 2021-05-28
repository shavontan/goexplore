import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// DEPENDS ON HOW THE DATA IS STORED

import 'CustomWidgets/SwipingLocation.dart';

class Adventure extends StatefulWidget {
  //const Adventure({Key key}) : super(key: key);

  @override
  _AdventureState createState() => _AdventureState();
}

class _AdventureState extends State<Adventure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Let's Go on an Adventure!", style: TextStyle(color: Colors.black)),
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
                SwipingLocation(
                    image: Image.asset('assets/images/SGbackground.png'),
                    title: "Haw Par Villa",
                    description: "Haunted Place. Beware: do not go at night!",
                    estimatedPrice: 1
                ),
                Container(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      child: SizedBox(
                        height: 40,
                        width: 120,
                        child: Container(
                          child: TextButton(
                              child: Text("No, not today", style: GoogleFonts.quando(color: Colors.black)),
                              onPressed: () {
                                // CREATE A NEW SwipingLocation object – NEW LOCATION
                              }
                          ),
                          color: Color(0xFFB9E7CF),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    ClipRRect(
                      child: SizedBox(
                        height: 40,
                        width: 120,
                        child: Container(
                          child: TextButton(
                              child: Text("Let's go!", style: GoogleFonts.quando(color: Colors.black)),
                              onPressed: () {

                              }
                          ),
                          color: Color(0xFFB9E7CF),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  ],
                )
              ],
            )
        )
    );
  }
}