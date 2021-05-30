import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './flutterfire.dart';

class History extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: getUsersHistoryStreamSnapshots(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return new Scaffold(
                  appBar: AppBar(
                    title: Text(
                        'History', style: TextStyle(color: Colors.black)),
                    backgroundColor: Color(0xB6C4CAE8),
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ),
                  body: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildCard(context, snapshot.data!.docs[index])
                  ));
            }
        )
    );
  }

  Stream<QuerySnapshot> getUsersHistoryStreamSnapshots(
      BuildContext context) async* {
    final uid = await getCurrentUID();
    yield* FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('history')
        .snapshots();
  }

  Widget buildCard(BuildContext context, DocumentSnapshot location) {
    List<dynamic> arr = location['dates'];
    String result = "";
    for (int i = 0; i < arr.length; i++) {
      result = result + arr[i].toDate().toString() + "\n";
    }

    return new Container(
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
                          Text(location['name'],
                            style: new TextStyle(fontSize: 30.0),),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          Text(result),
                        ]),
                      )
                    ]
                )
            )

        )
    );
  }
}