import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ExtraInfo.dart';
import 'package:panorama/panorama.dart';

// HOW TO USE:
// call: AdventureTile(imageURLs: ???, name: ???, address: ???, description: ???, imageURL_360: ???,)



class AdventureTile extends StatefulWidget {
  final List<String> imageURLs;
  final String imageURL_360;
  final String name;
  final String description;
  final String address;

  const AdventureTile({required this.imageURLs, required this.imageURL_360, required this.name, required this.description, required this.address});

  @override
  _AdventureTileState createState() => _AdventureTileState();
}

class _AdventureTileState extends State<AdventureTile> {
  bool activate360 = false;         // when activateExtraInfo = true --> activate360 will not change (need to do this check twice)
  bool activateExtraInfo = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(child:
              InkWell(child: Panorama(
                child: Image.network(widget.imageURL_360),
              ),
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
                    Container(height: 30),
                    Row(
                        children: [
                          Container(width: 42),
                          InkWell(
                            child: SizedBox(child: Text("Let's Go!", style: GoogleFonts.hiMelody(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),), height: 32, width: 150),
                            onTap: () {
// GO ON ADVENTURE ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                            },
                          ),
                          InkWell(
                            child: SizedBox(child: Text("No, Not Today", style: GoogleFonts.hiMelody(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black26)), height: 32, width: 150),
                            onTap: () {
// GIVE ANOTHER LOCATION ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                            },
                          ),
                          Container(width: 18),
                        ]
                    ),
                    Container(height: 15)
                  ],
                ),
                visible: activateExtraInfo,
              ),
              Visibility(
                  child: Positioned(
                      child: Icon(activate360 ? Icons.lock_open_outlined : Icons.lock, color: activate360 ? Colors.green : Colors.redAccent),
                      top: 40,
                      left: 20),
                  visible: !activateExtraInfo),
            ]
        )
    );
  }
}