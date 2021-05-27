import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EarnPoints extends StatefulWidget {
  //const EarnPoints({Key key}) : super(key: key);

  @override
  _EarnPointsState createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  int current_points = 120;
  int points_earned = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
              children: [
                Container(height: 200),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 300,
                        width: 300,
                        child: ColoredBox(color: Colors.orangeAccent),
                      ),
                    ),
                    Positioned(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          'Congratulations! You have earned $current_points points',
                          style: GoogleFonts.quando(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      top: 40,
                      left: 50,
                    ),
                    Positioned(
                        bottom: 40,
                        left: 95,
                        child: TextButton(
                          child: Text('Confirm',
                              style: GoogleFonts.quando(
                                  fontSize: 20, color: Colors.black)),
                          onPressed: () {
                            // change USER's number of points
                            // maybe add animation? – current points --> new total number of points
                          },
                        ))
                  ],
                )
              ],
            )));
  }
}