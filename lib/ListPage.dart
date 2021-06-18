import 'package:flutter/material.dart';

import 'CustomWidgets/MyListTile.dart';
// call: myListTile(imgURLs: ???, name: ???, description: ???, address: ???, imageURL_360: ???, tags: ???, price: ???)


class ListPage extends StatefulWidget {
  // const ListPage({Key key}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final ScrollController _controller = ScrollController();
  bool _isLoading = false;
  List<String> _locationList = List.generate(20, (index) => 'Item $index'); // CHANGE THIS TO A LIST OF LOCATIONS

  // testing:
  List<String> testerURLs = [
    'https://1.bp.blogspot.com/-iUYjW8TuqtE/UkWmCkx_Z1I/AAAAAAAAdAA/Z08tUps8-yM/s1600/01+Cafe+Colbar+-+A+Journey+Back+In+Time+to+the+Colonial+Bar+@+9A+Whitchurch+Road+%5BNext+to+the+Upcoming+Mediapolis%5D+(Large).JPG',
    'https://live.staticflickr.com/3387/5713143243_3ee59eacbf_b.jpg',];
  String name = "Cafe Colbar";
  String address = "9A Whitchurch Road, Singapore 138839";
  String description = "An old-school kopitiam from the 1950s that is untouched by time. More text to test whether scrolling works or not Wordddddd word word word word wor down wodnf  ";
  String image_360 = "https://firebasestorage.googleapis.com/v0/b/goexplore-af61c.appspot.com/o/Adventure%20Cove%20Waterpark.jpg?alt=media&token=9c9f0129-480f-4473-b78c-f8f67955da99";
  List<String> testTags = ["one", "two", "chill", "hot", "firey", "Super", "Amazing"];
  int testPrice = 12;
  // testing ^^


  @override
  void initState() {
    _controller.addListener(_onScroll);
    super.initState();
  }

  _onScroll() {
    if (_controller.offset >=
        _controller.position.maxScrollExtent &&
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
      _locationList.addAll(
          List.generate(15, (index) => "New Item ${lastIndex+index}")
      );
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
          title: Text('Listing recommendations', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),),
        body: ListView.builder(
      controller: _controller,
      itemCount: _isLoading ? _locationList.length + 1 : _locationList.length,
      itemBuilder: (context, index) {
        if (_locationList.length == index) {
          return Center(child: CircularProgressIndicator(color: Colors.black));
        } else {
          // Change ALL the arguments to actual data from locations
          return MyListTile(imgURLs: testerURLs, name: _locationList[index], description: description, address: address, imageURL_360: image_360, tags: testTags, price: testPrice);
        }
      },
    ));
  }
}