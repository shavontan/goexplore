import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CustomWidgets/MyListTile.dart';
// call: myListTile(imgURLs: ???, name: ???, description: ???, address: ???, imageURL_360: ???, tags: ???, price: ???)
import 'package:fsearch/fsearch.dart';

import 'CustomWidgets/SponsoredTile.dart';

class ListPage extends StatefulWidget {
  // const Search({Key? key}) : super(key: key);
  final String category;
  final int price;
  final List<String> tags;
  final double dist;

  ListPage(this.category, this.price, this.tags, this.dist);

  @override
  _ListPageState createState() => _ListPageState();
}


class _ListPageState extends State<ListPage> {

  FSearchController _searchController = FSearchController();
  bool searching = false;

  // TextEditingController _searchController = TextEditingController();
  Future resultsLoaded = Future.value();
  List _allResults = [];
  List _resultsList = [];
  bool confused = false;

  @override
  void initState() {
    super.initState();
    _searchController.setListener(_onSearchChanged);
  }

  // @override
  // void dispose() {
  //   //_searchController.removeListener(_onSearchChanged);
  //   _searchController.dispose();
  //   super.dispose();
  // }

  _onSearchChanged() {
    searchResultsList();
    // print(_searchController.text);
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var locationSnapshot in _allResults) {
        String name = locationSnapshot['name'].toLowerCase();

        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(locationSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getLocationStreamSnapshots(widget.category, widget.price, widget.tags, widget.dist);
  }

  Future<List<QueryDocumentSnapshot>> getLocationStreamSnapshots(
      String category,
      int price,
      List<String> tags,
      double dist) async {

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

    Iterable<QueryDocumentSnapshot> docsStream =
    qs.docs
        .where((d) => checkTags(d['tags'], tags))
        .where((doc) => checkDuplicates(doc['name'], sponsoredList));

    // start
    List<QueryDocumentSnapshot> categoryList = docsStream.toList();
    categoryList.sort((a, b) {
      return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());});
    // sponsors first
    sponsoredList.addAll(categoryList);
    // end

    setState(() {
      _allResults = sponsoredList;
    });
    searchResultsList();
    return sponsoredList;
  }

  bool checkTags(List<dynamic> doc, List<String> tag) {

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
    return true;
  }

  @override
  Widget build(BuildContext context) {

    if (widget.category == "fnb" && widget.price == 0) {

      return Scaffold(
          appBar: AppBar(
              title: Text('List Recommendations',
                  style: TextStyle(color: Colors.black)),
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
                    })
              ]),
          body: Container(
              child: Stack(children: [Column(
                  children: [

              Container(height: MediaQuery.of(context).size.height / 4),

                SizedBox(
                    height: 200,
                    width: 500,
                    child: Image.network(
                  "https://lh3.googleusercontent.com/proxy/3gzVwtaanyMIgLFi21MQD1DB7Po1aQ0wFgA2FxA1Cq4eVAxHVfoUjHx9yZG25XaicAYUGGPJ2ryjYb6LGCbfryqhVHonIaWL-S4KjmQcPuYm",
                  fit: BoxFit.scaleDown)),

                  ]),
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
                                                    "This page provides a list of locations catered to your preferences, as indicated in your filters."),
                                              ]),
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
                                                    "Each location has tags that provide more insight to a location's features and a price range to meet budgeting needs."),
                                              ]),
                                        ),
                                        Container(height: 50),
                                        Text.rich(
                                          TextSpan(
                                            text: "Search Bar:",
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
                                                    "Simply type the name of the location you are looking for into the search bar and we will return you a list of locations that match your search."),
                                              ]),
                                        ),

                                        Container(height: 50),
                                        Text.rich(
                                          TextSpan(
                                            text: "Tap (List Tile):",
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
                                                    "about this particular location."),
                                              ]),
                                        ),
                                        Container(height: 50),
                                        Text.rich(
                                          TextSpan(
                                            text: "Long Press (List Tile):",
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
                                                    "This will bring up a list of"),
                                                TextSpan(
                                                    text: " bookmarks ",
                                                    style: GoogleFonts.delius(
                                                        color: Colors.pinkAccent)),
                                                TextSpan(
                                                    text:
                                                    "you currently have. You may choose multiple bookmarks to save the location to, or create new bookmarks."),
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
                )])
          ));

    }
    return Scaffold(
        appBar: AppBar(
            title: Text('List Recommendations',
                style: TextStyle(color: Colors.black)),
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
                  })
            ]),
        body: Container(
            child: Stack(children: [Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                  //   child: TextField(
                  //     controller: _searchController,
                  //     decoration: InputDecoration(
                  //       prefixIcon: Icon(Icons.search),
                  //     )
                  //   )
                  // ),

                  FSearch(
                    controller: _searchController,
                    // hints: ["Find a location",
                    //   'e.g. "Chinese Garden"',
                    // ],
                    // hintSwitchEnable: true,
                    // hintSwitchType: FSearchAnimationType.Fade,
                    corner: FSearchCorner.all(6.0),
                    cornerStyle: FSearchCornerStyle.round,
                    strokeWidth: 1.0,
                    strokeColor: Colors.blueGrey[100],
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Colors.blue[50]!,
                    //     Colors.red[50]!,
                    //   ],
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                    height: 30.0,
                    backgroundColor: Colors.transparent,
                    style: TextStyle(fontSize: 16.0, height: 1.0, color: Colors.grey[600]),
                    margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
                    padding:
                    EdgeInsets.only(left: 6.0, right: 6.0, top: 3.0, bottom: 3.0),
                    prefixes: [
                      const SizedBox(width: 6.0),
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.blueGrey[600],
                      ),
                      const SizedBox(width: 3.0)
                    ],

                    onSearch: (value) {
                      setState(() {
                        searching = true;
                      });
                    },
                  ),

                  Expanded(
                      child: ListView.builder(
                          itemCount: _resultsList.length,
                          itemBuilder: (BuildContext context, int index) {

                            List<String> images = [];
                            _resultsList[index]['imageList'].forEach((item) {
                              images.add(item as String);
                            });
                            List<String> tags = [];
                            _resultsList[index]['tags'].forEach((item) {
                              tags.add(item as String);
                            });

                            if(_resultsList[index]['sponsored']) {

                              return SponsoredTile(
                                    imgURLs: images,
                                    name: _resultsList[index]['name'],
                                    description: _resultsList[index]['description'],
                                    address: _resultsList[index]['address'],
                                    imageURL_360: _resultsList[index]['360image'],
                                    tags: tags,
                                    price: _resultsList[index]['price']);
                            }

                            return MyListTile(
                                imgURLs: images,
                                name: _resultsList[index]['name'],
                                description: _resultsList[index]['description'],
                                address: _resultsList[index]['address'],
                                imageURL_360: _resultsList[index]['360image'],
                                tags: tags,
                                price: _resultsList[index]['price']);
                          }
                      )

                  ),
                ]
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
                                              "This page provides a list of locations catered to your preferences, as indicated in your filters."),
                                    ]),
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
                                              "Each location has tags that provide more insight to a location's features and a price range to meet budgeting needs."),
                                    ]),
                              ),
                                      Container(height: 50),
                                      Text.rich(
                                        TextSpan(
                                          text: "Search Bar:",
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
                                                  "Simply type the name of the location you are looking for into the search bar and we will return you a list of locations that match your search."),
                                            ]),
                                      ),

                                      Container(height: 50),
                                      Text.rich(
                                        TextSpan(
                                          text: "Tap (List Tile):",
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
                                                  "about this particular location."),
                                            ]),
                                      ),
                                      Container(height: 50),
                                      Text.rich(
                                        TextSpan(
                                          text: "Long Press (List Tile):",
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
                                                  "This will bring up a list of"),
                                              TextSpan(
                                                  text: " bookmarks ",
                                                  style: GoogleFonts.delius(
                                                      color: Colors.pinkAccent)),
                                              TextSpan(
                                                  text:
                                                  "you currently have. You may choose multiple bookmarks to save the location to, or create new bookmarks."),
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
              )])
        ));
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'CustomWidgets/MyListTile.dart';
// // call: myListTile(imgURLs: ???, name: ???, description: ???, address: ???, imageURL_360: ???, tags: ???, price: ???)
//
// class ListPage extends StatefulWidget {
//   // const ListPage({Key key}) : super(key: key);
//   List<QueryDocumentSnapshot> locations;
//   ListPage(this.locations);
//
//   @override
//   _ListPageState createState() => _ListPageState(this.locations);
// }
//
// class _ListPageState extends State<ListPage> {
//   final ScrollController _controller = ScrollController();
//   bool _isLoading = false;
//   // List<String> _locationList = List.generate(
//   //     20, (index) => 'Item $index'); // CHANGE THIS TO A LIST OF LOCATIONS
//
//   List<QueryDocumentSnapshot> _locationList;
//   _ListPageState(this._locationList);
//
//   bool confused = false;
//
//   @override
//   void initState() {
//     _controller.addListener(_onScroll);
//     super.initState();
//   }
//
//   _onScroll() {
//     if (_controller.offset >= _controller.position.maxScrollExtent &&
//         !_controller.position.outOfRange) {
//       setState(() {
//         _isLoading = true;
//       });
//       _fetchData();
//     }
//   }
//
//   Future _fetchData() async {
//     await new Future.delayed(new Duration(seconds: 2));
//     int lastIndex = _locationList.length;
//
//     setState(() {
//       // Change this: (reached end of list and want to load the next 15 items in list)
//
//       // _locationList.addAll(
//       //     List.generate(15, (index) => "New Item ${lastIndex + index}"));
//
//       _isLoading = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: Text('List recommendations',
//                 style: TextStyle(color: Colors.black)),
//             backgroundColor: Color(0xB6C4CAE8),
//             elevation: 0.0,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//             ),
//             actions: [
//               IconButton(
//                   icon: Icon(Icons.help_outline, color: Colors.white),
//                   onPressed: () {
//                     setState(() {
//                       confused = true;
//                     });
//                   })
//             ]),
//         body: Stack(children: [
//           ListView.builder(
//             controller: _controller,
//             itemCount:
//                 // _isLoading ? _locationList.length + 1 : _locationList.length,
//                 _locationList.length,
//             itemBuilder: (context, index) {
//               if (_locationList.length == index) {
//                 return Center(
//                     child: CircularProgressIndicator(color: Colors.black));
//               } else {
//                 // Change ALL the arguments to actual data from locations
//
//                 List<String> images = [];
//                 _locationList[index]['imageList'].forEach((item) {
//                   images.add(item as String);
//                 });
//                 List<String> tags = [];
//                 _locationList[index]['tags'].forEach((item) {
//                   tags.add(item as String);
//                 });
//
//                 return MyListTile(
//                     imgURLs: images,
//                     name: _locationList[index]['name'],
//                     description: _locationList[index]['description'],
//                     address: _locationList[index]['address'],
//                     imageURL_360: _locationList[index]['360image'],
//                     tags: tags,
//                     price: _locationList[index]['price']);
//               }
//             },
//           ),
//           Visibility(
//             child: Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15.0),
//                 child: Container(
//                   color: Colors.white,
//                   height: 500,
//                   width: 275,
//                   child: Column(
//                     children: [
//                       Container(height: 10),
//                       SizedBox(
//                           child: SingleChildScrollView(
//                               child: Column(
//                             children: [
//                               Container(height: 10),
//                               Text.rich(
//                                 TextSpan(
//                                   text: "Features about this page",
//                                   style: GoogleFonts.delius(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                     text: "",
//                                     style: GoogleFonts.delius(
//                                       fontSize: 15,
//                                     ),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                           text:
//                                               "This page provides a list of locations catered to your preferences, as indicated in your filters."),
//                                     ]),
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                     text: "",
//                                     style: GoogleFonts.delius(
//                                       fontSize: 15,
//                                     ),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                           text:
//                                               "Each location has tags that provide more insight to a location's features and a price range to meet budgeting needs."),
//                                     ]),
//                               ),
//                               Container(height: 50),
//                               Text.rich(
//                                 TextSpan(
//                                   text: "Tap (List Tile):",
//                                   style: GoogleFonts.delius(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Text.rich(
//                                 TextSpan(
//                                     text: "",
//                                     style: GoogleFonts.delius(
//                                       fontSize: 15,
//                                     ),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                           text:
//                                               "This will bring you to a new page that provides"),
//                                       TextSpan(
//                                           text: " extra information ",
//                                           style: GoogleFonts.delius(
//                                               color: Colors.pinkAccent)),
//                                       TextSpan(
//                                           text:
//                                               "about this particular location"),
//                                     ]),
//                               ),
//                             ],
//                           )),
//                           height: 420,
//                           width: 250),
//                       Container(height: 10),
//                       TextButton(
//                         child: Text(
//                           "Close",
//                           style: GoogleFonts.itim(
//                             color: Colors.black,
//                             fontSize: 20,
//                           ),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             confused = false;
//                           });
//                         },
//                       ),
//                       Container(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             visible: confused,
//           )
//         ]));
//   }
// }
