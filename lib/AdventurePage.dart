// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:async/async.dart';
// // DEPENDS ON HOW THE DATA IS STORED
//
// import 'CustomWidgets/AdventureTile.dart';
// import 'CustomWidgets/SwipingLocation.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
// import 'AdventureStack.dart';
//
// class Adventure extends StatefulWidget {
//   const Adventure(this.stack, {Key? key}) : super(key: key);
//
//   final List<Widget> stack;
//  // Adventure(this.stack);
//
//   @override
//   AdventureState createState() => AdventureState(this.stack);
// }
//
// class AdventureState extends State<Adventure> {
//   int _index = 0;
//   List<Widget> stack;
//   AdventureState(this.stack);
//
//   void nextCard() => setState(() => _index += 1);
//   // void reset() => setState(() {
//   //   stack.removeLast();
//   //   stack..shuffle();
//   //   stack.add(reloadPage());
//   //   _index = 0;
//   // });
//
//   @override
//   Widget build(BuildContext context) {
//
//           return Scaffold(
//             // backgroundColor: Colors.white,
//             // appBar: AppBar(
//             //   title: Text("Let's Go on an Adventure!", style: TextStyle(color: Colors.black)),
//             //   backgroundColor: Color(0xB6C4CAE8),
//             //   elevation: 0.0,
//             //   leading: IconButton(
//             //     icon: Icon(Icons.arrow_back, color: Colors.white),
//             //     onPressed: () {
//             //       Navigator.pop(context, false);
//             //     },
//             //   ),
//             // ),
//             body: SingleChildScrollView(child: Column(children: [
//               SizedBox(child: IndexedStack(children: this.stack, index: _index), height: MediaQuery.of(context).size.height),
//         ]
//             ))
//     );
//     //     }
//     // );
//   }
// }


