import 'package:ml_linalg/matrix.dart';


// How to use:
// calling new Recommender(num_rec: ???).getRecommendations()      =>  returns a List<String> of TOP 'num_rec' recommendations of location names

class Recommender {
  int num_rec = 0;
  List<String> user = ['USER'];
  List<String> locations = ['Kong Cafe', 'Green Dot', 'Steak House',
    'Macdonald', 'Koi Cafe', 'The Boneless Kitchen',
    'Takagi Ramen', 'Super Amazing Kitchen', 'Hotel Food'];

  List<String> tags = ['Ambience', 'Affordable', 'Western', 'Asian'];

  List<List<double>> tags_in_bits = [ [1, 0, 0, 1],
    [0, 0, 0, 1],   // Green Dot
    [1, 0, 1, 0],   // Steak House
    [0, 1, 1, 0],   // Macs
    [1, 0, 0, 0],    // Koi
    [1, 0, 0, 1],  //Boneless
    [1, 0, 0, 1],
    [0, 1, 1, 0],
    [1, 0, 1, 1],
  ];

  List<double> userTimes = [3, 10, 20,
    5, 0, 7,
    0, 0, 0];

  int num_users = 1;
  int num_locations = 0;
  int num_tags = 0;



  Recommender({required int num_rec}) {
    this.num_rec = num_rec;
    this.num_locations = this.locations.length;
    this.num_tags = this.tags.length;

  }

  List<String> getRecommendations() {
    var users_locations = Matrix.fromList([this.userTimes]);
    var location_tags = Matrix.fromList(this.tags_in_bits);

    // MatMul
    var user_tags = users_locations * location_tags;
    // divide by Reduce-sum:
    user_tags = user_tags / user_tags.reduceColumns((combine, vector) => combine + vector);

    // MatMul
    var user_times = user_tags * location_tags.transpose();



    List<double> tempList = List<double>.filled(num_locations, 0);
    for (int i = 0; i < tempList.length; i++) {
      if (userTimes[i] == 0) {
        tempList[i] = 1;
      }
    }

    // 2d matrix of 0s (if seen) and 1s (if unseen) --- converted from tempList
    var temp = Matrix.fromList([tempList]);

    // element-wise multiplication (replace tf.where stuff)
    // removes locations that have already been seen by user
    var new_user_times = user_times.multiply(temp);

    // convert all unseen location (%) and their indexes (in locations array) into a normal list, where each element = [%, index]
    List<List<double>> xs = List<List<double>>.filled(num_locations, [0,0]);

    for (int i = 0; i < num_locations; i++) {
      if (new_user_times[0][i] != 0.0) {
        xs[i] = [new_user_times[0][i], i.toDouble()];
      }
    }

    // loops through 'unseen locations' list (num_rec times) -- getting the largest % each time and removing it from the list
    var result = List<String>.filled(num_rec, "");
    for (int i = 0; i < num_rec; i++) {
      double maxValue = xs[0][0];
      double maxIndex = xs[0][1];
      for (int j = 1; j < xs.length; j++) {
        if (xs[j][0] > maxValue) {
          maxValue = xs[j][0];
          maxIndex = xs[j][1];
        }
      }
      result[i] = locations[maxIndex.toInt()];
      xs[maxIndex.toInt()] = [0.0, maxIndex];
    }

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
    List<String> rec_tags = ['Ambience', 'Affordable', 'Western', 'Asian']; // extend this to be all the tags in RECREATION
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