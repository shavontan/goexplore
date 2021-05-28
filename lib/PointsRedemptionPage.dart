import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/PointRedemptionTile.dart';

class PointsRedemptionPage extends StatefulWidget {
  //const PointsRedemptionPage({Key key}) : super(key: key);

  @override
  _PointsRedemptionPageState createState() => _PointsRedemptionPageState();
}

class _PointsRedemptionPageState extends State<PointsRedemptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEDEBF6),
        appBar: AppBar(
          title:
          Text('Points redemption', style: TextStyle(color: Colors.black)),
          backgroundColor: Color(0xB6C4CAE8),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 10),
                Align(
                  child: Text(
                    "   Starbucks: ",
                    style: GoogleFonts.walterTurncoat(fontSize: 30,),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(height: 15),
                SizedBox(
                  height: 200,
                  width: 350,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                    ],
                  ),
                ),
                Container(height: 20),
                Align(
                  child: Text(
                    "   Cedele: ",
                    style: GoogleFonts.walterTurncoat(fontSize: 30,),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(height: 15),
                SizedBox(
                    height: 200,
                    width: 350,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        PointRedemptionTile(
                          picture: Image.asset('assets/images/Cedele.png'),
                          cost: 400,
                          promotion: "1 dollar off",
                          company: "Cedele",
                          shortDescription:
                          "Get 1 dollar off any purchase from Cedele (no purchase limit required)",
                        ),
                        PointRedemptionTile(
                          picture: Image.asset('assets/images/Cedele.png'),
                          cost: 400,
                          promotion: "1 dollar off",
                          company: "Cedele",
                          shortDescription:
                          "Get 1 dollar off any purchase from Cedele (no purchase limit required)",
                        ),
                        PointRedemptionTile(
                          picture: Image.asset('assets/images/Cedele.png'),
                          cost: 400,
                          promotion: "1 dollar off",
                          company: "Cedele",
                          shortDescription:
                          "Get 1 dollar off any purchase from Cedele (no purchase limit required)",
                        ),
                        PointRedemptionTile(
                          picture: Image.asset('assets/images/Cedele.png'),
                          cost: 400,
                          promotion: "1 dollar off",
                          company: "Cedele",
                          shortDescription:
                          "Get 1 dollar off any purchase from Cedele (no purchase limit required)",
                        ),
                      ],
                    )),
                Container(height: 20),
                Align(
                  child: Text(
                    "   Starbucks: ",
                    style: GoogleFonts.walterTurncoat(fontSize: 30,),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(height: 15),
                SizedBox(
                  height: 200,
                  width: 350,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 1100,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}