import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goexplore/flutterfire.dart';
import 'package:provider/provider.dart';
import 'PointTracker.dart';



class PointRedemptionTile extends StatefulWidget {
  final int cost;
  final String promotion;
  final String company;
  final String shortDescription;
  final Widget picture;

  const PointRedemptionTile({
    required this.cost, required this.promotion, required this.company, required this.shortDescription, required this.picture});

  @override
  _PointRedemptionTileState createState() => _PointRedemptionTileState();
}

class _PointRedemptionTileState extends State<PointRedemptionTile> {

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
    int cost = widget.cost;
    final userPoints = context.watch<TrackPoints>();

    return InkWell(
        child: SizedBox(
        height: 200,
        width: 200,
        child: Stack(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: ClipRRect(
                  child: Opacity(
                    child: widget.picture, opacity: 0.25,),
                  borderRadius: BorderRadius.circular(15.0),),
              ),
                  Positioned(
                    child: ConstrainedBox(
                      child: Text(widget.promotion,      // BUY 1 GET 1 FREE
                        style: GoogleFonts.neucha(fontSize: 25, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 100, maxHeight: 80),
                    ),
                    left: 5,
                    top: 5
                  ),
                  Positioned(
                      child: ConstrainedBox(
                        child: Text(widget.company,      // STARBUCKS
                          style: GoogleFonts.delius(fontSize: 15, fontWeight: FontWeight.bold), textAlign: TextAlign.right,),
                        constraints: BoxConstraints(maxWidth: 90, maxHeight: 80),
                      ),
                      right: 5,
                      top: 5
                  ),
                  Positioned(
                    child: ConstrainedBox(              // long text
                      child: Text(widget.shortDescription,
                        style: GoogleFonts.delius(fontSize: 15, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 180, maxHeight: 70),
                    ),
                    top: 85,
                    left: 10,
                  ),
                  Positioned(
                    child: ConstrainedBox(
                      child: Text("$cost points",
                        style: GoogleFonts.delius(fontSize: 17, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 200),
                    ),
                    right: 10,
                    bottom: 10,
                  ),
                ]
            )
        ),
      onTap: () async {
        int p = await getPoints();
        if (p >= widget.cost) {
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                      "Confirm redemption of " + widget.promotion + " with " +
                          widget.cost.toString() + " points?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text("Confirm"),
                      onPressed: () {
                        updatePoints(-widget.cost);
                        userPoints.changePoints(-cost);
                        Navigator.pop(context);
                      },),
                  ],
                );
              });
        } else {
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Insufficient points to redeem this promotion"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        }
      });
  }
}