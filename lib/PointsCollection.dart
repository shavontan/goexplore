import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Collection extends StatefulWidget {
  final String location;
  final String URL;

  const Collection({required this.location, required this.URL});

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final bool onAdventure = false; // EDIT THIS — get from data base
  final int pointsEarned = 1000; // arbitrary number

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Earning Points', style: TextStyle(color: Colors.black)),
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
                              child: Image.network(widget.URL),
                              opacity: 0.25,
                            )
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      Positioned(
                        child: ConstrainedBox(child: Text(widget.location, style: GoogleFonts.neucha(fontSize: 20), textAlign: TextAlign.center,),
                          constraints: BoxConstraints(maxWidth: 250),),
                        left: 90,
                        top: 80,
                      ),
                      Positioned(
                        child:Text("Congratulations!", style: GoogleFonts.kalam(fontSize: 40)),
                        left: 15,
                        top: 20,
                      ),
                      Positioned(
                        child: ConstrainedBox(child: Text("You have earned $pointsEarned points", style: GoogleFonts.kalam(fontSize: 30), textAlign: TextAlign.center,),
                          constraints: BoxConstraints(maxWidth: 250),),
                        left: 25,
                        top: 120,
                      ),
                      Positioned(
                        child:TextButton(child: Text("Claim", style: GoogleFonts.pangolin(fontSize: 30, color: Colors.black45),), onPressed: () {
                          onAdventure ? updatePoints(pointsEarned * 2) : updatePoints(pointsEarned);
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