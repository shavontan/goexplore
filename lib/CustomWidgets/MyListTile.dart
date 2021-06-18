import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'newBookMarkTile.dart';


class MyListTile extends StatefulWidget {
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;
  final List<String> tags;
  final int price;

  const MyListTile({required this.imgURLs, required this.name, required this.description, required this.address, required this.imageURL_360, required this.tags, required this.price});

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {

  String PriceRange(int price) {
    if (price < 0) {
      return "Invalid price stored in database";
    }

    if (price < 5) {
      return "\$";
    } else if (price < 10) {
      return "\$\$";
    } else if (price < 20) {
      return "\$\$\$";
    } else if (price < 40) {
      return "\$\$\$\$";
    } else {
      return "\$\$\$\$\$";
    }
  }

  String toStringOfTags(List<String> tags) {
    String StringOfTags = "";

    for (String tag in tags) {
      StringOfTags = StringOfTags + "# $tag   ";
    }
    return StringOfTags;
  }


  @override
  Widget build(BuildContext context) {
    List<String> imageList = [];
    widget.imgURLs.forEach((item) {imageList.add(item as String);});

    return Center(
        child: Column(
            children: [
              BookMarkTile(imgURLs: widget.imgURLs, name: widget.name, description: widget.description, address: widget.address, imageURL_360: widget.imageURL_360,),
              Row(
                children: [
                  Container(width: 20),
                  Text("Tags: ", style: GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Container(width: 10),
                  Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(toStringOfTags(widget.tags), style: GoogleFonts.delius(fontSize: 18,),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 100)
                ],
              ),
              Row(
                  children: [
                    Container(width: 20),
                    Text("Price: ", style: GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Container(width: 12),
                    Text(PriceRange(widget.price), style: GoogleFonts.delius(fontSize: 18,),),
                  ]
              ),
              Container(height: 30,),
            ]
        )
    );
  }
}