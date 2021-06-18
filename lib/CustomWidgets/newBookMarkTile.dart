import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ExtraInfoPage.dart';


// How to use:
// BookMarkTile(imgURLs: ???, name: ???, description: ???, address: ???, imageURL_360 = ???)




class BookMarkTile extends StatefulWidget {
  // const BookMarkTile({Key key}) : super(key: key);
  final List<dynamic> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;

  const BookMarkTile({required this.imgURLs, required this.name, required this.description, required this.address, required this.imageURL_360});


  @override
  _BookMarkTileState createState() => _BookMarkTileState();
}

class _BookMarkTileState extends State<BookMarkTile> {

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [];
    widget.imgURLs.forEach((item) {imageList.add(item as String);});

    return Center(
      child: InkWell(
          child: Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 30,
                  child: ClipRRect(
                    child: Opacity(
                      child: Image.network(imageList[0], fit: BoxFit.cover), opacity: 0.3,), borderRadius: BorderRadius.circular(10.0),),
                ),
                Positioned.fill(
                  child: Align(
                    child: ConstrainedBox(
                      child: Text(widget.name, style: GoogleFonts.neucha(fontSize: 50, fontWeight: FontWeight.bold)),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 30, maxHeight: 200),),
                    alignment: Alignment.center,),
                ),]),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ExtraInfoPage(imgURLs: imageList, name: widget.name, description: widget.description, address: widget.address, imageURL_360: widget.imageURL_360),),);
          }
      ),
    );
  }
}