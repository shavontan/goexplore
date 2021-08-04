import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/PointTracker.dart';
import 'package:provider/provider.dart';

class Collection extends StatefulWidget {
  final String location;
  final String URL;
  final bool onAdventure;

  const Collection({required this.location, required this.URL, required this.onAdventure});

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  // final bool onAdventure = false; // EDIT THIS — get from data base
  int pointsEarned = 50; // arbitrary number

  @override
  Widget build(BuildContext context) {
    final userPoints = context.watch<TrackPoints>();

    if (widget.onAdventure) {
      pointsEarned *= 2;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Earning Points', style: GoogleFonts.delius(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ), //EDIT THIS
        body: Column(
            children: [
              Container(height: 60),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Stack(
                    children: [
                      ClipRRect(
                        child: SizedBox(
                            height: 300,
                            width: 300,
                            child: Opacity(
                              child: FittedBox(child: Image.network(widget.URL),fit: BoxFit.cover),
                              opacity: 0.25,
                            )
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      Positioned(
                        child: ConstrainedBox(child: Text(widget.location, style: GoogleFonts.delius(fontSize: 20), textAlign: TextAlign.left,),
                          constraints: BoxConstraints(maxWidth: 280, maxHeight: 45),),
                        top: 5,
                        left: 10,
                      ),
                      Positioned(
                        child:Text("Congratulations!", style: GoogleFonts.neucha(fontSize: 43, fontWeight: FontWeight.bold, letterSpacing: 1.3)),
                        left: 15,
                        top: 80,
                      ),
                      Positioned(
                        child: ConstrainedBox(child: Text("You have earned $pointsEarned points", style: GoogleFonts.neucha(fontSize: 26, letterSpacing: 1.3), textAlign: TextAlign.center,),
                          constraints: BoxConstraints(maxWidth: 200),),
                        left: 50,
                        top: 145,
                      ),
                      Positioned(
                        child:TextButton(child: Text("Claim", style: GoogleFonts.delius(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),), onPressed: () async {
                          // widget.onAdventure ? updatePoints(pointsEarned * 2) : updatePoints(pointsEarned);
                          // userPoints.changePoints(widget.onAdventure? 2*pointsEarned : pointsEarned);

                          updatePoints(pointsEarned);
                          userPoints.changePoints(pointsEarned);
                          Navigator.pop(context);


                        },),
                        left: 105,
                        top: 230,
                      ),
                    ]

                ),),
            ]

        )
    );
  }
}


Future<int> getPoints() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['points'];});
}

void updatePoints(int toChange) async {
  String uid = await getCurrentUID();
  int currPoints = await getPoints();
  int newPts = currPoints + toChange;
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'points':newPts});
}

Future<List<dynamic>> getAdvLocations() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc['adventureLocations'];});
}

// after "let's go!"
void addAdventureLocation(String locationName) async {
  String uid = await getCurrentUID();
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'adventureLocations': FieldValue.arrayUnion([locationName])});
}



