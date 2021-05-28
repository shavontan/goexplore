import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// How to use:
// call: SwipingLocation(
//          image: ?,
//          title: ?,
//          description: ?,
//          estimatedPrice: ?)
// with Location info from database


class SwipingLocation extends StatefulWidget {
  final Widget image;
  final String title; // MAX: 35 characters
  final String description; // MAX: 290 characters
  final int estimatedPrice;

  const SwipingLocation(
      {required this.image,
      required this.title,
      required this.description,
      required this.estimatedPrice});

  @override
  _SwipingLocationState createState() => _SwipingLocationState();
}

class _SwipingLocationState extends State<SwipingLocation> {
  String getPriceRange(int i) {
    if (i == 1) {
      return "low";
    } else if (i == 2) {
      return "medium";
    } else if (i == 3) {
      return "high";
    } else {
      return "Error: incorrect 'estimatePrice' input";
    }
  }

  @override
  Widget build(BuildContext context) {
    String priceRange = getPriceRange(widget.estimatedPrice);

    return SizedBox(
        height: 600,
        width: 300,
        child: Card(
            color: Color(0xFFC1CCD2),
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(children: [
              Container(height: 10),
              ConstrainedBox(
                child: widget
                    .image, //'assets/images/SGbackground.png',    // Change to location image – database
                constraints: BoxConstraints(maxWidth: 275, maxHeight: 170),
              ),
              Container(height: 5),
              ConstrainedBox(
                child: Text(
                  widget.title,
                  style: GoogleFonts.kalam(fontSize: 27, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                constraints: BoxConstraints(maxWidth: 275, maxHeight: 100),
              ),
              Container(height: 5),
              ConstrainedBox(
                child: Text(
                  widget.description,
                  style: GoogleFonts.patrickHand(
                    fontSize: 19,
                    color: Colors.black45,
                  ),
                ),
                constraints: BoxConstraints(maxWidth: 250, maxHeight: 270),
              ),
              Container(height: 13),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250, maxHeight: 50),
                  child: Text(
                    "Price range: $priceRange                           ",
                    style: GoogleFonts.patrickHand(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ))
            ])));
  }
}
