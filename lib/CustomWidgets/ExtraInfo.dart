import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ImageTile.dart';


class ExtraInfo extends StatefulWidget {
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;

  const ExtraInfo({required this.imgURLs, required this.name, required this.description, required this.address});

  @override
  _ExtraInfoState createState() => _ExtraInfoState();
}

class _ExtraInfoState extends State<ExtraInfo> {

  @override
  Widget build(BuildContext context) {
    List<Widget> images = new List.empty(growable: true);
    double w = MediaQuery.of(context).size.width;

    for (int i = 0; i < widget.imgURLs.length; i ++) {
      images.add(ImageTile(imgURL: widget.imgURLs[i]));
      if (i != widget.imgURLs.length - 1) {
        images.add(Container(width: 20));
      }
    }

    return SingleChildScrollView(
        child: Column(
        children: [
          Text(widget.name, style: GoogleFonts.badScript(fontSize: 40, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: images)
          ),


          Container(height: 10),
          ConstrainedBox(
            child: Text("How to find this place: ", style: GoogleFonts.delius(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            constraints: BoxConstraints(maxWidth: w - 40),
          ),
          Container(height: 5),
          ConstrainedBox(
            child: Text(widget.address, style: GoogleFonts.delius(fontSize: 15,),
            ),
            constraints: BoxConstraints(maxWidth: w - 40),
          ),

          Container(height: 40),
          ConstrainedBox(
            child: Text("A little bit more about this place: ", style: GoogleFonts.delius(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            constraints: BoxConstraints(maxWidth: w - 40),
          ),
          Container(height: 5),
          Container(
            width: w - 40,
            height: 130,
            child: SingleChildScrollView(
              child: Text(widget.description, style: GoogleFonts.delius(fontSize: 15,),
              ),
            ),),
          Container(height: 10),

        ]
    ));
  }
}