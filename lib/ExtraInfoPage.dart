import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/ExtraInfo.dart';
import 'package:panorama/panorama.dart';

import 'PopupBookmark.dart';
import 'flutterfire.dart';
import 'main.dart';

class ExtraInfoPage extends StatefulWidget {
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;
  final bool showBookmark;

  const ExtraInfoPage(
      {required this.imgURLs,
      required this.name,
      required this.description,
      required this.address,
      required this.imageURL_360,
        required this.showBookmark
      });

  @override
  _ExtraInfoPageState createState() => _ExtraInfoPageState();
}

class _ExtraInfoPageState extends State<ExtraInfoPage> {
  bool activate360 = false;
  bool confused = false;

  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            title: Text('Extra info',
                style: GoogleFonts.delius(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23)),
            backgroundColor: Color(0xB6C4CAE8),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            actions: [
              Visibility(child: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {

                        if (!isLoggedIn()) {
                          return AlertDialog(
                              title: Text("Uh Oh!"),
                              content: Text("You currently do not have an account. \n\nLog in or sign up now to start adding to bookmarks!"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }, child: Text("Cancel", style: TextStyle(color: Colors.grey)),),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }, child: Text("Proceed"),)
                              ]);
                        }


                        return PopupBookmark(imgURLs: widget.imgURLs, name: widget.name,
                            description: widget.description, address: widget.address,
                            imageURL_360: widget.imageURL_360, tags: [], price: 0);
                      },
                      animationType: DialogTransitionType.size,
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(seconds: 1),
                    );
                  }), visible: widget.showBookmark,),
              IconButton(
                  icon: Icon(Icons.help_outline, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      confused = true;
                    });
                  })
            ]),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width),
          ExtraInfo(
            imgURLs: widget.imgURLs,
            name: widget.name,
            description: widget.description,
            address: widget.address,
          ),
          Visibility(
              child: Panorama(
                animSpeed: 0.1,
                sensorControl: SensorControl.Orientation,
                onViewChanged: onViewChanged,
                child: Image.network(widget.imageURL_360),
              ),
              visible: activate360),
          Positioned(
              child: IconButton(
                icon:
                    Icon(Icons.threed_rotation, size: 40, color: Colors.black),
                onPressed: () {
                  setState(() {
                    activate360 = !activate360;
                  });
                },
              ),
              right: 10,
              bottom: 10),
          Visibility(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: Colors.white,
                  height: 500,
                  width: 275,
                  child: Column(
                    children: [
                      Container(height: 10),
                      SizedBox(
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              Container(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: "Features about this page",
                                  style: GoogleFonts.delius(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                    text: "",
                                    style: GoogleFonts.delius(
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "This page provides additional information about this location. "),
                                    ]),
                              ),
                              Container(height: 5),
                              Text.rich(
                                TextSpan(
                                    text: "",
                                    style: GoogleFonts.delius(
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "We provide multiple images for the user to look through, the address of the location and more details about this location"),
                                    ]),
                              ),
                              Container(height: 50),
                              Text.rich(
                                TextSpan(
                                  text: "Horizontally Scroll (Images):",
                                  style: GoogleFonts.delius(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                    text: "",
                                    style: GoogleFonts.delius(
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "Allows user to look at the many images we provide."),
                                      TextSpan(
                                          text: " Pinch to Zoom",
                                          style: GoogleFonts.delius(
                                              color: Colors.pinkAccent)),
                                      TextSpan(
                                          text: " in to get a better view. ")
                                    ]),
                              ),
                              Container(height: 20),
                              Text.rich(
                                TextSpan(
                                  text: "3D icon",
                                  style: GoogleFonts.delius(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                    text: "",
                                    style: GoogleFonts.delius(
                                      fontSize: 15,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              "Click on this button to get a "),
                                      TextSpan(
                                          text: "360 view",
                                          style: GoogleFonts.delius(
                                              color: Colors.pinkAccent)),
                                      TextSpan(
                                          text:
                                              " of this location (where you can scroll around on)"),
                                    ]),
                              ),
                              Visibility(
                                  child: Column(children: [
                                    Container(height: 20),
                                    Text.rich(
                                      TextSpan(
                                        text: '"+" icon:',
                                        style: GoogleFonts.delius(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                          text: "",
                                          style: GoogleFonts.delius(
                                            fontSize: 15,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                "Click on this button to "),
                                            TextSpan(
                                                text: "add this location to bookmarks",
                                                style: GoogleFonts.delius(
                                                    color: Colors.pinkAccent)),
                                            TextSpan(
                                                text:
                                                " of your choice."),
                                          ]),
                                    ),
                                  ]),
                                  visible: widget.showBookmark),
                            ],
                          )),
                          height: 420,
                          width: 250),
                      Container(height: 10),
                      TextButton(
                        child: Text(
                          "Close",
                          style: GoogleFonts.delius(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            confused = false;
                          });
                        },
                      ),
                      Container(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            visible: confused,
          )
        ]));
  }
}
