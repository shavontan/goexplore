import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AdventureStack.dart';
import '../flutterfire.dart';
import '../homepage.dart';
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
  bool activate360 = false;         // when activateExtraInfo = true --> activate360 will not change (need to do this check twice)
  bool activateExtraInfo = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(child:
              InkWell(child: Panorama(
                child: Image.network(widget.imageURL_360),
              ),
                onDoubleTap: () {
                  setState(() {
                    activate360 = !activate360;
                  });
                },
                onLongPress: () {
                  setState(() {
                    activate360 = false;
                    activateExtraInfo = true;
                  });
                },
              ),
                absorbing: !activate360,
              ),
              Visibility(
                child: InkWell(
                  child: SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                  onDoubleTap: () {
                    setState(() {
                      activate360 = !activate360;
                    });
                  },
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
                    // Container(height: 30),
                    Row(
                        children: [
                          Container(width: 35),
                          InkWell(
                            child: SizedBox(child: Text("No, Not Today", style: GoogleFonts.hiMelody(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black26)), height: 32, width: 150),
                            onTap: () {
                              advKey.currentState!.nextCard();
                            },
                          ),
                          Container(width: 40),
                          InkWell(
                            child: SizedBox(child: Text("Let's Go!", style: GoogleFonts.hiMelody(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),), height: 32, width: 95),
                            onTap: () {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  updateAdventureLocation(widget.name);

                                  return ClassicGeneralDialogWidget(
                                    titleText: "You're all set!",
                                    contentText: 'Visit ' + widget.name + ' now to earn double points!',
                                    onPositiveClick: () {

                                      Navigator.of(context).pop();
                                    },
                                    onNegativeClick: () {
                                      Navigator.of(context).pop();
                                    },
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
              Visibility(
                  child: Positioned(
                      child: Icon(activate360 ? Icons.lock_open_outlined : Icons.lock, color: activate360 ? Colors.green : Colors.redAccent),
                      top: 40,
                      left: 20),
                  visible: !activateExtraInfo),
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