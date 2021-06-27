import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ml_linalg/matrix.dart';

// How to use:
// calling new Recommender(num_rec: ???, userTimes: ???, filters: ???, isFnB: ???).getRecommendations()      =>  returns a List<String> of TOP 'num_rec' recommendations of location names

class Recommender {
  int num_rec = 0;
  List<String> user = ['USER'];
  List<String> fnbLocations = ['Kong Cafe', 'Green Dot', 'Steak House',
    'Macdonald', 'Koi Cafe', 'The Boneless Kitchen',
    'Takagi Ramen', 'Super Amazing Kitchen', 'Hotel Food'];

  List<String> recLocations = ['WWW', 'Chinese Garden', 'ArtScience Museum', 'Chinese Garden1', 'PeachGarden', 'Orchid Garden']; // added

  List<String> fnbTags = ['Ambience', 'Affordable', 'Western', 'Asian'];
  List<String> recTags = ['Indoor', 'Outdoor', 'Leisure', 'Physical']; // added

  List<List<double>> fnbTagsInBits = [ [1, 0, 0, 1],
    [0, 0, 0, 1],   // Green Dot -- seen
    [1, 0, 1, 0],   // Steak House -- seen
    [0, 1, 1, 0],   // Macs
    [1, 0, 0, 0],    // Koi
    [1, 0, 0, 1],  //Boneless -- seen
    [1, 0, 0, 1], // seen
    [0, 1, 1, 0],
    [1, 0, 1, 1],
  ];

  List<List<double>> recTagsInBits = [[0,1,0,1],
    [0,1,1,0],
    [1,0,0,0],
    [0,1,1,0],
    [0,1,1,0],
    [1,0,1,0]];

  // remove this
  // List<double> userTimes = [3, 10, 20,
  //                           5, 0, 7,
  //                           0, 0, 0];

  List<double> userTimes = [0]; // added
  List<String> filters = [];


  int num_users = 1;
  int num_locations = 0;
  int num_tags = 0;


  bool isFnB = true;


  Recommender({required int num_rec, required List<double> userTimes, required List<String> filters, required bool isFnB}) {  // Take in List<double> userTimes from database and List<String> filters
    this.num_rec = num_rec;

    if (isFnB) {
      this.num_locations = this.fnbLocations.length;
      this.num_tags = this.fnbTags.length;
    } else {
      this.num_locations = this.recLocations.length;
      this.num_tags = this.recTags.length;
    }

    this.userTimes = userTimes;
    this.filters = filters;
    this.isFnB = isFnB;
  }

  List<String> getRecommendations() {
    var users_locations = Matrix.fromList([this.userTimes]);

    var location_tags;

    if (isFnB) {
      location_tags = Matrix.fromList(this.fnbTagsInBits);
    } else {
      location_tags = Matrix.fromList(this.recTagsInBits);
    }

    // print(users_locations);
    // print(location_tags);

    var user_tags = users_locations * location_tags;
    user_tags = user_tags /
        user_tags.reduceColumns((combine, vector) => combine + vector);
    // print(user_tags);

    var user_times = user_tags * location_tags.transpose();
    // print(user_times);

    // print("____________________________________________________________");

    List<double> tempList = List<double>.filled(num_locations, 0);
    for (int i = 0; i < tempList.length; i++) {
      // print(userTimes[i]);
      if (userTimes[i] == 0.0) {
        tempList[i] = 1;
      }
    }
    // print(tempList);

    var temp = Matrix.fromList([tempList]);
    // print("temp matrix: " + temp.toString());

    // print(user_times);
    var new_user_times = user_times.multiply(temp);
    // print(new_user_times);


    List<List<double>> xs = List<List<double>>.filled(num_locations, [0,-1], growable: true);

    for (int i = num_locations - 1; i >= 0; i--) {
      if (new_user_times[0][i] != 0.0) {
        xs[i] = [new_user_times[0][i], i.toDouble()];
      } else {
        xs.removeAt(i);
      }
    }

    List<int> filterTags = [];

    if (isFnB) {
      filterTags = convert_FnB_tags_ToBits(locationTags: this.filters);
    } else {
      filterTags = convert_rec_tags_ToBits(locationTags: this.filters);
    }

    for (int i = xs.length - 1; i >= 0; i--) {
      int indexOfLocation = xs[i][1].toInt();

      List<double> locationBits;

      if (isFnB) {
        locationBits = this.fnbTagsInBits[indexOfLocation];
      } else {
        locationBits = this.recTagsInBits[indexOfLocation];
      }

      for (int j = 0; j < filterTags.length; j++) {
        if (filterTags[j] == 1 && locationBits[j] == 1.0) {
          xs.removeAt(i);
          break;
        }
      }
    }
    // print(xs);

    var result = List<String>.filled(num_rec, "");

    for (int i = 0; i < num_rec; i++) {
      if (xs.isEmpty) {
        break;
      }
      double maxValue = xs[0][0];
      double maxIndex = xs[0][1];
      int elementToRemove = 0;

      for (int j = 1; j < xs.length; j++) {

        if (xs[j][0] > maxValue) {
          maxValue = xs[j][0];
          maxIndex = xs[j][1];
          elementToRemove = j;
        }
      }

      if (isFnB) {
        result[i] = fnbLocations[maxIndex.toInt()];
        xs.removeAt(elementToRemove);
      } else {
        result[i] = recLocations[maxIndex.toInt()];
        xs.removeAt(elementToRemove);
      }
    }

    // print(result);
    return result;
  }


  // example: ['Western', 'Asian'] => [0,0,1,1]
  List<int> convert_FnB_tags_ToBits({required List<String> locationTags}) {      // converts a location's tags into bits form
    List<String> FnB_tags = ['Ambience', 'Affordable', 'Western', 'Asian']; // extend this to be all the tags in FnB
    List<int> result = List<int>.filled(FnB_tags.length, 0);

    int len = locationTags.length;
    for (int i = 0; i < len; i++) {
      for (int j = 0; j < FnB_tags.length; j++) {
        if (locationTags[i] == FnB_tags[j]) {
          result[j] = 1;
          break;
        }
      }
    }
    return result;
  }

  // example: ['Western', 'Asian'] => [0,0,1,1]
  List<int> convert_rec_tags_ToBits({required List<String> locationTags}) {      // converts a location's tags into bits form
    List<String> rec_tags = ['Indoor', 'Outdoor', 'Leisure', 'Physical']; // extend this to be all the tags in RECREATION
    List<int> result = List<int>.filled(rec_tags.length, 0);

    int len = locationTags.length;
    for (int i = 0; i < len; i++) {
      for (int j = 0; j <rec_tags.length; j++) {
        if (locationTags[i] == rec_tags[j]) {
          result[j] = 1;
          break;
        }
      }
    }
    return result;
  }

}