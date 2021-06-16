import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecreationFilter extends StatefulWidget {
  // const RecreationFilter({Key key}) : super(key: key);
  var recreationTags = [
    "Indoor",
    "Outdoor",
    "Physical",
    "Leisure",
    "Nature",
    "Cultural",
    "Educational",
    "Service"
  ];

  @override
  _RecreationFilterState createState() => _RecreationFilterState();
}

class _RecreationFilterState extends State<RecreationFilter> {
  var selected = new List.filled(8, 0, growable: false); // 8 = recreationTags.length

  double currentPriceLimit = 20;
  double distanceInKm = 100;

  bool stateZero = false; // false = not selected (0) & true = selected (1)
  bool stateOne = false;
  bool stateTwo = false;
  bool stateThree = false;
  bool stateFour = false;
  bool stateFive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter', style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xB6C4CAE8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),),
      body: Column(
        children: [
          Container(height: 20),
          Text("Select your tags to filter out:", style: TextStyle(fontSize: 20),),
          Container(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[0], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateZero ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateZero ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateZero ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(0) == 0) {
                        setState(() {
                          selected[0] = 1;
                          stateZero = true;
                        });
                      } else {
                        setState(() {
                          selected[0] = 0;
                          stateZero = false;
                        });
                      }
                    }),
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[1], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateOne ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateOne ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateOne ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(1) == 0) {
                        setState(() {
                          selected[1] = 1;
                          stateOne = true;
                        });
                      } else {
                        setState(() {
                          selected[1] = 0;
                          stateOne = false;
                        });
                      }
                    }),
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[2], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateTwo ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateTwo ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateTwo ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(2) == 0) {
                        setState(() {
                          selected[2] = 1;
                          stateTwo = true;
                        });
                      } else {
                        setState(() {
                          selected[2] = 0;
                          stateTwo = false;
                        });
                      }
                    }),
              ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[3], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateThree ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateThree ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateThree ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(3) == 0) {
                        setState(() {
                          selected[3] = 1;
                          stateThree = true;
                        });
                      } else {
                        setState(() {
                          selected[3] = 0;
                          stateThree = false;
                        });
                      }
                    }),
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[4], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateFour ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateFour ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateFour ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(4) == 0) {
                        setState(() {
                          selected[4] = 1;
                          stateFour = true;
                        });
                      } else {
                        setState(() {
                          selected[4] = 0;
                          stateFour = false;
                        });
                      }
                    }),
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[5], style: GoogleFonts.neucha(
                              fontSize: 30),),
                              opacity: stateFive ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateFive ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateFive ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(5) == 0) {
                        setState(() {
                          selected[5] = 1;
                          stateFive= true;
                        });
                      } else {
                        setState(() {
                          selected[5] = 0;
                          stateFive = false;
                        });
                      }
                    }),
              ]),

          Container(height: 80),
          Text("Price limit: \$${currentPriceLimit.floor()}", style: TextStyle(fontSize: 20),),
          Slider(
            value: currentPriceLimit,
            onChanged: (newValue) {
              setState(() {
                currentPriceLimit = newValue;
                print(currentPriceLimit);
              });
            },
            max: 1000,
            min: 0,
            activeColor: Colors.deepPurpleAccent,
            inactiveColor: Colors.black12,
          ),

          Container(height: 80),
          Text("How far are you willing to travel: ${distanceInKm.floor()} km", style: TextStyle(fontSize: 18),),
          Slider(
            value: distanceInKm,
            onChanged: (newValue) {
              setState(() {
                distanceInKm = newValue;
                print(distanceInKm);
              });
            },
            max: 1000,
            min: 0,
            activeColor: Colors.deepPurpleAccent,
            inactiveColor: Colors.black12,
          ),

          Container(height: 80),
          TextButton(
            child: Text("Ready To Go!", style: GoogleFonts.sriracha(fontSize: 20, color: Colors.redAccent)),
            onPressed: () {
              // pass data to database + go to next page
            },
          )

        ],
      ),
    );
  }
}


// InkWell(
// child: Card(
// child: Padding(
// child: Opacity(child: Text(widget.recreationTags[0], style: GoogleFonts.neucha(
// fontSize: 30),),
// opacity: stateZero ? 1.0 : 0.4),
// padding: EdgeInsets.all(7.0)),
// color: stateZero ? Color(0xA9DBD0F6) : Colors.white,
// elevation: stateZero ? 5.0 : 0.0,
// ),
// onTap: () {
// if (selected.elementAt(0) == 0) {
// setState(() {
// selected[0] = 1;
// stateZero = true;
// });
// } else {
// setState(() {
// selected[0] = 0;
// stateZero = false;
// });
// }
// }),