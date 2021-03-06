import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bookmarksbar.dart';
import 'ExtraInfo.dart';
import 'package:panorama/panorama.dart';

// HOW TO USE:
// call: SwipingTile(imageURLs: ???, name: ???, address: ???, description: ???, imageURL_360: ???,)



class SwipingTile extends StatefulWidget {
  final List<String> imageURLs;
  final String imageURL_360;
  final String name;
  final String description;
  final String address;
  final bool isSponsored;

  const SwipingTile({required this.imageURLs, required this.imageURL_360, required this.name, required this.description, required this.address, required this.isSponsored});

  @override
  _SwipingTileState createState() => _SwipingTileState();
}

class _SwipingTileState extends State<SwipingTile> {
  bool activate360 = false;         // when activateExtraInfo = true --> activate360 will not change (need to do this check twice)
  bool activateExtraInfo = false;

  double _lon = 0;
  double _lat = 0;
  double _tilt = 0;

  void onViewChanged(longitude, latitude, tilt) {
    setState(() {
      _lon = longitude;
      _lat = latitude;
      _tilt = tilt;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(child:
              InkWell(
                child: Opacity(
                  child: Panorama(
                    animSpeed: 0.1,
                    sensorControl: SensorControl.Orientation,
                    onViewChanged: onViewChanged,
                    child: Image.network(widget.imageURL_360),
                  ),
                  opacity: activateExtraInfo ? 0.3 : 1,),
                onDoubleTap: () {
                  setState(() {
                    activate360 = !activate360;
                  });
                },
                onLongPress: () {
                  setState(() {
                    activate360 = false;
                    activateExtraInfo = true;
                  });
                },
              ),
                absorbing: !activate360,
              ),
              Visibility(
                child: InkWell(
                  child: SizedBox(height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
                  onDoubleTap: () {
                    setState(() {
                      activate360 = !activate360;
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      activateExtraInfo = true;
                    });
                  },
                ),
                visible: !activate360,
              ),
              Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 30),
                    ExtraInfo(imgURLs: widget.imageURLs, name: widget.name, address: widget.address, description: widget.description,),
                    IconButton(onPressed: () {
                      setState(() {
                        activateExtraInfo = false;
                      });
                    }, icon: Icon(Icons.cancel,)),
                  ],
                ),
                visible: activateExtraInfo,
              ),
              Visibility(
                  child: Positioned(
                      child: Icon(Icons.threed_rotation, color: activate360 ? Colors.green : Colors.redAccent, size: 30,),
                      top: 35,
                      left: 45),
                  visible: !activateExtraInfo),
              Visibility(
                child: Positioned(
                    child: Text("Sponsored", style: GoogleFonts.rancho(color: Colors.red, fontSize: 30),),
                    top: 30,
                    left: (MediaQuery.of(context).size.width / 2) - 45),
                visible: widget.isSponsored,
              )
            ]
        )
    );
  }
}