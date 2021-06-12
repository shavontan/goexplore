import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'flutterfire.dart';


class Collection extends StatefulWidget {
  final String qrResult;

  const Collection({required this.qrResult});

  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  final bool onAdventure = false; // EDIT THIS — get from data base
  final int pointsEarned = 200; // arbitrary number

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
                          child: ColoredBox(color: Color(0xFFFF9898)),
                        ),
                        borderRadius: BorderRadius.circular(15.0),
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
                        top: 100,
                      ),
                      Positioned(
                        child:TextButton(child: Text("Claim", style: GoogleFonts.pangolin(fontSize: 30, color: Colors.black45),), onPressed: () {
                          print("GAIN POINTS");
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