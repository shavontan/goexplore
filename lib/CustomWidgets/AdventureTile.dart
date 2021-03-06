import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AdventureStack.dart';
import '../flutterfire.dart';
import '../homepage.dart';
import '../main.dart';
import 'ExtraInfo.dart';
import 'package:panorama/panorama.dart';

// HOW TO USE:
// call: AdventureTile(imageURLs: ???, name: ???, address: ???, description: ???, imageURL_360: ???,)


class AdventureTile extends StatefulWidget {
  final List<String> imageURLs;
  final String imageURL_360;
  final String name;
  final String description;
  final String address;

  const AdventureTile({required this.imageURLs, required this.imageURL_360,
    required this.name, required this.description, required this.address,});

  @override
  AdventureTileState createState() => AdventureTileState();
}

class AdventureTileState extends State<AdventureTile> {
  bool activate360 = true;         // when activateExtraInfo = true --> activate360 will not change (need to do this check twice)
  bool activateExtraInfo = false;

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
        body: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(child:
              InkWell(
                child: Opacity(
                  child: Panorama(
                    animSpeed: 0.1,
                    sensorControl: SensorControl.Orientation,
                    onViewChanged: onViewChanged,
                    child: Image.network(widget.imageURL_360),
                  ),
                  opacity: activateExtraInfo ? 0.3 : 1,
                ),
                onLongPress: () {
                  setState(() {
                    activateExtraInfo = true;
                  });
                },
              ),
                absorbing: !activate360,
              ),
              Visibility(
                child: InkWell(
                  child: SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                  onLongPress: () {
                    setState(() {
                      activateExtraInfo = true;
                    });
                  },
                ),
                visible: !activate360,
              ),
              Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Positioned(
                        child: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {setState(() {
                            activateExtraInfo = false;
                          });
                          },
                        ),
                        ),
                    // Container(height: 30),
                    ExtraInfo(imgURLs: widget.imageURLs, name: widget.name, address: widget.address, description: widget.description,),
                    Container(height: 20),
                    Row(
                        children: [
                          Container(width: 55),
                          InkWell(
                            child: SizedBox(child: Text("No, Not Today", style: GoogleFonts.neucha(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)), height: 32, width: 150),
                            onTap: () {
                              advKey.currentState!.nextCard();
                            },
                          ),
                          Container(width: 30),
                          InkWell(
                            child: SizedBox(child: Text("Let's Go!", style: GoogleFonts.neucha(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),), height: 32, width: 95),
                            onTap: () {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {

                                  if (!isLoggedIn()) {
                                    return AlertDialog(
                                        title: Text("Uh Oh!"),
                                        content: Text("You currently do not have an account. \n\nLog in or sign up now to start collecting points!"),
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

                                  updateAdventureLocation(widget.name);

                                  return ClassicGeneralDialogWidget(
                                    titleText: "You're all set!",
                                    contentText: 'Visit ' + widget.name + ' now to earn double points!',
                                    positiveText: "Done",
                                    onPositiveClick: () {

                                      Navigator.of(context).pop();
                                    },
                                    // onNegativeClick: () {
                                    //   Navigator.of(context).pop();
                                    // },
                                  );

                                },
                                animationType: DialogTransitionType.rotate3D,
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(seconds: 1),

                              );
                            },
                          ),
                          // Container(width: 18),
                        ]
                    ),
                    Container(height: 15)
                  ],
                ),
                visible: activateExtraInfo,
              ),
            ]
        )
    );
  }
}

void updateAdventureLocation(String locationName) async {
  String uid = await getCurrentUID();
  List<dynamic> locations = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc['adventureLocations'];});
  if (!locations.contains(locationName)) {
    locations.add(locationName);
  }
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'adventureLocations': locations});
}