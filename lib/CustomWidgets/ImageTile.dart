import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';



class ImageTile extends StatefulWidget {
  final String imgURL;

  const ImageTile({required this.imgURL});

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ConstrainedBox(
        //child: SizedBox(
        child: ZoomOverlay(child: Image.network(widget.imgURL, fit: BoxFit.cover,),animationDuration: Duration(milliseconds: 100),),
        //height: MediaQuery.of(context).size.wid - 30,
        //width: MediaQuery.of(context).size.height - 30,),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}