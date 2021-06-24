import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goexplore/flutterfire.dart';

class TrackPoints extends ChangeNotifier {
  int points = -1;

  TrackPoints() {
    _loadPoints();
  }

  Future<int> getPoints() async {
    String uid = await getCurrentUID();
    print("!!!!!!!!!!!");
    print(uid);
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {return value['points'];});
  }

  Future<void> _loadPoints() async {
    int p = await getPoints();
    this.points = p;
    notifyListeners();
  }

  void changePoints(int changeTo) {
    this.points = this.points + changeTo;
    notifyListeners(); // affects watch
  }
}


// How to use:
// In build methods (using user points):
// final userPoints = context.watch<TrackPoints>();
// IN BUILD:
//    onPressed() {
//       userPoints.changePoints(300);
//     }



// MISC:

// to change points:
// Provider.of<TrackPoints>(context, listen: false).changePoints(<INT>);
// Parent widget that returns a provider that creates a TrackPoints object

// Don't care about updates to a value: context.read<T>() – cannot be in build method