// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'ListPage.dart';
//
// class ListPageBuilder extends StatelessWidget {
//   final String category;
//   final int price;
//   final List<String> tags;
//   final double dist;
//
//   ListPageBuilder(this.category, this.price, this.tags, this.dist);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<QueryDocumentSnapshot>>(
//       future: getLocationStreamSnapshots(context, this.category, this.price, this.tags, this.dist),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(child: CircularProgressIndicator());
//         }
//         // return ListPage(snapshot.data!);
//         return Container();
//       }
//     );
//   }
// }
//
// Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots(
//     BuildContext context,
//     String category,
//     int price,
//     List<String> tags,
//     double dist) async {
//   QuerySnapshot qs = await FirebaseFirestore.instance
//       .collection(category)
//       .where('price', isLessThanOrEqualTo: price)
//       .get();
//   //
//   // Stream<QueryDocumentSnapshot> docsStream = Stream.fromIterable(qs
//   //     .docs
//   //     .where((d) => checkTags(d['tags'], tags)));
//
//   Iterable<QueryDocumentSnapshot> docsStream =
//   qs.docs.where((d) => checkTags(d['tags'], tags));
//
//   // Init PermissionHandler
//   // bool status;
//   // PermissionHandler permissionHandler = PermissionHandler();
//   // // Request location permissions
//   // status = await permissionHandler.requestLocationPermission();
//   //
//   // if (!status) {
//   //   return docsStream.toList();
//   // }
//   //
//   // FusedLocationProviderClient locationService = FusedLocationProviderClient();
//   // LocationRequest locationRequest = new LocationRequest();
//   // locationRequest.numUpdates = 1;
//   //
//   // await locationService.requestLocationUpdates(locationRequest);
//   // Location curr = await locationService.getLastLocation();
//   // double lat = curr.latitude;
//   // double long = curr.longitude;
//   //
//   //
//   // List<QueryDocumentSnapshot> docsList = [];
//   // for (QueryDocumentSnapshot d in docsStream) {
//   //   if(await checkDist(d, dist, status, lat, long)) {
//   //     docsList.add(d);
//   //   }
//   // }
//   //
//   // return docsList;
//
//   return docsStream.toList();
// }
//
// bool checkTags(List<dynamic> doc, List<String> tag) {
//
//   if (!tag.any((item) => doc.contains(item)) && doc.length > 0 ||
//       tag.length == 0) {
//
//     return true;
//   } else {
//     return false;
//   }
// }