import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ExtraInfoPage.dart';
import '../PopupBookmark.dart';
import '../flutterfire.dart';
import '../main.dart';

class SponsoredTile extends StatelessWidget {
  final List<dynamic> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;
  final List<String> tags;
  final int price;

  SponsoredTile(
      {required this.imgURLs,
      required this.name,
      required this.description,
      required this.address,
      required this.imageURL_360,
      required this.tags,
      required this.price});

  String PriceRange(int price) {
    if (price < 0) {
      return "Invalid price stored in database";
    }

    if (price < 5) {
      return "\$";
    } else if (price < 10) {
      return "\$\$";
    } else if (price < 20) {
      return "\$\$\$";
    } else if (price < 40) {
      return "\$\$\$\$";
    } else {
      return "\$\$\$\$\$";
    }
  }

  String toStringOfTags(List<String> tags) {
    String StringOfTags = "";

    for (String tag in tags) {
      StringOfTags = StringOfTags + "# $tag   ";
    }

    return StringOfTags;
  }

  @override
  Widget build(BuildContext context) {
    List<String> imageList = [];
    this.imgURLs.forEach((item) {
      imageList.add(item as String);
    });

    // tile with sponsor banner
    return Center(
        child: Column(children: [
      InkWell(
        child: Center(
          child: InkWell(
              child: Stack(children: [
                SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width - 30,
                  child: ClipRRect(
                    child: Banner(
                        color: Colors.red[600]!,
                        message: "Sponsored",
                        location: BannerLocation.topEnd,
                        child: Opacity(
                          child: Image.network(imageList[0], fit: BoxFit.cover),
                          opacity: 0.3,
                        )),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    child: ConstrainedBox(
                      child: Text(
                        this.name,
                        style: GoogleFonts.neucha(
                            fontSize: 50, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 30,
                          maxHeight: 200),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExtraInfoPage(
                        imgURLs: imageList,
                        name: this.name,
                        description: this.description,
                        address: this.address,
                        imageURL_360: this.imageURL_360),
                  ),
                );
              }),
        ),
        onLongPress: () async {
          showAnimatedDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              if (!isLoggedIn()) {
                return AlertDialog(
                    title: Text("Uh Oh!"),
                    content: Text(
                        "You currently do not have an account. \n\nLog in or sign up now to start adding to bookmarks!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Text("Proceed"),
                      )
                    ]);
              }

              return PopupBookmark(
                  imgURLs: imageList,
                  name: this.name,
                  description: this.description,
                  address: this.address,
                  imageURL_360: this.imageURL_360,
                  tags: this.tags,
                  price: this.price);
            },
            animationType: DialogTransitionType.size,
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 1),
          );
        },
      ),
      Row(
        children: [
          Container(width: 20),
          Text(
            "Tags: ",
            style:
                GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Container(width: 10),
          Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  toStringOfTags(this.tags),
                  style: GoogleFonts.delius(
                    fontSize: 18,
                  ),
                ),
              ),
              width: MediaQuery.of(context).size.width - 100)
        ],
      ),
      Row(children: [
        Container(width: 20),
        Text(
          "Price: ",
          style: GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Container(width: 12),
        Text(
          PriceRange(this.price),
          style: GoogleFonts.delius(
            fontSize: 18,
          ),
        ),
      ]),
      Container(
        height: 30,
      ),
    ]));
  }
}
