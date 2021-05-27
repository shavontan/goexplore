import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              title: Text('HomePage', style: TextStyle(color: Colors.black)),
              backgroundColor: Color(0xB6C4CAE8),
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.white),
                    onPressed: () {
                      // Navigate to profile page ---------------------------------------------------------------------------
                    }
                )
              ]
          ),
          body: Column(
            children: [
              Container(height: 60),

              Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Opacity(
                      child: ConstrainedBox(
                        child: ClipRRect(
                          child: Image.asset('assets/images/SGbackground.png'),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        constraints: BoxConstraints(maxWidth: 300, maxHeight: 200),
                      ),
                      opacity: 0.5,
                    ),
                    ConstrainedBox(
                      child: Text('Do you know what you want to do today?',
                        style: GoogleFonts.raviPrakash(
                          fontSize: 40,
                          color: Colors.black,),
                        textAlign: TextAlign.center,),
                      constraints: BoxConstraints(maxWidth: 300),
                    ),
                  ]
              ),

              Container(height: 40),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: ConstrainedBox(
                        child: Text('Yes, I have an idea!',
                          style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.black54),
                          textAlign: TextAlign.center,),
                        constraints: BoxConstraints(maxWidth: 130),
                      ),
                      onPressed: () {
                        // Go to Categories page -----------------------------------------------------------------------------------------
                      },
                    ),
                    TextButton(
                      child: ConstrainedBox(
                        child: Text('No, take me on an adventure!',
                          style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.black54),
                          textAlign: TextAlign.center,),
                        constraints: BoxConstraints(maxWidth: 130),
                      ),
                      onPressed: () {
                        // Go to Adventure page -------------------------------------------------------------------------------------------
                      },
                    )
                  ]
              ),

              Container(height: 120),

              TextButton(
                child: Text('Scan for points',
                  style: GoogleFonts.raviPrakash(fontSize: 20, color: Colors.amber),),
                onPressed: () {
                  // Go to QR page ---------------------------------------------------------------------------------------------------------
                },
              ),

              Container(height: 30),

              // ADD POINTS WIDGET ---------------------------------------------------------------------------------------------------------

            ],
          ),
        )
    );
  }
}



