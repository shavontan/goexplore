import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ListPage.dart';

class ListPageBuilder extends StatelessWidget {
  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  ListPageBuilder(this.category, this.price, this.tags, this.dist);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getLocationStreamSnapshots(context, this.category, this.price, this.tags, this.dist),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListPage(snapshot.data!);
      }
    );
  }
}

Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots(
    BuildContext context, String category, int price, List<String> tags, double dist) async {

  QuerySnapshot qs = await FirebaseFirestore.instance
      .collection(category)
      .where('price', isLessThanOrEqualTo: price)
      .get();

  Stream<QueryDocumentSnapshot> docsStream = Stream.fromIterable(qs
      .docs
      .where((d) => checkTags(d['tags'], tags)));

  // Iterable<QueryDocumentSnapshot> docsStream = qs
  //     .docs
  //     .where((d) => checkTags(d['tags'], tags));

  return docsStream.toList();

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

// Future<bool> checkDist(QueryDocumentSnapshot doc, double requiredDist, bool status, double lat, double long) async {
//
//   List<gc.Location> locations = await gc.locationFromAddress(doc['address']);
//   double distanceInKM = Geolocator.distanceBetween(lat, long, locations[0].latitude, locations[0].longitude) * 0.001;
//   return distanceInKM < requiredDist;
//
// }
