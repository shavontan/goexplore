import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Return extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(80, 240, 50, 0),
        child: Column(
            children: [
              Image.network("https://static.wikia.nocookie.net/webarebears/images/f/fa/Panda_png.png/revision/latest/scale-to-width-down/2000?cb=20200722135913", height: 200,),
              Text("Oh no, we ran out of places!  :(", style: GoogleFonts.delius(fontSize: 15),),
              FlatButton.icon(
                  onPressed: () {
                    // advKey.currentState!.reset();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.home_rounded),
                  label: Text("Return to Filters", style: GoogleFonts.delius(fontWeight: FontWeight.bold),)),
            ]
        )
    );
  }
}