import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/MyListTile.dart';
// call: myListTile(imgURLs: ???, name: ???, description: ???, address: ???, imageURL_360: ???, tags: ???, price: ???)

class ListPage extends StatefulWidget {
  // const ListPage({Key key}) : super(key: key);
  List<QueryDocumentSnapshot> locations;
  ListPage(this.locations);

  @override
  _ListPageState createState() => _ListPageState(this.locations);
}

class _ListPageState extends State<ListPage> {
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  // List<String> _locationList = List.generate(
  //     20, (index) => 'Item $index'); // CHANGE THIS TO A LIST OF LOCATIONS

  List<QueryDocumentSnapshot> _locationList;
  _ListPageState(this._locationList);

  bool confused = false;

  // // testing:
  // List<String> testerURLs = [
  //   'https://1.bp.blogspot.com/-iUYjW8TuqtE/UkWmCkx_Z1I/AAAAAAAAdAA/Z08tUps8-yM/s1600/01+Cafe+Colbar+-+A+Journey+Back+In+Time+to+the+Colonial+Bar+@+9A+Whitchurch+Road+%5BNext+to+the+Upcoming+Mediapolis%5D+(Large).JPG',
  //   'https://live.staticflickr.com/3387/5713143243_3ee59eacbf_b.jpg',
  // ];
  // String name = "Cafe Colbar";
  // String address = "9A Whitchurch Road, Singapore 138839";
  // String description =
  //     "An old-school kopitiam from the 1950s that is untouched by time. More text to test whether scrolling works or not Wordddddd word word word word wor down wodnf  ";
  // String image_360 =
  //     "https://firebasestorage.googleapis.com/v0/b/goexplore-af61c.appspot.com/o/Adventure%20Cove%20Waterpark.jpg?alt=media&token=9c9f0129-480f-4473-b78c-f8f67955da99";
  // List<String> testTags = [
  //   "one",
  //   "two",
  //   "chill",
  //   "hot",
  //   "firey",
  //   "Super",
  //   "Amazing"
  // ];
  // int testPrice = 12;
  // // testing ^^

  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      _fetchData();
    }
  }

  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    int lastIndex = _locationList.length;

    setState(() {
      // Change this: (reached end of list and want to load the next 15 items in list)

      // _locationList.addAll(
      //     List.generate(15, (index) => "New Item ${lastIndex + index}"));

      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('List recommendations',
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
        body: Stack(children: [
          ListView.builder(
            controller: _controller,
            itemCount:
                // _isLoading ? _locationList.length + 1 : _locationList.length,
                _locationList.length,
            itemBuilder: (context, index) {
              if (_locationList.length == index) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.black));
              } else {
                // Change ALL the arguments to actual data from locations

                List<String> images = [];
                _locationList[index]['imageList'].forEach((item) {
                  images.add(item as String);
                });
                List<String> tags = [];
                _locationList[index]['tags'].forEach((item) {
                  tags.add(item as String);
                });

                return MyListTile(
                    imgURLs: images,
                    name: _locationList[index]['name'],
                    description: _locationList[index]['description'],
                    address: _locationList[index]['address'],
                    imageURL_360: _locationList[index]['360image'],
                    tags: tags,
                    price: _locationList[index]['price']);
              }
            },
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
                                              "about this particular location"),
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
        ]));
  }
}
