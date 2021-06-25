import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

// class UserPoints extends StatefulWidget {
//   final int points;
//
//   const UserPoints({required this.points});
//
//   @override
//   _UserPointsState createState() => _UserPointsState();
// }

class UserPoints extends StatelessWidget {
// class _UserPointsState extends State<UserPoints> {

  final int points;

  const UserPoints({required this.points});

  @override
  Widget build(BuildContext context) {
    // int pts = widget.points;
    if (points == -1) {
      return InkWell(child: SizedBox(
          height: 150,
          width: 300,
          child: Card(
            color: Color(0xFFFAEEDF,),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(children: [
              Center(
                child: Text(
                  "    Sign up now \nto collect points!",
                  style: GoogleFonts.delius(
                    fontSize: 25,
                  ),
                ),
                //top: 40,
                //left: 45,
              ),
              // Positioned(
              //   child: Text(
              //     "Sign up now to collect points!",
              //     style: GoogleFonts.delius(
              //       fontSize: 45,
              //     ),
              //   ),
              //   bottom: 15,
              //   right: 15,
              // )
            ]),
          )), onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);},
      );
    }
    return SizedBox(
        height: 150,
        width: 300,
        child: Card(
          color: Color(0xFFFAEEDF,),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(children: [
            Positioned(
              child: Text(
                'You have',
                style: GoogleFonts.delius(
                  fontSize: 25,
                ),
              ),
              top: 15,
              left: 15,
            ),
            Positioned(
              child: Text(
                '$points Points',
                style: GoogleFonts.delius(
                  fontSize: 45,
                ),
              ),
              bottom: 15,
              right: 15,
            )
          ]),
        ));
  }
}