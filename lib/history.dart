import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goexplore/ProfilePage.dart';
import 'package:google_fonts/google_fonts.dart';
import './flutterfire.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ExtraInfoPage.dart';

class History extends StatefulWidget {

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  bool confused = false;

  @override
  Widget build(BuildContext context) {

      return Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: getUsersHistoryStreamSnapshots(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return

                      Scaffold(
                    appBar: AppBar(
                      title: Text(
                          'History', style: GoogleFonts.delius(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23)),
                      backgroundColor: Color(0xB6C4CAE8),
                      elevation: 0.0,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                        actions: [
                          IconButton(
                              icon: Icon(Icons.help_outline, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  confused = true;
                                });
                              }),
                        ]
                    ),
                    body:

                    Stack(children: [ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildCard(context, snapshot.data!.docs[index]),

                    ),

                      Visibility(
                        visible: confused,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              color: Colors.white,
                              height: 500,
                              width: 275,
                              child: Column(
                                children: [
                                  Container(height: 10),
                                  SizedBox(
                                      child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(height: 10),
                                              Text.rich(
                                                TextSpan(
                                                  text: "Features about this page",
                                                  style: GoogleFonts.delius(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                    text: "",
                                                    style: GoogleFonts.delius(
                                                      fontSize: 15,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                          "This page displays all the locations you have visited."),
                                                    ]),
                                              ),
                                              Container(height: 50),
                                              Text.rich(
                                                TextSpan(
                                                  text: "Tap (Tile):",
                                                  style: GoogleFonts.delius(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                    text: "",
                                                    style: GoogleFonts.delius(
                                                      fontSize: 15,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                          "This will bring you to a new page that provides"),
                                                      TextSpan(
                                                          text: " extra information ",
                                                          style: GoogleFonts.delius(
                                                              color: Colors.pinkAccent)),
                                                      TextSpan(
                                                          text:
                                                          "about this particular location you have visited."),
                                                    ]),
                                              ),

                                            ],
                                          )),
                                      height: 420,
                                      width: 250),
                                  Container(height: 10),
                                  TextButton(
                                    child: Text(
                                      "Close",
                                      style: GoogleFonts.delius(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        confused = false;
                                      });
                                    },
                                  ),
                                  Container(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )]));
              }
          )
      );
  }
}


// class History extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: StreamBuilder<QuerySnapshot>(
//             stream: getUsersHistoryStreamSnapshots(context),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return CircularProgressIndicator();
//               }
//               return new Scaffold(
//                   appBar: AppBar(
//                     title: Text(
//                         'History', style: TextStyle(color: Colors.black)),
//                     backgroundColor: Color(0xB6C4CAE8),
//                     elevation: 0.0,
//                     leading: IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white),
//                       onPressed: () {
//                         Navigator.pop(context, false);
//                       },
//                     ),
//                   ),
//                   body: ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (BuildContext context, int index) =>
//                           buildCard(context, snapshot.data!.docs[index]),
//
//                   ));
//             }
//         )
//     );
//   }

  Stream<QuerySnapshot> getUsersHistoryStreamSnapshots(
      BuildContext context) async* {
    final uid = await getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('latestTime', descending: true)
        .snapshots();
  }

  Widget buildCard(BuildContext context, DocumentSnapshot location) {
    List<dynamic> arr = location['dates'];
    String result = "";
    for (int i = 0; i < arr.length; i++) {
      result = result + new DateFormat("yyyy-MM-dd     hh:mm").format(arr[i].toDate()) + "\n";
    }

    return GestureDetector(
        onTap: () async {

          String locationName = location['name'];
          String category = location['category'];

          DocumentSnapshot ds = await FirebaseFirestore.instance
              .collection(category)
              .doc(locationName)
              .get();

          List<dynamic> dynamicList = ds['imageList'];
          List<String> imageList = [];
          for (int i = 0; i < dynamicList.length; i++) {
          imageList.add(dynamicList[i] as String);
          }

            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ExtraInfoPage(
              imgURLs: imageList,
              name: ds['name'],
              description: ds['description'],
              address: ds['address'],
              imageURL_360: ds['360image'], showBookmark: true,
              )));

        },
        child: Container(
        child:
        Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          Image.network(location['imageURL'],
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.2,
                              alignment: Alignment.center,
                              ),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          ConstrainedBox(child: Text(location['name'],
                            style: GoogleFonts.delius(fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width -50,),),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          Text(result, style: GoogleFonts.delius()),
                        ]),
                      )
                    ]
                )
            )

        )
    )
    );
  }

