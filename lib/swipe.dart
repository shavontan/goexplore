import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CustomWidgets/SwipingTile.dart';
import 'flutterfire.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:random_color/random_color.dart';
import './bookmarksbar.dart';

import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';

// // import 'package:geolocation/geolocation.dart';
// // import 'package:location/location.dart';
//
// // beautiful popup imports
// import 'package:flutter_beautiful_popup/main.dart';
// import 'package:flutter_beautiful_popup/templates/Authentication.dart';
// import 'package:flutter_beautiful_popup/templates/BlueRocket.dart';
// import 'package:flutter_beautiful_popup/templates/Camera.dart';
// import 'package:flutter_beautiful_popup/templates/Coin.dart';
// import 'package:flutter_beautiful_popup/templates/Common.dart';
// import 'package:flutter_beautiful_popup/templates/Fail.dart';
// import 'package:flutter_beautiful_popup/templates/Geolocation.dart';
// import 'package:flutter_beautiful_popup/templates/Gift.dart';
// import 'package:flutter_beautiful_popup/templates/GreenRocket.dart';
// import 'package:flutter_beautiful_popup/templates/Notification.dart';
// import 'package:flutter_beautiful_popup/templates/OrangeRocket.dart';
// import 'package:flutter_beautiful_popup/templates/OrangeRocket2.dart';
// import 'package:flutter_beautiful_popup/templates/RedPacket.dart';
// import 'package:flutter_beautiful_popup/templates/Success.dart';
// import 'package:flutter_beautiful_popup/templates/Term.dart';
// import 'package:flutter_beautiful_popup/templates/Thumb.dart';

import 'package:huawei_location/location/fused_location_provider_client.dart';
import 'package:huawei_location/location/location.dart';
import 'package:huawei_location/location/location_request.dart';
import 'package:huawei_location/permission/permission_handler.dart';


// Link to DB

class Swipe extends StatefulWidget {

  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  Swipe(this.category, this.price, this.tags, this.dist);

  @override
  _SwipeState createState() => _SwipeState(this.category, this.price, this.tags, this.dist);
}


final globalKey = GlobalKey<BookmarksBarState>();

class _SwipeState extends State<Swipe> {
  // Dynamically load _Cards from database

  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  _SwipeState(this.category, this.price, this.tags, this.dist);

  List<_Card> _Cards = [];

  @override
  Widget build(BuildContext context) {
    // Stack of _Cards that can be swiped. Set width, height, etc here.

    return Container(

        // Important to keep as a stack to have overlay of _Cards.

        child: FutureBuilder<List<QueryDocumentSnapshot>>(
            future: getLocationStreamSnapshots(context, this.category, this.price, this.tags, this.dist),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              }

              final randomDocs = snapshot.data!..shuffle();
              final length = randomDocs.length;

              for (int i = 0; i < length; i++) {
                _Cards.add(
                    _Card(randomDocs[i])
                );

                // print(randomDocs.length);
                // print(randomDocs[i]['name']);
              }

              return Scaffold(
                // appBar: AppBar(
                //   title: Text("Let's Explore!", style: TextStyle(color: Colors.black)),
                //   backgroundColor: Color(0xB6C4CAE8),
                //   elevation: 0.0,
                //   leading: IconButton(
                //     icon: Icon(Icons.arrow_back, color: Colors.white),
                //     onPressed: () {
                //       Navigator.pop(context, false);
                //     },
                //   ),
                //   // actions: [
                //   //   IconButton(
                //   //       icon: Icon(Icons.account_circle, color: Colors.white),
                //   //       onPressed: () {
                //   //         Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),),);
                //   //       })
                //   // ],
                // ),
                body: Stack(children: _Cards),
                //bottomNavigationBar: SingleChildScrollView(child: BookmarksBar(key: globalKey), scrollDirection: Axis.horizontal,),
              );
            }
        )
      // child: Stack(
      //   children: _Cards,
      // ),
    );
  }
}

class _Card extends StatelessWidget {
  // Made to distinguish _Cards
  // Add your own applicable data here
  final DocumentSnapshot doc;
  _Card(this.doc);

  @override
  Widget build(BuildContext context) {

    List<String> images = [];
    doc['imageList'].forEach((item) {
      images.add(item as String);
    });

    return Stack(
        children: [Swipable(
      // Set the swipable widget
        child: SwipingTile(address: doc['address'], description: doc['description'],
          imageURL_360: doc['360image'], imageURLs: images, name: doc['name'],),
        onSwipeDown: (finalPosition) async {

          List<dynamic> bookmarks = await getBookmarks();
          String uid = await getCurrentUID();
          final List<bool> isSelected = globalKey.currentState!.isSelected;
          for (int i = 0; i < isSelected.length; i++) {
            if (isSelected[i]) {
              String bookmarkName = bookmarks[i] as String;
              FirebaseFirestore.instance.collection('users')
                  .doc(uid)
                  .collection(bookmarkName)
                  .doc(doc['name'])
                  .set({
                'name' : doc['name'],
                'description' : doc['description'],
                'price' : doc['price'],
                'address' : doc['address'],
                'tags' : doc['tags'],
                'imageList' : doc['imageList'],
                '360image' : doc['360image'],
              });
            }

          }
          globalKey.currentState!.resetSelection();

        }

      // onSwipeRight, left, up, down, cancel, etc...
    ),
        Positioned(child: SingleChildScrollView(child: BookmarksBar(key: globalKey), scrollDirection: Axis.horizontal,),
        left: 2, top: 725),
        Positioned(child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          )

        ]
    );
  }
}

// Stream<QuerySnapshot> getLocationStreamSnapshots(
//     BuildContext context, String category, int price, List<String> tags) async* {
//
//   yield* FirebaseFirestore.instance
//       .collection(category)
//       .where('price', isLessThanOrEqualTo: price)
//       .snapshots();
//
// }

Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots(
    BuildContext context, String category, int price, List<String> tags, double dist) async {

  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection(category)
      .where('price', isLessThanOrEqualTo: price)
      .get();
  //
  // Stream<QueryDocumentSnapshot> docsStream = Stream.fromIterable(qs
  //     .docs
  //     .where((d) => checkTags(d['tags'], tags)));

  Iterable<QueryDocumentSnapshot> docsStream = qs
      .docs
      .where((d) => checkTags(d['tags'], tags));

  // Init PermissionHandler
  bool status;
  PermissionHandler permissionHandler = PermissionHandler();
  // Request location permissions
  status = await permissionHandler.requestLocationPermission();

  if (!status) {
    return docsStream.toList();
  }

  FusedLocationProviderClient locationService = FusedLocationProviderClient();
  LocationRequest locationRequest = new LocationRequest();
  locationRequest.numUpdates = 1;

  await locationService.requestLocationUpdates(locationRequest);
  Location curr = await locationService.getLastLocation();
  double lat = curr.latitude;
  double long = curr.longitude;


  List<QueryDocumentSnapshot> docsList = [];
  for (QueryDocumentSnapshot d in docsStream) {
    if(await checkDist(d, dist, status, lat, long)) {
      docsList.add(d);
    }
  }

  return docsList;

}

bool checkTags(List<dynamic> doc, List<String> tag) {

  if (tag.contains('Indoor') && tag.contains('Outdoor')) {
    tag.remove('Indoor');
    tag.remove('Outdoor');
  }

  if (tag.contains('Physical') && tag.contains('Leisure')) {
    tag.remove('Physical');
    tag.remove('Leisure');
  }

  if (tag.any((item) => doc.contains(item)) && doc.length > 0 || tag.length == 0) {
    return true;
  } else {
    return false;
  }
}

Future<bool> checkDist(QueryDocumentSnapshot doc, double requiredDist, bool status, double lat, double long) async {

  List<gc.Location> locations = await gc.locationFromAddress(doc['address']);
  double distanceInKM = Geolocator.distanceBetween(lat, long, locations[0].latitude, locations[0].longitude) * 0.001;
  return distanceInKM < requiredDist;

}



