import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import '../PopupBookmark.dart';
import '../flutterfire.dart';
import '../main.dart';
import 'newBookMarkTile.dart';


class MyListTile extends StatefulWidget {
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;
  final List<String> tags;
  final int price;

  const MyListTile({required this.imgURLs, required this.name, required this.description,
    required this.address, required this.imageURL_360, required this.tags, required this.price});

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {

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
    widget.imgURLs.forEach((item) {imageList.add(item as String);});

    return Center(
        child: Column(
            children: [
              InkWell(
                child: BookMarkTile(imgURLs: widget.imgURLs, name: widget.name, description: widget.description, address: widget.address, imageURL_360: widget.imageURL_360,),
                onLongPress: () async {
                  // Add to bookmarks

                  // var values = await showDialogGroupedCheckbox(
                  //     context: context,
                  //     cancelDialogText: "cancel",
                  //     isMultiSelection: true,
                  //     itemsTitle: await getBookmarks(), // List.generate(15, (index) => "$index"),
                  //     submitDialogText: "select",
                  //     dialogTitle: Text("Add " + widget.name + " to bookmarks:"),
                  //     values:  await getBookmarks()); // List.generate(15, (index) => index));
                  // if (values != null) {
                  //   print(values);
                  // }

                  showAnimatedDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      // return ClassicGeneralDialogWidget(
                      //   titleText: 'Title',
                      //   contentText: 'content',
                      //   onPositiveClick: () {
                      //     Navigator.of(context).pop();
                      //   },
                      //   onNegativeClick: () {
                      //     Navigator.of(context).pop();
                      //   },
                      // );

                      if (!isLoggedIn()) {
                        return AlertDialog(
                            title: Text("Uh Oh!"),
                            content: Text("You currently do not have an account. \n\nLog in or sign up now to start adding to bookmarks!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, child: Text("Cancel", style: TextStyle(color: Colors.grey)),),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginScreen()));
                              }, child: Text("Proceed"),)
                        ]);
                      }


                      return PopupBookmark(imgURLs: widget.imgURLs, name: widget.name,
                          description: widget.description, address: widget.address,
                          imageURL_360: widget.imageURL_360, tags: widget.tags, price: widget.price);
                    },
                    animationType: DialogTransitionType.size,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(seconds: 1),
                  );

                },
              ),
              // BookMarkTile(imgURLs: widget.imgURLs, name: widget.name, description: widget.description, address: widget.address, imageURL_360: widget.imageURL_360,),
              Row(
                children: [
                  Container(width: 20),
                  Text("Tags: ", style: GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Container(width: 10),
                  Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(toStringOfTags(widget.tags), style: GoogleFonts.delius(fontSize: 18,),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width - 100)
                ],
              ),
              Row(
                  children: [
                    Container(width: 20),
                    Text("Price: ", style: GoogleFonts.delius(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    Container(width: 12),
                    Text(PriceRange(widget.price), style: GoogleFonts.delius(fontSize: 18,),),
                  ]
              ),
              Container(height: 30,),
            ]
        )
    );
  }
}

Future<List<String>> getBookmarks() async {
  final uid = await getCurrentUID();

  List<dynamic> list = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {
    return ((value.data() as Map)['bookmarks']);
  });

  List<String> bm = [];
  list.forEach((item) {bm.add(item as String);});
  return bm;
}