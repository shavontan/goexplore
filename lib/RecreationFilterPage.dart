import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:goexplore/swipe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CustomWidgets/SwipingTile.dart';
import 'ListPage.dart';
import 'ListPageBuilder.dart';
import 'flutterfire.dart';

class RecreationFilter extends StatefulWidget {
  // const RecreationFilter({Key key}) : super(key: key);
  var recreationTags = [
    "Indoor",  // -- 0
    "Outdoor",
    "Physical",
    "Leisure",  // -- 3
    "Nature",
    "Cultural",
    "Educational",
    "Service",   // -- 7
    "Kid-Friendly",
    "Nightlife"
  ];

  @override
  _RecreationFilterState createState() => _RecreationFilterState();
}

class _RecreationFilterState extends State<RecreationFilter> {

  var selected = new List.filled(10, 0, growable: false); // 8 = recreationTags.length

  double currentPriceLimit = 20;

  bool stateZero = false; // false = not selected (0) & true = selected (1)
  bool stateOne = false;
  bool stateTwo = false;
  bool stateThree = false;
  bool stateFour = false;
  bool stateFive = false;
  bool stateSix = false;
  bool stateSeven = false;
  bool stateEight = false;
  bool stateNine = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter', style: GoogleFonts.delius(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23)),
        backgroundColor: Color(0xB6C4CAE8),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: Column(
        children: [
          Container(height: 20),
          Text("Select the tags you want:", style: GoogleFonts.delius(fontSize: 20, fontWeight: FontWeight.w500),),
          Container(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[0], style: GoogleFonts.delius(
                              fontSize: 24),),
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
                          child: Opacity(child: Text(widget.recreationTags[1], style: GoogleFonts.delius(
                              fontSize: 24),),
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
                          child: Opacity(child: Text(widget.recreationTags[2], style: GoogleFonts.delius(
                              fontSize: 24),),
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
                          child: Opacity(child: Text(widget.recreationTags[3], style: GoogleFonts.delius(
                              fontSize: 24),),
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
                          child: Opacity(child: Text(widget.recreationTags[4], style: GoogleFonts.delius(
                              fontSize: 24),),
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
                          child: Opacity(child: Text(widget.recreationTags[5], style: GoogleFonts.delius(
                              fontSize: 24),),
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
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
              child: Card(
                child: Padding(
                    child: Opacity(child: Text(widget.recreationTags[6], style: GoogleFonts.delius(
                        fontSize: 24),),
                        opacity: stateSix ? 1.0 : 0.4),
                    padding: EdgeInsets.all(7.0)),
                color: stateSix ? Color(0xA9DBD0F6) : Colors.white,
                elevation: stateSix ? 5.0 : 0.0,
              ),
              onTap: () {
                if (selected.elementAt(6) == 0) {
                  setState(() {
                    selected[6] = 1;
                    stateSix = true;
                  });
                } else {
                  setState(() {
                    selected[6] = 0;
                    stateSix = false;
                  });
                }
              }),
          InkWell(
              child: Card(
                child: Padding(
                    child: Opacity(child: Text(widget.recreationTags[7], style: GoogleFonts.delius(
                        fontSize: 24),),
                        opacity: stateSeven ? 1.0 : 0.4),
                    padding: EdgeInsets.all(7.0)),
                color: stateSeven ? Color(0xA9DBD0F6) : Colors.white,
                elevation: stateSeven ? 5.0 : 0.0,
              ),
              onTap: () {
                if (selected.elementAt(7) == 0) {
                  setState(() {
                    selected[7] = 1;
                    stateSeven = true;
                  });
                } else {
                  setState(() {
                    selected[7] = 0;
                    stateSeven = false;
                  });
                }
              }),
        ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[8], style: GoogleFonts.delius(
                              fontSize: 24),),
                              opacity: stateEight ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateEight ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateEight ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(8) == 0) {
                        setState(() {
                          selected[8] = 1;
                          stateEight = true;
                        });
                      } else {
                        setState(() {
                          selected[8] = 0;
                          stateEight = false;
                        });
                      }
                    }),
                InkWell(
                    child: Card(
                      child: Padding(
                          child: Opacity(child: Text(widget.recreationTags[9], style: GoogleFonts.delius(
                              fontSize: 24),),
                              opacity: stateNine ? 1.0 : 0.4),
                          padding: EdgeInsets.all(7.0)),
                      color: stateNine ? Color(0xA9DBD0F6) : Colors.white,
                      elevation: stateNine ? 5.0 : 0.0,
                    ),
                    onTap: () {
                      if (selected.elementAt(9) == 0) {
                        setState(() {
                          selected[9] = 1;
                          stateNine = true;
                        });
                      } else {
                        setState(() {
                          selected[9] = 0;
                          stateNine = false;
                        });
                      }
                    }),
              ]),

          Container(height: 80),
          Text("Price limit: \$${currentPriceLimit.floor()}", style: GoogleFonts.delius(fontSize: 20, fontWeight: FontWeight.w500),),
          Slider(
            value: currentPriceLimit,
            onChanged: (newValue) {
              setState(() {
                currentPriceLimit = newValue;
                print(currentPriceLimit);
              });
            },
            max: 300,
            min: 0,
            activeColor: Colors.deepPurpleAccent,
            inactiveColor: Colors.black12,
          ),

          Container(height: 80),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text("Simple List", style: GoogleFonts.delius(fontSize: 23, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onPressed: () {
                  List<String> selectedTags = [];
                  for (int i = 0; i < selected.length; i++) {
                    if (selected[i] == 1) {
                      selectedTags.add(widget.recreationTags[i]);
                    }
                  }
                  print(selectedTags);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          ListPage('recreation', currentPriceLimit.round(), selectedTags,)));
                         // ListPageBuilder('recreation', currentPriceLimit.round(), selectedTags, distanceInKm)));
                  //SwipingTile(imageURLs: testerURLs, name: name, address: address, description: description, imageURL_360: image_360,)));
                  // pass data to database + go to next page
                },
              ),TextButton(
                child: Text("Let's swipe!", style: GoogleFonts.delius(fontSize: 23, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onPressed: () {
                  List<String> selectedTags = [];
                  for (int i = 0; i < selected.length; i++) {
                    if (selected[i] == 1) {
                      selectedTags.add(widget.recreationTags[i]);
                    }
                  }
                  print(selectedTags);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          Swipe('recreation', currentPriceLimit.round(), selectedTags,)));

                  //SwipingTile(imageURLs: testerURLs, name: name, address: address, description: description, imageURL_360: image_360,)));
                  // pass data to database + go to next page
                },
              ),],),

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