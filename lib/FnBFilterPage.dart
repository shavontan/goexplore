import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:goexplore/swipe.dart';
// import 'package:goexplore/swipe.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'CustomWidgets/SwipingTile.dart';


class FnBFilter extends StatefulWidget {
  // const RecreationFilter({Key key}) : super(key: key);
  var fnbTags = [
    "Beverages", // --- 0
    "Ambience",
    "Chinese",
    "Korean",
    "Japanese",    // --- 4
    "Malay",
    "Indian",
    "Halal",
    "Western",    // --- 8
    "Fast Food",
    "Vegan",
    "Vegetarian",
    "Dessert",     // --- 12
  ];

  @override
  _FnBFilterState createState() => _FnBFilterState();
}

class _FnBFilterState extends State<FnBFilter> {
  List<String> testerURLs = [
    'https://1.bp.blogspot.com/-iUYjW8TuqtE/UkWmCkx_Z1I/AAAAAAAAdAA/Z08tUps8-yM/s1600/01+Cafe+Colbar+-+A+Journey+Back+In+Time+to+the+Colonial+Bar+@+9A+Whitchurch+Road+%5BNext+to+the+Upcoming+Mediapolis%5D+(Large).JPG',
    'https://live.staticflickr.com/3387/5713143243_3ee59eacbf_b.jpg',
    'https://untouristsingapore.files.wordpress.com/2015/03/kp6081607.jpg',
    'https://thelionraw.files.wordpress.com/2013/02/img_7853.jpg'];

  String name = "Cafe Colbar";
  String address = "9A Whitchurch Road, Singapore 138839";
  String description = "An old-school kopitiam from the 1950s that is untouched by time.";
  String image_360 = "https://firebasestorage.googleapis.com/v0/b/goexplore-af61c.appspot.com/o/Adventure%20Cove%20Waterpark.jpg?alt=media&token=9c9f0129-480f-4473-b78c-f8f67955da99";



  var selected = new List.filled(13, 0, growable: false); // 13 = recreationTags.length

  double currentPriceLimit = 20;
  double distanceInKm = 100;

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
  bool stateTen = false;
  bool stateEleven = false;
  bool stateTwelve = false;

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
        body: SingleChildScrollView(child: Column(
          children: [
            Container(height: 20),
            Text("Select your tags to filter out:", style: TextStyle(fontSize: 20),),
            Container(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[0], style: GoogleFonts.neucha(
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
                            child: Opacity(child: Text(widget.fnbTags[1], style: GoogleFonts.neucha(
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
                            child: Opacity(child: Text(widget.fnbTags[2], style: GoogleFonts.neucha(
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
                          child: Opacity(child: Text(widget.fnbTags[3], style: GoogleFonts.neucha(
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
                          child: Opacity(child: Text(widget.fnbTags[4], style: GoogleFonts.neucha(
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
                          child: Opacity(child: Text(widget.fnbTags[5], style: GoogleFonts.neucha(
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
                    }),],),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[6], style: GoogleFonts.neucha(
                                fontSize: 30),),
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
                            child: Opacity(child: Text(widget.fnbTags[7], style: GoogleFonts.neucha(
                                fontSize: 30),),
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
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[8], style: GoogleFonts.neucha(
                                fontSize: 30),),
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
                ]),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[9], style: GoogleFonts.neucha(
                                fontSize: 30),),
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
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[10], style: GoogleFonts.neucha(
                                fontSize: 30),),
                                opacity: stateTen ? 1.0 : 0.4),
                            padding: EdgeInsets.all(7.0)),
                        color: stateTen ? Color(0xA9DBD0F6) : Colors.white,
                        elevation: stateTen ? 5.0 : 0.0,
                      ),
                      onTap: () {
                        if (selected.elementAt(10) == 0) {
                          setState(() {
                            selected[10] = 1;
                            stateTen = true;
                          });
                        } else {
                          setState(() {
                            selected[10] = 0;
                            stateTen = false;
                          });
                        }
                      }),
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[11], style: GoogleFonts.neucha(
                                fontSize: 30),),
                                opacity: stateEleven ? 1.0 : 0.4),
                            padding: EdgeInsets.all(7.0)),
                        color: stateEleven ? Color(0xA9DBD0F6) : Colors.white,
                        elevation: stateEleven ? 5.0 : 0.0,
                      ),
                      onTap: () {
                        if (selected.elementAt(11) == 0) {
                          setState(() {
                            selected[11] = 1;
                            stateEleven = true;
                          });
                        } else {
                          setState(() {
                            selected[11] = 0;
                            stateEleven = false;
                          });
                        }
                      }),
                ]),

            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      child: Card(
                        child: Padding(
                            child: Opacity(child: Text(widget.fnbTags[12], style: GoogleFonts.neucha(
                                fontSize: 30),),
                                opacity: stateTwelve ? 1.0 : 0.4),
                            padding: EdgeInsets.all(7.0)),
                        color: stateTwelve ? Color(0xA9DBD0F6) : Colors.white,
                        elevation: stateTwelve ? 5.0 : 0.0,
                      ),
                      onTap: () {
                        if (selected.elementAt(12) == 0) {
                          setState(() {
                            selected[12] = 1;
                            stateTwelve = true;
                          });
                        } else {
                          setState(() {
                            selected[12] = 0;
                            stateTwelve = false;
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
            // Text("How far are you willing to travel: ${distanceInKm.floor()} km", style: TextStyle(fontSize: 18),),
            // Slider(
            //   value: distanceInKm,
            //   onChanged: (newValue) {
            //     setState(() {
            //       distanceInKm = newValue;
            //       print(distanceInKm);
            //     });
            //   },
            //   max: 1000,
            //   min: 0,
            //   activeColor: Colors.deepPurpleAccent,
            //   inactiveColor: Colors.black12,
            // ),
            //
            // Container(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text("Simple List", style: GoogleFonts.sriracha(fontSize: 20, color: Colors.redAccent)),
                  onPressed: () {
                    List<String> selectedTags = [];
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i] == 1) {
                        selectedTags.add(widget.fnbTags[i]);
                      }
                    }
                    print(selectedTags);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) =>
                    //         Swipe('recreation', currentPriceLimit.round(), selectedTags, distanceInKm)));
                    //SwipingTile(imageURLs: testerURLs, name: name, address: address, description: description, imageURL_360: image_360,)));
                    // pass data to database + go to next page
                  },
                ),TextButton(
                  child: Text("Let's swipe!", style: GoogleFonts.sriracha(fontSize: 20, color: Colors.redAccent)),
                  onPressed: () {
                    List<String> selectedTags = [];
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i] == 1) {
                        selectedTags.add(widget.fnbTags[i]);
                      }
                    }
                    print(selectedTags);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            Swipe('fnb', currentPriceLimit.round(), selectedTags, distanceInKm)));
                    //SwipingTile(imageURLs: testerURLs, name: name, address: address, description: description, imageURL_360: image_360,)));
                    // pass data to database + go to next page
                  },
                ),],),

          ],
        ),
        ));
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