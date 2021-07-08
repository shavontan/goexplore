import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'ChangePassword.dart';
import 'flutterfire.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'ProfileTracker.dart';
import 'package:provider/provider.dart';
import 'package:animated_button/animated_button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController _newName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String tempName = "";

  File tempP = File("");
  File tempB = File("");

  String email = FirebaseAuth.instance.currentUser!.email!;


  @override
  Widget build(BuildContext context) {
      final trackProfile = context.watch<ProfileTracker>();

      return FutureBuilder(
          future: Future.wait([getUsername(), getProfilePic(), getBackground()]),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
                    backgroundColor: Color(0xB6C4CAE8),
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                        Navigator.pop(context);
                      },
                    ),),
                  body: Center(child: CircularProgressIndicator()),
              backgroundColor: Colors.white);
            }


            return Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
                        child: Column(children: [
                          Stack(overflow: Overflow.visible, children: [
                            //Image.asset('assets/images/SGbackground.png', // Custom backdrop picture
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: tempB.path != "" ? FileImage(tempB) : NetworkImage((snapshot.data as List)[2]) as ImageProvider,
                                ),
                              ),
                            ),
                            // Image.network(tempBackground,
                            //     height: MediaQuery.of(context).size.height / 3,
                            //     fit: BoxFit.fill),
                            Positioned(
                              child: CircleAvatar(
                                backgroundImage:
                                //AssetImage('assets/images/SGbackground.png'), // Profile picture
                                tempP.path != "" ? FileImage(tempP) : NetworkImage((snapshot.data as List)[1]) as ImageProvider,
                                // FileImage(tempP),
                                //NetworkImage(tempProfile),
                                radius: 80.0,
                              ),
                              top: MediaQuery.of(context).size.height / 3 - 100,
                              left: (MediaQuery.of(context).size.width - 160) / 2,
                            ),
                            Positioned(
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                            ),
                          ]),
                          Container(height: 70),
                          Text(tempName == "" ? (snapshot.data as List)[0] : tempName, style: GoogleFonts.cabinSketch(fontSize: 30)),
                          Container(height: 15),
                          Text("Email: $email", style: GoogleFonts.notoSans()),
                          Container(height: 20),
                          AnimatedButton(
                            height: 58.0,
                            color: (Colors.deepPurple[100])!,
                              child: Text("Edit Display Name", style: GoogleFonts.notoSans()),
                              onPressed: () async {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                      actions: <Widget>[
                                        TextFormField(
                                          key: _formKey,
                                          controller: _newName,
                                          decoration: InputDecoration(
                                            hintText: "Enter new name",
                                          ),

                                        ),
                                        MaterialButton(onPressed: () async {
                                          String uid = await getCurrentUID();
                                          if (_newName.text.trim().isNotEmpty) {
                                            Navigator.pop(context);
                                            if (_newName.text.trim().isNotEmpty) {
                                              // FirebaseFirestore.instance.collection('users').doc(uid).update({'bookmarks': FieldValue.arrayUnion([_newBookmark.text.trim()])});
                                              setState (() {
                                                tempName = _newName.text.trim();
                                              });
                                            }
                                            _newName.clear();
                                          }

                                        },
                                          child: Text("Done"),
                                        ),
                                      ]
                                  );
                                });
                              }
                          ),
                          Container(height: 10),
                          AnimatedButton(
                              height: 58.0,
                              color: (Colors.deepPurple[100])!,
                            child: Text("Change Profile Picture", style: GoogleFonts.notoSans()),
                            onPressed: () async {

                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                    actions: <Widget>[

                                      FlatButton(onPressed: () async {
                                        PickedFile? image = await ImagePicker().getImage(source: ImageSource.camera);
                                        if (image != null) {

                                          File? pic = await ImageCropper.cropImage(sourcePath: image.path,
                                            cropStyle: CropStyle.circle,
                                            aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY:1.0),);

                                          if (pic != null) {
                                            setState(() {
                                              tempP = pic;
                                              Navigator.pop(context);
                                            });
                                          }

                                        }
                                      },
                                        child: Row(children: [Icon(Icons.camera_alt_rounded), Text("  Snap a Photo")]),
                                      ),
                                      MaterialButton(onPressed: () async {
                                        PickedFile? image = await ImagePicker().getImage(source: ImageSource.gallery);
                                        if (image != null) {

                                          File? pic = await ImageCropper.cropImage(sourcePath: image.path,
                                            cropStyle: CropStyle.circle,
                                            aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY:1.0),);

                                          if (pic != null) {
                                            setState(() {
                                              tempP = pic;
                                              Navigator.pop(context);
                                            });
                                          }
                                        }
                                      },
                                        child: Row(children: [Icon(Icons.camera_roll_rounded), Text("  Choose from Gallery")]),
                                      ),
                                    ]
                                );
                              });
                              // PickedFile? image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
                              // if (image != null) {
                              //   String profileURL = await uploadProfilePic(File(image.path));
                              //   // updateProfilePic(profileURL);
                              //   setState(() {
                              //     tempProfile = profileURL;
                              //   });
                              // }
                            }
                          ),
                          Container(height: 10),
                          AnimatedButton(
                              height: 58.0,
                              color: (Colors.deepPurple[100])!,
                              child: Text("Change Background Cover", style: GoogleFonts.notoSans()),
                              onPressed: () async {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                      actions: <Widget>[

                                        FlatButton(onPressed: () async {
                                          PickedFile? image = await ImagePicker().getImage(source: ImageSource.camera);
                                          if (image != null) {

                                            File? pic = await ImageCropper.cropImage(sourcePath: image.path,
                                              cropStyle: CropStyle.rectangle,
                                              aspectRatio: CropAspectRatio(ratioX: 7.0, ratioY: 5.0),
                                            );

                                            if (pic != null) {
                                              setState(() {
                                                tempB = pic;
                                                // tempProfile = profileURL;
                                                Navigator.pop(context);
                                              });
                                            }

                                          }
                                        },
                                          child: Row(children: [Icon(Icons.camera_alt_rounded), Text("  Snap a Photo")]),
                                        ),
                                        MaterialButton(onPressed: () async {
                                          PickedFile? image = await ImagePicker().getImage(source: ImageSource.gallery);
                                          if (image != null) {

                                            File? pic = await ImageCropper.cropImage(sourcePath: image.path,
                                              cropStyle: CropStyle.rectangle,
                                              aspectRatio: CropAspectRatio(ratioX: 7.0, ratioY: 5.0),
                                            );

                                            if (pic != null) {
                                              setState(() {
                                                tempB = pic;
                                                // tempProfile = profileURL;
                                                Navigator.pop(context);
                                              });
                                            }
                                          }
                                        },
                                          child: Row(children: [Icon(Icons.camera_roll_rounded), Text("  Choose from Gallery")]),
                                        ),
                                      ]
                                  );
                                });
                              }
                          ),
                          Container(height: 10),
                          AnimatedButton(
                              height: 58.0,
                              color: (Colors.deepPurple[50])!,
                              child: Text("Update Password", style: GoogleFonts.notoSans()),
                              onPressed: () async {
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ChangePassword()));
                              }
                          ),
                          TextButton(
                            child: Text("Confirm Changes", style: GoogleFonts.notoSans(fontWeight: FontWeight.w600)),
                            onPressed: () async {
                              if (tempP.path != "") {
                                String profileURL = await uploadProfilePic(tempP);
                                updateProfilePic(profileURL);
                                trackProfile.changeProfilePic(profileURL);
                              }

                              if (tempB.path != "") {
                                String backgroundURL = await uploadBackgroundPic(tempB);
                                updateBackgroundPic(backgroundURL);
                                trackProfile.changeBackgroundPic(backgroundURL);
                              }

                              if (tempName != "") {
                                updateUsername(tempName);
                                trackProfile.changeName(tempName);
                              }

                              Navigator.pop(context);

                            },
                          )

                        ])
                      //)
                    )
                )
            );});
  }
}


Future<String> getUsername() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['username'];});
}

Future<String> getProfilePic() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['profilePic'];});
}

Future<String> getBackground() async {
  String uid = await getCurrentUID();
  return await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((value) {return value['backgroundPic'];});
}

Future<String> uploadProfilePic(File file) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  String uid = await getCurrentUID();
  var storageRef = storage.ref().child("profilepics/$uid");
  var uploadTask = storageRef.putFile(file);
  return uploadTask.then((res) {
    return res.ref.getDownloadURL();
  });
}

Future<String> uploadBackgroundPic(File file) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  String uid = await getCurrentUID();
  var storageRef = storage.ref().child("backgrounds/$uid");
  var uploadTask = storageRef.putFile(file);
  return uploadTask.then((res) {
    return res.ref.getDownloadURL();
  });
}

Future<void> updateProfilePic(String url) async {
  String uid = await getCurrentUID();
  FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .update({'profilePic':url});
}

Future<void> updateBackgroundPic(String url) async {
  String uid = await getCurrentUID();
  FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .update({'backgroundPic':url});
}

Future<void> updateUsername(String name) async {
  String uid = await getCurrentUID();
  FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .update({'username':name});
}