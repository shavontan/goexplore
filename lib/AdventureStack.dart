import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/AdventureTile.dart';
import './AdventurePage.dart';
import 'Return.dart';
import 'homepage.dart';

// GlobalKey<AdventureState> advKey = GlobalKey<AdventureState>();

class AdventureStack extends StatefulWidget {
  const AdventureStack({Key? key}) : super(key: key);

  @override
  AdventureStackState createState() => AdventureStackState();
}

class AdventureStackState extends State<AdventureStack> {
  List<Widget> _stack = [];
  int _index = 0;
  void nextCard() => setState(() => _index += 1);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: getAdventureLocationStreamSnapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final randomDocs = snapshot.data!.docs..shuffle();
          for (int i = 0; i < randomDocs.length; i++) {
            QueryDocumentSnapshot doc = randomDocs[i];
            List<String> imagelist = [];
            doc['imageList'].forEach((item) {imagelist.add(item);});
            print(doc['name']);
            _stack.add(AdventureTile(imageURLs: imagelist, name: doc['name'], address: doc['address'],
                description: doc['description'], imageURL_360: doc['360image']));
          }
          _stack.add(Return());

          return Scaffold(body: Stack(
              children: [
                SingleChildScrollView(child: Stack(children: [
                  SizedBox(child: IndexedStack(children: this._stack, index: _index), height: MediaQuery.of(context).size.height),
                  Positioned(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ])),
                // Adventure(_stack, key: advKey),

              ]
          ));
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
//         stream: getAdventureLocationStreamSnapshots(),
//         builder: (context, snapshot) {
//
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           final randomDocs = snapshot.data!.docs..shuffle();
//           for (int i = 0; i < randomDocs.length; i++) {
//             QueryDocumentSnapshot doc = randomDocs[i];
//             List<String> imagelist = [];
//             doc['imageList'].forEach((item) {imagelist.add(item);});
//             print(doc['name']);
//             _stack.add(AdventureTile(imageURLs: imagelist, name: doc['name'], address: doc['address'],
//                 description: doc['description'], imageURL_360: doc['360image']));
//           }
//           _stack.add(reloadPage());
//
//           return Scaffold(body: Stack(
//             children: [
//               Adventure(_stack, key: advKey),
//               Positioned(
//                 child: IconButton(
//                   icon: Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ]
//           ));
//         }
//     );
//
//   }
//
// }


Stream<QuerySnapshot> getAdventureLocationStreamSnapshots() async* {
  yield* FirebaseFirestore.instance
      .collection('adventure')
      .snapshots();
}

