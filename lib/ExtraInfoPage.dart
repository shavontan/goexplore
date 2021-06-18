import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/ExtraInfo.dart';
import 'package:panorama/panorama.dart';



class ExtraInfoPage extends StatefulWidget {
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;

  const ExtraInfoPage({required this.imgURLs, required this.name, required this.description, required this.address, required this.imageURL_360});


  @override
  _ExtraInfoPageState createState() => _ExtraInfoPageState();
}

class _ExtraInfoPageState extends State<ExtraInfoPage> {
  bool activate360 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Extra info about ' + widget.name, style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),),
        body: Stack(
            children: [
              ExtraInfo(imgURLs: widget.imgURLs, name: widget.name, description: widget.description, address: widget.address,),
              Visibility(child: Panorama(
                child: Image.network(widget.imageURL_360),
              ),
                  visible: activate360),
              IconButton(
                icon: Icon(Icons.threed_rotation, size: 40, color: Colors.black),
                onPressed: () {
                  setState(() {
                    activate360 = !activate360;
                  });
                },
              )
            ]));
  }
}