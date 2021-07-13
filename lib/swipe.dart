import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:ml_linalg/matrix.dart';
import 'CustomWidgets/SwipingTile.dart';
import 'RecommenderSystem.dart';
import 'Return.dart';
import 'flutterfire.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:random_color/random_color.dart';
import './bookmarksbar.dart';

import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';

// // import 'package:geolocation/geolocation.dart';
// // import 'package:location/location.dart';

// import 'package:huawei_location/location/fused_location_provider_client.dart';
// import 'package:huawei_location/location/location.dart';
// import 'package:huawei_location/location/location_request.dart';
// import 'package:huawei_location/permission/permission_handler.dart';

// Link to DB

Stopwatch stopwatch = new Stopwatch();

class Swipe extends StatefulWidget {
  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  Swipe(this.category, this.price, this.tags, this.dist);

  @override
  _SwipeState createState() =>
      _SwipeState(this.category, this.price, this.tags, this.dist);
}

final globalKey = GlobalKey<BookmarksBarState>();

class _SwipeState extends State<Swipe> {
  // Dynamically load _Cards from database

  final String category;
  final int price;
  final List<String> tags;
  final double dist;
  bool confused = false;

  int index = 0;
  bool first = true;
  List<DocumentSnapshot> finalList = [];

  _SwipeState(this.category, this.price, this.tags, this.dist);

  List<String> locationNames = [];

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<double>>(
        future: getUserTimes(this.category),
        builder: (context, snapshotTime) {

          if (!isLoggedIn()) {
              return FutureBuilder<List<DocumentSnapshot>>(
                    future: getLocationStreamSnapshots(
                        context, this.category, this.price, this.tags),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return Scaffold(
                            appBar: AppBar(
                              title: Text('', style: TextStyle(color: Colors.black)),
                              backgroundColor: Color(0xB6C4CAE8),
                              elevation: 0.0,
                              leading: IconButton(
                                icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                                onPressed: () {
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                                  Navigator.pop(context);
                                },
                              ),),
                            body: Center(child: CircularProgressIndicator()),
                            backgroundColor: Colors.white);
                      }

                      final randomDocs = snapshot.data!;
                      final length = randomDocs.length;

                      if (first) {
                        finalList.addAll(randomDocs);
                      }

                      print("1");
                      for (int i = 0; i < finalList.length; i++) {
                        print(finalList[i]['name']);
                      }

                      stopwatch.reset();
                      stopwatch.start();

                      return new Scaffold(
                          resizeToAvoidBottomInset: false,
                          body:
                      Stack(children: [

                        new LazyIndexedStack(
                          reuse: false,
                          index: index,
                          itemBuilder: (c, i) {

                            if (i == finalList.length-1) {
                              return Return();
                            }

                            List<String> images = [];
                            for (int j = 0; j < finalList[i]['imageList'].length; j++) {
                              images.add(finalList[i]['imageList'][j] as String);
                            }
                            String category = "";
                            if (finalList[i]['isFnb']) {
                              category = "fnb";
                            } else {
                              category = "recreation";
                            }
                            return

                              Swipable(child: SwipingTile(
                                address: finalList[i]['address'],
                                description: finalList[i]['description'],
                                imageURL_360: finalList[i]['360image'],
                                imageURLs: images,
                                name: finalList[i]['name'],
                              ),
                                  onSwipeDown: (finalPosition) async {
                                    if (isLoggedIn()) {

                                      stopwatch.stop();
                                      double time = stopwatch.elapsedMilliseconds / 1000;

                                      updateAvgTimeSeen(category, finalList[i]['name'], time);
                                      stopwatch.reset();
                                      stopwatch.start();

                                      List<dynamic> bookmarks = await getBookmarks();
                                      String uid = await getCurrentUID();
                                      final List<bool> isSelected = globalKey.currentState!.isSelected;
                                      for (int j = 0; j < isSelected.length; j++) {
                                        if (isSelected[j]) {
                                          String bookmarkName = bookmarks[j] as String;
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .collection(bookmarkName)
                                              .doc(finalList[i]['name'])
                                              .set({
                                            'name': finalList[i]['name'],
                                            'description': finalList[i]['description'],
                                            'price': finalList[i]['price'],
                                            'address': finalList[i]['address'],
                                            'tags': finalList[i]['tags'],
                                            'imageList': finalList[i]['imageList'],
                                            '360image': finalList[i]['360image'],
                                          });
                                        }
                                      }
                                      globalKey.currentState!.resetSelection();
                                    }

                                    setState(() {index += 1; first=false;});

                                  },
                                  onSwipeUp: (finalPosition) {

                                    if (isLoggedIn()) {
                                      stopwatch.stop();
                                      double time = stopwatch.elapsedMilliseconds / 1000;
                                      updateAvgTimeSeen(category, finalList[i]['name'], time);
                                      stopwatch.reset();
                                      stopwatch.start();
                                    }

                                    setState(() {index += 1; first=false;});

                                  },
                                  onSwipeLeft: (finalPosition) {

                                    if (isLoggedIn()) {
                                      stopwatch.stop();
                                      double time = stopwatch.elapsedMilliseconds / 1000;
                                      updateAvgTimeSeen(category, finalList[i]['name'], time);
                                      stopwatch.reset();
                                      stopwatch.start();
                                    }
                                    setState(() {index += 1;first=false;});

                                  },

                                  onSwipeRight: (finalPosition) {

                                    if (isLoggedIn()) {
                                      stopwatch.stop();
                                      double time = stopwatch.elapsedMilliseconds / 1000;
                                      updateAvgTimeSeen(category, finalList[i]['name'], time);
                                      stopwatch.reset();
                                      stopwatch.start();
                                    }
                                    setState(() {index += 1;first=false;});

                                  });
                          },
                          itemCount: finalList.length,
                        ),
                        BrowseBar(),])
                      );



                    });
              // child: Stack(
              //   children: _Cards,
              // ),
          }

          if (!snapshotTime.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('', style: TextStyle(color: Colors.black)),
                  backgroundColor: Color(0xB6C4CAE8),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                      Navigator.pop(context);
                    },
                  ),),
                body: Center(child: CircularProgressIndicator()),
                backgroundColor: Colors.white);
          }


          List<double> userTimes = snapshotTime.data!;

          if (Matrix.fromList([userTimes]).sum() == 0 || !isLoggedIn()) {

            return FutureBuilder<List<QueryDocumentSnapshot>>(
                future: getLocationStreamSnapshots(
                    context, this.category, this.price, this.tags),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Scaffold(
                        appBar: AppBar(
                          title: Text('', style: TextStyle(color: Colors.black)),
                          backgroundColor: Color(0xB6C4CAE8),
                          elevation: 0.0,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                              Navigator.pop(context);
                            },
                          ),),
                        body: Center(child: CircularProgressIndicator()),
                        backgroundColor: Colors.white);
                  }

                  final randomDocs = snapshot.data!;
                  final length = randomDocs.length;

                  if (first) {
                    finalList.addAll(randomDocs);
                  }

                  print("2");
                  for (int i = 0; i < finalList.length; i++) {
                    print(finalList[i]['name']);
                  }

                  stopwatch.reset();
                  stopwatch.start();

                  return new Scaffold(
                      resizeToAvoidBottomInset: false,
                      body:
                  Stack(children: [

                    new LazyIndexedStack(
                      reuse: false,
                      index: index,
                      itemCount: finalList.length,
                      itemBuilder: (c, i) {

                        if (i == finalList.length-1) {
                          return Return();
                        }

                        List<String> images = [];
                        for (int j = 0; j < finalList[i]['imageList'].length; j++) {
                          images.add(finalList[i]['imageList'][j] as String);
                        }
                        String category = "";
                        if (finalList[i]['isFnb']) {
                          category = "fnb";
                        } else {
                          category = "recreation";
                        }
                        return

                          Swipable(child: SwipingTile(
                            address: finalList[i]['address'],
                            description: finalList[i]['description'],
                            imageURL_360: finalList[i]['360image'],
                            imageURLs: images,
                            name: finalList[i]['name'],
                          ),
                              onSwipeDown: (finalPosition) async {
                                if (isLoggedIn()) {

                                  stopwatch.stop();
                                  double time = stopwatch.elapsedMilliseconds / 1000;

                                  updateAvgTimeSeen(category, finalList[i]['name'], time);
                                  stopwatch.reset();
                                  stopwatch.start();

                                  List<dynamic> bookmarks = await getBookmarks();
                                  String uid = await getCurrentUID();
                                  final List<bool> isSelected = globalKey.currentState!.isSelected;
                                  for (int j = 0; j < isSelected.length; j++) {
                                    if (isSelected[j]) {
                                      String bookmarkName = bookmarks[j] as String;
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .collection(bookmarkName)
                                          .doc(finalList[i]['name'])
                                          .set({
                                        'name': finalList[i]['name'],
                                        'description': finalList[i]['description'],
                                        'price': finalList[i]['price'],
                                        'address': finalList[i]['address'],
                                        'tags': finalList[i]['tags'],
                                        'imageList': finalList[i]['imageList'],
                                        '360image': finalList[i]['360image'],
                                      });
                                    }
                                  }
                                  globalKey.currentState!.resetSelection();
                                }

                                setState(() {index += 1; first=false;});

                              },
                              onSwipeUp: (finalPosition) {

                                if (isLoggedIn()) {
                                  stopwatch.stop();
                                  double time = stopwatch.elapsedMilliseconds / 1000;
                                  updateAvgTimeSeen(category, finalList[i]['name'], time);
                                  stopwatch.reset();
                                  stopwatch.start();
                                }

                                setState(() {index += 1; first=false;});

                              },
                              onSwipeLeft: (finalPosition) {

                                if (isLoggedIn()) {
                                  stopwatch.stop();
                                  double time = stopwatch.elapsedMilliseconds / 1000;
                                  updateAvgTimeSeen(category, finalList[i]['name'], time);
                                  stopwatch.reset();
                                  stopwatch.start();
                                }
                                setState(() {index += 1;first=false;});

                              },

                              onSwipeRight: (finalPosition) {

                                if (isLoggedIn()) {
                                  stopwatch.stop();
                                  double time = stopwatch.elapsedMilliseconds / 1000;
                                  updateAvgTimeSeen(category, finalList[i]['name'], time);
                                  stopwatch.reset();
                                  stopwatch.start();
                                }
                                setState(() {index += 1;first=false;});

                              });
                      },
                    ),
                    BrowseBar(),])
                  );
                });
          }

          locationNames = new Recommender(num_rec: 51, userTimes: userTimes, filters: this.tags, isFnB: this.category=="fnb").getRecommendations();

          return FutureBuilder<List<QueryDocumentSnapshot>>(
              future: getLocations(this.category, locationNames, this.price, this.tags),
              builder: (context, snapshot) {


                if (!snapshot.hasData) {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text('', style: TextStyle(color: Colors.black)),
                        backgroundColor: Color(0xB6C4CAE8),
                        elevation: 0.0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                            Navigator.pop(context);
                          },
                        ),),
                      body: Center(child: CircularProgressIndicator()),
                      backgroundColor: Colors.white);
                }

                final randomDocs = snapshot.data!;
                final length = randomDocs.length;

                if (first) {
                  finalList.addAll(randomDocs);
                }

                print("3");
                for (int i = 0; i < finalList.length; i++) {
                  print(finalList[i]['name']);
                }

                stopwatch.reset();
                stopwatch.start();

                return new Scaffold(
                    resizeToAvoidBottomInset: false,
                    body:
                Stack(children: [

                  new LazyIndexedStack(
                    reuse: false,
                    index: index,
                    itemBuilder: (c, i) {

                      if (i == finalList.length-1) {
                        return Return();
                      }

                      List<String> images = [];
                      for (int j = 0; j < finalList[i]['imageList'].length; j++) {
                        images.add(finalList[i]['imageList'][j] as String);
                      }
                      String category = "";
                      if (finalList[i]['isFnb']) {
                        category = "fnb";
                      } else {
                        category = "recreation";
                      }
                      return

                        Swipable(child: SwipingTile(
                          address: finalList[i]['address'],
                          description: finalList[i]['description'],
                          imageURL_360: finalList[i]['360image'],
                          imageURLs: images,
                          name: finalList[i]['name'],
                        ),
                            onSwipeDown: (finalPosition) async {
                              if (isLoggedIn()) {

                                stopwatch.stop();
                                double time = stopwatch.elapsedMilliseconds / 1000;

                                updateAvgTimeSeen(category, finalList[i]['name'], time);
                                stopwatch.reset();
                                stopwatch.start();

                                List<dynamic> bookmarks = await getBookmarks();
                                String uid = await getCurrentUID();
                                final List<bool> isSelected = globalKey.currentState!.isSelected;
                                for (int j = 0; j < isSelected.length; j++) {
                                  if (isSelected[j]) {
                                    String bookmarkName = bookmarks[j] as String;
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .collection(bookmarkName)
                                        .doc(finalList[i]['name'])
                                        .set({
                                      'name': finalList[i]['name'],
                                      'description': finalList[i]['description'],
                                      'price': finalList[i]['price'],
                                      'address': finalList[i]['address'],
                                      'tags': finalList[i]['tags'],
                                      'imageList': finalList[i]['imageList'],
                                      '360image': finalList[i]['360image'],
                                    });
                                  }
                                }
                                globalKey.currentState!.resetSelection();
                              }

                              setState(() {index += 1; first=false;});

                            },
                            onSwipeUp: (finalPosition) {

                              if (isLoggedIn()) {
                                stopwatch.stop();
                                double time = stopwatch.elapsedMilliseconds / 1000;
                                updateAvgTimeSeen(category, finalList[i]['name'], time);
                                stopwatch.reset();
                                stopwatch.start();
                              }

                              setState(() {index += 1; first=false;});

                            },
                            onSwipeLeft: (finalPosition) {

                              if (isLoggedIn()) {
                                stopwatch.stop();
                                double time = stopwatch.elapsedMilliseconds / 1000;
                                updateAvgTimeSeen(category, finalList[i]['name'], time);
                                stopwatch.reset();
                                stopwatch.start();
                              }
                              setState(() {index += 1;first=false;});

                            },

                            onSwipeRight: (finalPosition) {

                              if (isLoggedIn()) {
                                stopwatch.stop();
                                double time = stopwatch.elapsedMilliseconds / 1000;
                                updateAvgTimeSeen(category, finalList[i]['name'], time);
                                stopwatch.reset();
                                stopwatch.start();
                              }
                              setState(() {index += 1;first=false;});

                            });
                    },
                    itemCount: finalList.length,
                  ),
                  BrowseBar(),])
                );

              });
        }
    );


  }
}

Future<List<double>> getUserTimes(String category) async {
  String uid = await getCurrentUID();
  String field = category + "AvgTime";
  List<dynamic> avgList = await FirebaseFirestore
      .instance.collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[field];});
  List<double> result = [];

  for (int i = 0; i < avgList.length; i++) {
    result.add(avgList[i] as double);
  }

  return result;
}

Future<List<QueryDocumentSnapshot>> getLocations(String category, List<String> locationNames, int price, List<String> tags) async {
  List<QueryDocumentSnapshot> result = [];

  // sponsors start
  bool fnb;
  if (category == "fnb") {
    fnb = true;
  } else {
    fnb = false;
  }
  QuerySnapshot sponsoredQS = await FirebaseFirestore.instance
      .collection('sponsored')
      .where('isFnb', isEqualTo: fnb)
      .get();
  List<QueryDocumentSnapshot> sponsoredList = sponsoredQS.docs
      .where((d) => d['price'] <= price)
      .where((doc) => checkTags(doc['tags'], tags))
      .toList();
  // sponsors end

  // getting recommended locations
  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection(category)
      .get();
  var iter = qs.docs.where((d) => checkDuplicates(d['name'], sponsoredList));


  for (int i = 0; i < locationNames.length; i++) {
    // await FirebaseFirestore.instance
    //     .collection(category)
    //     .doc(locationNames[i])
    //     .get()
    //     .then((d) {
    //       if (checkDuplicates(d['name'], sponsoredList)) {
    //         result.add(d);
    //       }
    //     });
    var temp = iter.where((d) => d['name'] == locationNames[i]).toList();
    if (temp.length > 0) {
      result.add(temp[0]);
    }

  }

  sponsoredList..shuffle(); // QDS, result: DS

  for (QueryDocumentSnapshot qds in result) {
    sponsoredList.add(qds);
  }

  return sponsoredList;
}

Future<void> updateAvgTimeSeen(String category, String locationName, double time) async {
  String uid = await getCurrentUID();

  String categoryAvgTime = category + "AvgTime";
  String categorySeen = category + "Seen";

  List<dynamic> avgList = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[categoryAvgTime];});
  
  int locationID = await FirebaseFirestore.instance
    .collection(category)
    .doc(locationName)
    .get()
    .then((doc) {return doc['id'];});
  
  List<dynamic> seenList = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((doc) {return doc[categorySeen];});

  seenList[locationID] = seenList[locationID] + 1;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({categorySeen: seenList});
  
  avgList[locationID] = (avgList[locationID] + time) / seenList[locationID];

  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({categoryAvgTime: avgList});
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
    BuildContext context,
    String category,
    int price,
    List<String> tags) async {

  // sponsors start
  bool fnb;
  if (category == "fnb") {
    fnb = true;
  } else {
    fnb = false;
  }
  QuerySnapshot sponsoredQS = await FirebaseFirestore.instance
    .collection('sponsored')
    .where('isFnb', isEqualTo: fnb)
    .get();
  List<QueryDocumentSnapshot> sponsoredList = sponsoredQS.docs
      .where((d) => d['price'] <= price)
      .where((doc) => checkTags(doc['tags'], tags))
      .toList();
  // sponsors end

  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection(category)
      .where('price', isLessThanOrEqualTo: price)
      .get();

  // Stream<QueryDocumentSnapshot> docsStream = Stream.fromIterable(qs
  //     .docs
  //     .where((d) => checkTags(d['tags'], tags)));

  Iterable<QueryDocumentSnapshot> docsStream =
      qs.docs
          .where((d) => checkTags(d['tags'], tags))
          .where((doc) => checkDuplicates(doc['name'], sponsoredList));

  // Init PermissionHandler
  // bool status;
  // PermissionHandler permissionHandler = PermissionHandler();
  // // Request location permissions
  // status = await permissionHandler.requestLocationPermission();
  //
  // if (!status) {
  //   return docsStream.toList();
  // }
  //
  // FusedLocationProviderClient locationService = FusedLocationProviderClient();
  // LocationRequest locationRequest = new LocationRequest();
  // locationRequest.numUpdates = 1;
  //
  // await locationService.requestLocationUpdates(locationRequest);
  // Location curr = await locationService.getLastLocation();
  // double lat = curr.latitude;
  // double long = curr.longitude;
  //
  //
  // List<QueryDocumentSnapshot> docsList = [];
  // for (QueryDocumentSnapshot d in docsStream) {
  //   if(await checkDist(d, dist, status, lat, long)) {
  //     docsList.add(d);
  //   }
  // }
  //
  // return docsList;

  List<QueryDocumentSnapshot> categoryList = docsStream.toList();
  categoryList..shuffle();
  // sponsors first
  sponsoredList..shuffle();
  sponsoredList.addAll(categoryList);

  return sponsoredList;
}

bool checkTags(List<dynamic> doc, List<String> tag) {
  // if (tag.contains('Indoor') && tag.contains('Outdoor')) {
  //   tag.remove('Indoor');
  //   tag.remove('Outdoor');
  // }
  //
  // if (tag.contains('Physical') && tag.contains('Leisure')) {
  //   tag.remove('Physical');
  //   tag.remove('Leisure');
  // }
  //
  // if (tag.any((item) => doc.contains(item)) && doc.length > 0 ||
  //     tag.length == 0) {
  //   return true;
  // } else {
  //   return false;
  // }

  if (!tag.any((item) => doc.contains(item)) && doc.length > 0 ||
      tag.length == 0) {
    return true;
  } else {
    return false;
  }
}

bool checkDuplicates(String name, List<QueryDocumentSnapshot> sponsoredDocs) {

  for (int i = 0; i < sponsoredDocs.length; i++) {
    if (sponsoredDocs[i]['name'] == name) {
      return false;
    }
  }
  // returns true if there are no duplicates, can add
  return true;
}

Future<bool> checkDist(QueryDocumentSnapshot doc, double requiredDist,
    bool status, double lat, double long) async {
  List<gc.Location> locations = await gc.locationFromAddress(doc['address']);
  double distanceInKM = Geolocator.distanceBetween(
          lat, long, locations[0].latitude, locations[0].longitude) *
      0.001;
  return distanceInKM < requiredDist;
}

// Future<String> getImageURL(String locationName) async {
//   String fileName = locationName + ".jpg";
//   final ref = FirebaseStorage.instance.ref().child()
// }

class BrowseBar extends StatefulWidget {
  const BrowseBar({Key? key}) : super(key: key);

  @override
  _BrowseBarState createState() => _BrowseBarState();
}

class _BrowseBarState extends State<BrowseBar> {

  bool confused = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [Container(
            child: Column(children: [
              Container(height: MediaQuery.of(context).size.height / 1.08),
              SingleChildScrollView(
                child: BookmarksBar(key: globalKey),
                scrollDirection: Axis.horizontal,
              ),
            ])),
          Positioned(
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.lightBlueAccent),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ),
          Positioned(
              child: IconButton(
                  icon: Icon(Icons.help_outline, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      confused = true;
                    });
                  }),
              right: 20,
              top: 20
          ),
          Visibility(
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
                                              "This page displays recommended locations (suited to user's preferences) in an interactive way."),
                                        ]),
                                  ),
                                  Container(height: 50),
                                  Text.rich(
                                    TextSpan(
                                      text: "Double Tap",
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
                                          TextSpan(text: "This "),
                                          TextSpan(
                                              text: "enables ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "and "),
                                          TextSpan(
                                              text: "disables ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the ability to interact with the "),
                                          TextSpan(
                                              text: "360-view image",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: "Take note: the "),
                                          TextSpan(
                                              text: "Lock Icon ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "(RED/GREEN) is a visual indicator of the current state of 360-view image (whether it is enabled or disabled). When the lock is red, interactivity is "),
                                          TextSpan(
                                              text: "disabled",
                                              style: GoogleFonts.delius(
                                                  color: Colors.red)),
                                          TextSpan(
                                              text:
                                              ", and when it is green, interactivity is "),
                                          TextSpan(
                                              text: "enabled",
                                              style: GoogleFonts.delius(
                                                  color: Colors.green)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Press and hold",
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
                                          TextSpan(text: "This "),
                                          TextSpan(
                                              text: "activates ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "and "),
                                          TextSpan(
                                              text: "deactivates ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the pop-up screen that provides additional information of this particular location."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "This screen provides "),
                                          TextSpan(
                                              text:
                                              "additional information",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              ", like: name of location, a scrollable list of images, the location's address and additional written details."),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Swipe left/right",
                                      style: GoogleFonts.delius(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 12,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "when 360-view is disabled",
                                              style: GoogleFonts.delius(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "Discards this location recommendation as it is "),
                                          TextSpan(
                                              text:
                                              "not suited to your preferences",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(text: "."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "We will then automatically provide a new location recommendation for you!"),
                                        ]),
                                  ),
                                  Container(height: 20),
                                  Text.rich(
                                    TextSpan(
                                      text: "Select Bookmarks + Swipe down",
                                      style: GoogleFonts.delius(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 11,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "when 360-view is disabled",
                                              style: GoogleFonts.delius(
                                                  fontWeight:
                                                  FontWeight.bold)),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: "Select ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "the bookmark(s) you wish to save this location to (at the bottom of the screen)."),
                                          TextSpan(
                                              text:
                                              "Then when you swipe down, the current location is "),
                                          TextSpan(
                                              text: "saved ",
                                              style: GoogleFonts.delius(
                                                  color:
                                                  Colors.pinkAccent)),
                                          TextSpan(
                                              text:
                                              "to the bookmark(s) selected."),
                                        ]),
                                  ),
                                  Container(height: 5),
                                  Text.rich(
                                    TextSpan(
                                        text: "",
                                        style: GoogleFonts.delius(
                                          fontSize: 15,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                              "We will then automatically provide a new location recommendation for you!"),
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
                          style: GoogleFonts.itim(
                            color: Colors.black,
                            fontSize: 20,
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
            visible: confused,
          )

        ]);
  }
}