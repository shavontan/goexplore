import 'package:ml_linalg/matrix.dart';


// How to use:
// calling new Recommender(num_rec: ???).getRecommendations()      =>  returns a List<String> of TOP 'num_rec' recommendations of location names

class Recommender {
  int num_rec = 0;
  List<String> user = ['USER'];
  List<String> fnbLocations = ['51 Soho',  // -- 0
    'Atlas Bar', 'Ayam Penyet Ria', 'Beaulieu House', 'Beer Factory', 'Birds of a Feather', // -- 5
    'Bistro Gardenasia', 'Blu Jaz Cafe', 'Blu Kouzina', 'Bollywood Veggies', 'Burnt Ends',  // -- 10
    'Cafe Colbar', 'Candlenut', 'Central Perk Cafe', 'Common Man Coffee Roasters', 'Crave',     // -- 15
    'Daebak Korean Restaurant', 'Druggists', 'Fish & Co.', 'Fu Lin Bar & Kitchen', 'Fu Lin Tofu Garden',  // 20
    'GO Noodle House', 'Geláre', 'Gibson Bar', 'Go-Ang Pratunam Chicken Rice', 'Gong Cha (Eunos)',    // -- 25
    'Intermission Bar at The Projector', 'KFC', 'Knots Cafe and Living', 'Komala Vilas', 'Lime House Caribbean',   // -- 30
    'Little Island Brewing Co', 'Maxwell Food Centre', "McDonald's (Queensway)", 'PS.Cafe', 'Plain Vanilla Bakery',    // 35
    'Platform 1094', 'Poke Theory (Cross Street Exchange)', 'Saizeriya (Toa Payoh)', 'Smith Marine Floating Restaurant', 'Starbucks (Changi Airport)',    // 40
    'Stellar at 1-Altitude', 'Super Loco Customs House', 'Tendon Ginza Itsuki', 'The Alkaff Mansion', 'The Banana Leaf Apolo',   // 45
    'The Black Swan', 'The Coconut Club', 'The National Kitchen', 'The Roti Prata House', 'Thus Coffee',   // 50
    'True Blue', 'Whisk & Paddle', 'Yixing Xuan Teahouse', 'Zam Zam Restaurant', "d’Good Café",     // 55
  ];

  List<String> recLocations = ['1-Altitude',  // -- 0
    'Adventure Cove Water Park', 'Amoy Hotel', 'ArtScience Museum', 'Asian Civilisations Museum', 'Champion Mini Golf',  // 5
    'Changi Jurassic Mile', 'Chinese Garden', 'Civil Defence Heritage Gallery', 'Clementi Forest', 'Clock Playground',  // 10
    'Dairy Farm Nature Park', 'Diggersite', 'Dragon Playground', 'Elgin Bridge', 'Flight Experience',   // 15
    'Forest Adventure', 'G-Max Reverse Bungy', 'Haji Lane', 'Hay Dairies Pte Ltd', 'Helix Bridge',  // 20
    'Holey Moley', 'Japanese Cemetery Park', 'Japanese Garden', 'Jurong Frog Farm', 'K Bowling Club',   // 25
    'Kranji Marshes', 'Kuan Im Tng Temple', 'Little Guilin', 'MacRitchie Reservoir', 'Madame Tussauds',   // 30
    'Marine Cove Playground', 'Merlion', 'National Gallery Singapore', 'Peranakan Museum', 'Pororo Park',  // 35
    'Raffles Marina Lighthouse', 'S.E.A. Aquarium', 'Sembawang Hot Spring Park', 'Singapore Zoo', 'Skyline Luge',  // 40
    'Snow City', 'Sungei Buloh Wetland Reserve', 'Supertree Grove', 'The Intan', 'The Karting Arena',   // 45
    'Thow Kwang Pottery Jungle', 'Tiong Bahru Air Raid Shelter', 'Trick Eye Museum', 'Universal Studios Singapore', 'Wild Wild Wet',   // 50
    'Xtreme SkatePark', 'Yunomori Onsen & Spa', 'iFly Singapore',  // 53
  ];

  List<String> fnbTags = ["Beverages", // 0
    "Ambience", "Chinese", "Korean", "Japanese",    // 4
    "Malay", "Indian", "Halal", "Western",    // 8
    "Fast Food", "Vegan", "Vegetarian", "Dessert",     // 12
    "Seafood",
  ];

  List<String> recTags = ["Indoor", // 0
    "Outdoor", "Physical", "Leisure",   // 3
    "Nature", "Cultural", "Educational",   // 6
    "Service", "Nightlife", "Kid-Friendly",   // 9
  ];

  List<List<double>> fnbTagsInBits = [ [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], // 0: 51 Soho
    [1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0], // 5: Birds of a Feather
    [0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0], [0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], // 10: Burnt Ends
    [0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0], [1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0], // 15: Crave
    [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 20: Fu Lin Tofu Garden
    [0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0], // 25: Gong Cha (Eunos)
    [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1], // 30:  Lime House Caribbean
    [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0], [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0], // 35: Plain Vanilla Bakery
    [1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 40: Starbucks (Changi Airport)
    [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1], // 45: The Banana Leaf Apolo
    [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], // 50: Thus Coffee
    [0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0], [1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0], // 55: d'Good Cafe
  ];

  List<List<double>> recTagsInBits = [[0, 1, 0, 0, 0, 0, 0, 0, 1, 0], // 0: 1-Altitude
    [0, 1, 1, 0, 0, 0, 0, 0, 0, 1], [1, 0, 0, 1, 0, 1, 0, 0, 0, 0], [1, 0, 0, 1, 0, 0, 1, 0, 0, 1], [1, 0, 0, 0, 0, 0, 1, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 1], // 5: Champion Mini Golf
    [0, 1, 0, 0, 0, 0, 1, 0, 0, 1], [0, 1, 0, 1, 1, 1, 0, 0, 0, 1], [1, 0, 0, 1, 0, 0, 1, 0, 0, 1], [0, 1, 1, 0, 1, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 0, 0, 0, 0, 1], // 10: Clock Playground
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0], [0, 1, 0, 0, 0, 0, 1, 0, 0, 1], [0, 1, 0, 1, 0, 0, 0, 0, 0, 1], [0, 1, 0, 0, 0, 0, 1, 0, 0, 0], [1, 0, 0, 0, 0, 0, 1, 0, 0, 1], // 15: Flight Experience
    [0, 1, 1, 0, 1, 0, 0, 0, 0, 0], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 0, 0, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 1, 0, 0, 1], [0, 1, 0, 1, 0, 0, 0, 0, 0, 0], // 20: Helix Bridge
    [1, 0, 0, 1, 0, 0, 0, 0, 0, 0], [0, 1, 0, 1, 1, 1, 0, 0, 0, 0], [0, 1, 0, 1, 0, 1, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0, 1, 0, 0, 1], [1, 0, 1, 0, 0, 0, 0, 0, 0, 0], // 25: K Bowling Club
    [0, 1, 0, 1, 1, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 1, 0, 0, 0, 0], [0, 1, 0, 0, 1, 0, 0, 0, 0, 0], [0, 1, 0, 1, 1, 0, 0, 0, 0, 1], [1, 0, 0, 1, 0, 0, 0, 0, 0, 1], // 30: Madame Tussauds
    [0, 1, 1, 0, 0, 0, 0, 0, 0, 1], [0, 1, 0, 1, 0, 0, 0, 0, 0, 1], [1, 0, 0, 1, 0, 1, 1, 0, 0, 1], [1, 0, 0, 0, 0, 1, 1, 0, 0, 1], [1, 0, 0, 1, 0, 0, 0, 0, 0, 1], // 35: Pororo Park
    [0, 1, 0, 1, 0, 0, 0, 0, 0, 1], [1, 0, 0, 1, 0, 0, 1, 0, 0, 1], [0, 1, 0, 1, 0, 0, 1, 0, 0, 1], [0, 1, 0, 1, 1, 0, 1, 0, 0, 1], [0, 1, 1, 0, 0, 0, 0, 0, 0, 0], // 40: Skyline Luge
    [1, 0, 1, 0, 0, 0, 0, 0, 0, 1], [0, 1, 0, 1, 1, 0, 0, 0, 0, 1], [0, 1, 0, 1, 0, 0, 0, 0, 1, 1], [1, 0, 0, 0, 0, 1, 0, 0, 0, 0], [0, 1, 0, 0, 0, 0, 0, 0, 0, 1], // 45: The Karting Arena
    [1, 0, 0, 1, 0, 0, 0, 0, 0, 0], [1, 0, 0, 0, 0, 0, 1, 0, 0, 0], [1, 0, 0, 1, 0, 0, 0, 0, 0, 1], [0, 1, 1, 1, 0, 0, 0, 0, 0, 1], [0, 1, 1, 0, 0, 0, 0, 0, 0, 1], // 50: Wild Wild Wet
    [0, 1, 1, 0, 0, 0, 0, 0, 0, 0], [1, 0, 0, 1, 0, 0, 0, 0, 0, 0], [1, 0, 1, 0, 0, 0, 0, 0, 0, 1], // 53: iFly
  ];

  List<double> userTimes = [0];
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

    var user_tags = users_locations * location_tags;
    user_tags = user_tags /
        user_tags.reduceColumns((combine, vector) => combine + vector);

    var user_times = user_tags * location_tags.transpose();

    List<List<double>> xs = List<List<double>>.filled(num_locations, [0,-1], growable: true);

    for (int i = num_locations - 1; i >= 0; i--) {
      xs[i] = [user_times[0][i], i.toDouble()];
    }

    List<int> filterTags = [];

    if (isFnB) {
      filterTags = convert_FnB_tags_ToBits(locationTags: this.filters);
    } else {
      filterTags = convert_rec_tags_ToBits(locationTags: this.filters);

      if (filterTags[0] == 1 && filterTags[1] == 1) {
        filterTags[0] = 0;
        filterTags[1] = 0;
      }
      if (filterTags[2] == 1 && filterTags[3] == 1) {
        filterTags[2] = 0;
        filterTags[3] = 0;
      }
    }

    for (int i = xs.length - 1; i >= 0; i--) {
      int indexOfLocation = xs[i][1].toInt();

      List<double> locationBits;

      if (isFnB) {
        locationBits = this.fnbTagsInBits[indexOfLocation];
        bool match = false;
        for (int j = 0; j < filterTags.length; j++) {
          if (filterTags[j] == 1 && locationBits[j] == 1) {
            match = true;
          }
        }
        if (!match) {
          xs.removeAt(i);
        }
      } else {
        locationBits = this.recTagsInBits[indexOfLocation];
        for (int j = 0; j < filterTags.length; j++) {
          if (filterTags[j] == 1 && locationBits[j] == 0) {
            xs.removeAt(i);
            break;
          }
        }
      }

    }

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

    return result;
  }


  // example: ['Western', 'Asian'] => [0,0,1,1]
  List<int> convert_FnB_tags_ToBits({required List<String> locationTags}) {      // converts a location's tags into bits form
    List<String> FnB_tags = ["Beverages", // --- 0
      "Ambience",
      "Chinese",
      "Korean",
      "Japanese",    // --- 4
      "Malay",
      "Indian",
      "Halal",
      "Western",    // --- 8
      "Fast Food",
      "Vegan",
      "Vegetarian",
      "Dessert",     // --- 12
      "Seafood",
    ]; // extend this to be all the tags in FnB
    List<int> result = List<int>.filled(FnB_tags.length, 0);
    int count = 0;

    int len = locationTags.length;
    for (int i = 0; i < len; i++) {
      for (int j = 0; j < FnB_tags.length; j++) {
        if (locationTags[i] == FnB_tags[j]) {
          result[j] = 1;
          count++;
          break;
        }
      }
    }

    List<int> error = [-1];
    return count == locationTags.length ? result : error;
  }

  // example: ['Western', 'Asian'] => [0,0,1,1]
  List<int> convert_rec_tags_ToBits({required List<String> locationTags}) {      // converts a location's tags into bits form
    List<String> rec_tags = ["Indoor",
      "Outdoor",
      "Physical",
      "Leisure",
      "Nature",
      "Cultural",
      "Educational",
      "Service",
      "Nightlife",
      "Kid-Friendly",
    ]; // extend this to be all the tags in RECREATION
    List<int> result = List<int>.filled(rec_tags.length, 0);
    int count = 0;

    int len = locationTags.length;
    for (int i = 0; i < len; i++) {
      for (int j = 0; j <rec_tags.length; j++) {
        if (locationTags[i] == rec_tags[j]) {
          result[j] = 1;
          count++;
          break;
        }
      }
    }
    List<int> error = [-1];
    return count == locationTags.length ? result : error;
  }
}