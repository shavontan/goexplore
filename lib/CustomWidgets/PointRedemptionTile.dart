import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


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

  @override
  Widget build(BuildContext context) {
    int cost = widget.cost;

    return SizedBox(
        height: 200,
        width: 200,
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            child: Stack(
                children: [
                  ClipRRect(
                    child: FittedBox(
                        child: Opacity(
                          child: widget.picture,
                          opacity: 0.25,
                        )
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  Positioned(
                    child: ConstrainedBox(
                      child: Text(widget.promotion,      // BUY 1 GET 1 FREE
                        style: GoogleFonts.caveat(fontSize: 30, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 100, maxHeight: 80),
                    ),
                  ),
                  Positioned(
                      child: ConstrainedBox(
                        child: Text(widget.company,      // STARBUCKS
                          style: GoogleFonts.caveat(fontSize: 18, fontWeight: FontWeight.bold),),
                        constraints: BoxConstraints(maxWidth: 90, maxHeight: 80),
                      ),
                      right: 10,
                      top: 10
                  ),
                  Positioned(
                    child: ConstrainedBox(              // long text
                      child: Text(widget.shortDescription,
                        style: GoogleFonts.handlee(fontSize: 17, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 180, maxHeight: 70),
                    ),
                    top: 85,
                    left: 10,
                  ),
                  Positioned(
                    child: ConstrainedBox(
                      child: Text("$cost points",
                        style: GoogleFonts.handlee(fontSize: 17, fontWeight: FontWeight.bold),),
                      constraints: BoxConstraints(maxWidth: 200),
                    ),
                    right: 10,
                    bottom: 10,
                  ),
                ]
            )
        )
    );
  }
}