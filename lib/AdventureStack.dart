import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'CustomWidgets/SwipingLocation.dart';
import './AdventurePage.dart';

GlobalKey<AdventureState> advKey = GlobalKey<AdventureState>();
class AdventureStack extends StatelessWidget {
  List<Widget> _stack = [];

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: getAdventureLocationStreamSnapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // final randomDocs = snapshot.data![0].docs..shuffle();
          final randomDocs = snapshot.data!.docs..shuffle();
          for (int i = 0; i < randomDocs.length; i++) {
            print(randomDocs[i]['name']);
            _stack.add(_Card(randomDocs[i]));
          }
          _stack.add(reloadPage());

          return Adventure(_stack, key: advKey);
        }
    );

  }

}


// class AdventureStack extends StatelessWidget {
//   List<Widget> _stack = [];
//
//   @override
//   Widget build(BuildContext context) {
//
//     return StreamBuilder<QuerySnapshot>(
//         stream: getFnb(),
//         builder: (context, snapshot) {
//
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           // final randomDocs = snapshot.data![0].docs..shuffle();
//           final randomDocs = snapshot.data!.docs..shuffle();
//           for (int i = 0; i < randomDocs.length; i++) {
//             print(randomDocs[i]['name']);
//             _stack.add(_Card(randomDocs[i]));
//           }
//           // _stack.add(Text("Reached the end"));
//
//           return StreamBuilder<QuerySnapshot>(
//             stream: getRecreation(),
//             builder: (context, snapshot) {
//
//               if (!snapshot.hasData) {
//                 return Center(child: CircularProgressIndicator());
//               }
//
//               final randomDocs2 = snapshot.data!.docs..shuffle();
//               for (int i = 0; i < randomDocs2.length; i++) {
//                 print(randomDocs2[i]['name']);
//                 _stack.add(_Card(randomDocs2[i]));
//               }
//
//               _stack..shuffle();
//              // _stack.add(Text("Reached the end... :("));
//               _stack.add(reloadPage());
//               return Adventure(_stack, key: advKey, );
//             }
//     );
//         }
//     );
//
//   }
//
// }

// Stream<QuerySnapshot> getFnb() async* {
//   yield* FirebaseFirestore.instance
//       .collection('fnb')
//       .snapshots();
// }
//
// Stream<QuerySnapshot> getRecreation() async* {
//   yield* FirebaseFirestore.instance
//       .collection('recreation')
//       .snapshots();
// }

Stream<QuerySnapshot> getAdventureLocationStreamSnapshots() async* {
  yield* FirebaseFirestore.instance
      .collection('adventure')
      .snapshots();
}


class _Card extends StatelessWidget {

  final DocumentSnapshot doc;
  _Card(this.doc);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SwipingLocation(
        image: Image.network(this.doc['imageURL']),
        title: this.doc['name'],
        description: this.doc['description'],
        estimatedPrice: this.doc['price'],
      ),

    // TextButton(child: Text("No not today"),
    // onPressed: (){advKey.currentState!.nextCard();},)
      AdventureButtons(context),
    ]
    );
  }
}

Widget AdventureButtons(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ClipRRect(
        child: SizedBox(
          height: 40,
          width: 120,
          child: Container(
            child: TextButton(
              child: Text("No, not today", style: GoogleFonts.quando(color: Colors.black)),
              onPressed: () {
                advKey.currentState!.nextCard();
              },
            ),
            color: Color(0xFFB9E7CF),
          ),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),

      ClipRRect(
        child: SizedBox(
          height: 40,
          width: 120,
          child: Container(
            child: TextButton(
                child: Text("Let's go!", style: GoogleFonts.quando(color: Colors.black)),
                onPressed: () {

                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {

                      return Screenshot(
                          controller: screenshotController,
                          child: ClassicGeneralDialogWidget(
                            titleText: 'Title',
                            contentText: 'content',
                            onPositiveClick: () {
                              screenshotController.capture().then((Uint8List image) {
                                //Capture Done
                                // setState(() {
                                //   imageFile = image;
                                // });
                              }).catchError((onError) {
                                print(onError);
                              });

                              Navigator.of(context).pop();
                            },
                            // onNegativeClick: () {
                            //   Navigator.of(context).pop();
                            // },
                          ));
                    },
                    animationType: DialogTransitionType.rotate3D,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 1),
                  );
                }
            ),
            color: Color(0xFFB9E7CF),
          ),
        ),
        borderRadius: BorderRadius.circular(10.0),
      )
    ],
  );
}

class reloadPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(50),
        child: Column(
        children: [
          Text("Oh no, we ran out of places! :("),
          TextButton(
            child: Row(
              children: [
                Icon(Icons.refresh_outlined),
                Text("Refresh"),
              ]
            ),
            onPressed: () {
              advKey.currentState!.reset();
            }
          ),
        ]
    )
    );
  }
}