import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
// DEPENDS ON HOW THE DATA IS STORED

import 'CustomWidgets/SwipingLocation.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'AdventureStack.dart';

class Adventure extends StatefulWidget {
  const Adventure(this.stack, {Key? key}) : super(key: key);

  final List<Widget> stack;
 // Adventure(this.stack);

  @override
  AdventureState createState() => AdventureState(this.stack);
}

List<_Card> _Cards = [];
//
Uint8List imageFile = Uint8List(0);
ScreenshotController screenshotController = ScreenshotController();
//

class AdventureState extends State<Adventure> {
  int _index = 0;
  List<Widget> stack;
  AdventureState(this.stack);

  // Uint8List _imageFile = Uint8List(0);
  // ScreenshotController screenshotController = ScreenshotController();

  void nextCard() => setState(() => _index += 1);
  void reset() => setState(() {
    stack.removeLast();
    stack..shuffle();
    stack.add(reloadPage());
    _index = 0;
  });

  @override
  Widget build(BuildContext context) {

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Let's Go on an Adventure!", style: TextStyle(color: Colors.black)),
              backgroundColor: Color(0xB6C4CAE8),
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            body: SingleChildScrollView(child: Column(children: [
              IndexedStack(children: this.stack, index: _index),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     ClipRRect(
              //       child: SizedBox(
              //         height: 40,
              //         width: 120,
              //         child: Container(
              //           child: TextButton(
              //               child: Text("No, not today", style: GoogleFonts.quando(color: Colors.black)),
              //               onPressed: () {
              //                 setState(() => _index += 1);
              //               },
              //           ),
              //           color: Color(0xFFB9E7CF),
              //         ),
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //
              //     ClipRRect(
              //       child: SizedBox(
              //         height: 40,
              //         width: 120,
              //         child: Container(
              //           child: TextButton(
              //               child: Text("Let's go!", style: GoogleFonts.quando(color: Colors.black)),
              //               onPressed: () {
              //
              //                 showAnimatedDialog(
              //                   context: context,
              //                   barrierDismissible: true,
              //                   builder: (BuildContext context) {
              //
              //                     return Screenshot(
              //                         controller: screenshotController,
              //                         child: ClassicGeneralDialogWidget(
              //                       titleText: 'Title',
              //                       contentText: 'content',
              //                       onPositiveClick: () {
              //                         screenshotController.capture().then((Uint8List image) {
              //                           //Capture Done
              //                           setState(() {
              //                             _imageFile = image;
              //                           });
              //                         }).catchError((onError) {
              //                           print(onError);
              //                         });
              //
              //                         Navigator.of(context).pop();
              //                       },
              //                       // onNegativeClick: () {
              //                       //   Navigator.of(context).pop();
              //                       // },
              //                     ));
              //                   },
              //                   animationType: DialogTransitionType.rotate3D,
              //                   curve: Curves.fastOutSlowIn,
              //                   duration: Duration(seconds: 1),
              //                 );
              //               }
              //           ),
              //           color: Color(0xFFB9E7CF),
              //         ),
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     )
              //   ],
              // ),
        ]
            ))
    );
    //     }
    // );
  }
}

class _Card extends StatelessWidget {

  final DocumentSnapshot doc;
  _Card(this.doc);

  @override
  Widget build(BuildContext context) {
    return
            SwipingLocation(
                image: Image.network(this.doc['imageURL']),
                title: this.doc['name'],
                description: this.doc['description'],
                estimatedPrice: this.doc['price'],
            );
  }
}


