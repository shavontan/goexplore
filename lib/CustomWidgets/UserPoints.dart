import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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