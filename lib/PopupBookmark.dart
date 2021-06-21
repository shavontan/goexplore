import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'flutterfire.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';

class PopupBookmark extends StatefulWidget {
  // const PopupBookmark({Key key}) : super(key: key);
  final List<String> imgURLs;
  final String name;
  final String description;
  final String address;
  final String imageURL_360;
  final List<String> tags;
  final int price;

  const PopupBookmark({required this.imgURLs, required this.name, required this.description,
    required this.address, required this.imageURL_360, required this.tags, required this.price});

  @override
  _PopupBookmarkState createState() => _PopupBookmarkState();
}

List<String> list = ["test1", "test2", "test3"];

final TextEditingController _newBookmark = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _PopupBookmarkState extends State<PopupBookmark> {
  CustomGroupController controller = CustomGroupController();
  bool _checked = false;
  List<bool> selected = [];

  @override
  Widget build(BuildContext context) {
    return Center(child:
      SizedBox(child:
        Scaffold(body:
        FutureBuilder<List<String>>(
          future: getBookmarks(),
            builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            int diff = snapshot.data!.length - selected.length;
            for (int i = 0; i < diff; i++) {
              selected.add(false);
            }

            if (snapshot.data!.length == 0) {
              return SingleChildScrollView(child: Column(children: [
                Container(height: MediaQuery.of(context).size.height / 4),
                Row(children: [
                  Container(width: MediaQuery.of(context).size.width / 6),
                  RaisedButton.icon(
                      onPressed: (){
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                              actions: <Widget>[
                                TextFormField(
                                  key: _formKey,
                                  controller: _newBookmark,
                                  decoration: InputDecoration(
                                    hintText: "Enter bookmark name",
                                  ),

                                ),
                                MaterialButton(onPressed: () async {
                                  String uid = await getCurrentUID();
                                  if (_newBookmark.text.trim().isNotEmpty) {
                                    Navigator.pop(context);
                                    if (_newBookmark.text.trim().isNotEmpty) {
                                      FirebaseFirestore.instance.collection('users').doc(uid).update({'bookmarks': FieldValue.arrayUnion([_newBookmark.text.trim()])});
                                      setState (() {
                                      });
                                    }
                                    _newBookmark.clear();
                                  }

                                },
                                  child: Text("Done"),
                                ),
                              ]
                          );
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add new bookmark")),
                ]),
                Container(height: MediaQuery.of(context).size.height / 3.8),
                Row(children: [
                  Container(width: MediaQuery.of(context).size.width / 2.1),
                  TextButton(child: Text("Cancel", style: TextStyle(color: Colors.grey),), onPressed: (){
                    Navigator.pop(context);
                  },),
                  TextButton(child: Text("Done"), onPressed: (){
                    List<String> bookmarks = snapshot.data!;
                    for (int i = 0; i < selected.length; i++) {
                      if (selected[i]) {

                        addLocationToBookmark(bookmarks[i], widget.name,
                            widget.description, widget.address,
                            widget.price, widget.imgURLs,
                            widget.imageURL_360, widget.tags);
                      }
                    }
                    Navigator.pop(context);
                  },),
                ]),
              ]));
            }

            return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {

              if (index == 0 && index != snapshot.data!.length - 1) {
                return Column(children: [
                  Text("Add " + widget.name + " to: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxListTile(
                    title: Row(
                      children: [
                        Text(snapshot.data![index]),
                      ],
                    ),
                    value: selected[index],
                    onChanged: (value) {
                      setState(() {
                        if (value!= null) {
                          selected[index] = value;
                      }
                      });
                    })
                ]);
              }

              if (index == 0 && index == snapshot.data!.length - 1) {
                return Column(children: [
                  Text("Add " + widget.name + " to: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxListTile(
                      title: Row(
                        children: [
                          Text(snapshot.data![index]),
                        ],
                      ),
                      value: selected[index],
                      onChanged: (value) {
                        setState(() {
                          if (value!= null) {
                            selected[index] = value;
                          }
                        });
                      }),
                  Row(children: [
                    Container(width: MediaQuery.of(context).size.width / 6),
                    RaisedButton.icon(
                        onPressed: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                                actions: <Widget>[
                                  TextFormField(
                                    key: _formKey,
                                    controller: _newBookmark,
                                    decoration: InputDecoration(
                                      hintText: "Enter bookmark name",
                                    ),

                                  ),
                                  MaterialButton(onPressed: () async {
                                    String uid = await getCurrentUID();
                                    if (_newBookmark.text.trim().isNotEmpty) {
                                      Navigator.pop(context);
                                      if (_newBookmark.text.trim().isNotEmpty) {
                                        FirebaseFirestore.instance.collection('users').doc(uid).update({'bookmarks': FieldValue.arrayUnion([_newBookmark.text.trim()])});
                                        setState (() {
                                        });
                                      }
                                      _newBookmark.clear();
                                    }

                                  },
                                    child: Text("Done"),
                                  ),
                                ]
                            );
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add new bookmark")),
                  ]),

                  Row(children: [
                    Container(width: MediaQuery.of(context).size.width / 2.1),
                    TextButton(child:  Text("Cancel", style: TextStyle(color: Colors.grey),), onPressed: (){
                      Navigator.pop(context);
                    },),
                    TextButton(child: Text("Done"), onPressed: (){
                      List<String> bookmarks = snapshot.data!;
                      for (int i = 0; i < selected.length; i++) {
                        if (selected[i]) {

                          addLocationToBookmark(bookmarks[i], widget.name,
                              widget.description, widget.address,
                              widget.price, widget.imgURLs,
                              widget.imageURL_360, widget.tags);
                        }
                      }
                      Navigator.pop(context);
                    },),
                  ]),
                ]);
              }

              if (index == snapshot.data!.length - 1) {
                return Column(children: [
                CheckboxListTile(
                  title: Row(
                    children: [
                        Text(snapshot.data![index]),
                    ],
                  ),
                  value: selected[index],
                  onChanged: (value) {
                    setState(() {
                      if (value!= null) {
                        selected[index] = value;
                      }
                    });
                  }),
                  Row(children: [
                    Container(width: MediaQuery.of(context).size.width / 6),
                    RaisedButton.icon(
                        onPressed: (){
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                                actions: <Widget>[
                                  TextFormField(
                                    key: _formKey,
                                    controller: _newBookmark,
                                    decoration: InputDecoration(
                                      hintText: "Enter bookmark name",
                                    ),

                                  ),
                                  MaterialButton(onPressed: () async {
                                    String uid = await getCurrentUID();
                                    if (_newBookmark.text.trim().isNotEmpty) {
                                      Navigator.pop(context);
                                      if (_newBookmark.text.trim().isNotEmpty) {
                                        FirebaseFirestore.instance.collection('users').doc(uid).update({'bookmarks': FieldValue.arrayUnion([_newBookmark.text.trim()])});
                                        setState (() {
                                        });
                                      }
                                      _newBookmark.clear();
                                    }

                                  },
                                    child: Text("Done"),
                                  ),
                                ]
                            );
                          });
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add new bookmark")),
                  ]),

                    Row(children: [
                      Container(width: MediaQuery.of(context).size.width / 2.1),
                      TextButton(child:  Text("Cancel", style: TextStyle(color: Colors.grey),), onPressed: (){
                        Navigator.pop(context);
                      },),
                      TextButton(child: Text("Done"), onPressed: (){
                          List<String> bookmarks = snapshot.data!;
                          for (int i = 0; i < selected.length; i++) {
                            if (selected[i]) {

                              addLocationToBookmark(bookmarks[i], widget.name,
                                  widget.description, widget.address,
                                  widget.price, widget.imgURLs,
                                  widget.imageURL_360, widget.tags);
                            }
                          }
                        Navigator.pop(context);
                      },),
                    ]),
                ]);
              }
              return CheckboxListTile(
                title: Row(
                  children: [
                    Text(snapshot.data![index]),
                  ],
                ),
                value: selected[index],
                onChanged: (value) {
                  setState(() {
                    if (value!= null) {
                      selected[index] = value;
                    }
                  });
                }
              );
            },
          );}
    )
        ),
          height: 500, width: 300)
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

void addLocationToBookmark(String bookmark, String name, String description, String address,
    int price, List<String> imageList, String image360, List<String> tags) async {
  final uid = await getCurrentUID();

  await FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection(bookmark)
        .doc(name)
        .set({
      'name' : name,
      'description' : description,
      'price' : price,
      'address' : address,
      'tags' : tags,
      'imageList' : imageList,
      '360image' : image360,
    });
}

