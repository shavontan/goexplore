import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './history.dart';

class ProfilePage extends StatefulWidget {
  //const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // GET DATA FROM STORAGE
  String username = "Karen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
                  Stack(overflow: Overflow.visible, children: [
                    Image.asset('assets/images/SGbackground.png', // Custom backdrop picture
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.cover),
                    Positioned(
                      child: CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/SGbackground.png'), // Profile picture
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
                  Text('$username', style: GoogleFonts.cabinSketch(fontSize: 30)),
                  Container(height: 25),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Edit Profile',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Your bookmarks',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Manage your points',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {},
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('History',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => History(),),);
                            },
                          )),
                    ),
                  ),
                  Container(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: SizedBox(
                      height: 50,
                      width: 300,
                      child: ColoredBox(
                          color: Color(0x33542357),
                          child: TextButton(
                            child: Text('Settings',
                                style:
                                GoogleFonts.scada(fontSize: 15, color: Colors.black)),
                            onPressed: () {},
                          )),
                    ),
                  ),
                ])
              //)
            )));
  }
}