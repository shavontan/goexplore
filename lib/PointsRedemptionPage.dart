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
                    "  Food:",
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
                      Container(width: 10),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Starbucks.png'),
                        cost: 700,
                        promotion: "Buy 1 get 1 free",
                        company: "Starbucks",
                        shortDescription:
                        "Buy any Venti-sized drink and get another for free",
                      ),
                      Container(width: 10),
                      PointRedemptionTile(
                        picture: Image.asset('assets/images/Cedele.png'),
                        cost: 100,
                        promotion: "1 dollar off",
                        company: "Cedele",
                        shortDescription:
                        "Get 1 dollar off any purchase from Cedele (no purchase limit required)",
                      ),
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 400,
                        promotion: "\$5 Set Meal",
                        company: "Burger King",
                        shortDescription: "Purchase any single meal at Burger King for \$5 only (No upsizes)",
                        picture: Image.network('https://www.nex.com.sg/Image/Thumbnail?filename=vKDCGAZSlPTLULtROdRWH9cyun5Fu13nWu1UqYGW4qZJzDMzp27jSAdCI2MqkNaO&width=500&height=500', fit: BoxFit.cover,), ),
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 800, promotion: "10% off",
                        company: "Marche", shortDescription: "Get 10% off a single receipt at Marche (up to \$10)",
                        picture: Image.network('https://www.businesstimes.com.sg/sites/default/files/styles/large_popup/public/image/2018/07/31/BT_20180731_NAMARCHE31_3515906.jpg?itok=M5oAi3_f', fit: BoxFit.cover,), ),
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 300, promotion: "3 for \$10",
                        company: "Pezzo", shortDescription: "Mix and match any 3 slices of classic pizza for just \$10",
                        picture: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQa1GK8J8hmg5PK8IES4McA3KBk7IbJ2Ze5XQ&usqp=CAU', fit: BoxFit.cover,), ),
                      Container(width: 10),
                    ],
                  ),
                ),
                Container(height: 30),
                Align(
                  child: Text(
                    "  Recreational: ",
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
                        Container(width: 10),
                        PointRedemptionTile(
                          cost: 400, promotion: "\$5 Off",
                          company: "World Of Sports", shortDescription: "Exchange 200 points for \$5 voucher to spend at any World of Sports outlet",
                          picture: Image.network('http://worldofsports.com.sg/wp-content/uploads/2014/04/WOS-Banner.jpg', fit: BoxFit.cover,), ),
                        Container(width: 10),
                        PointRedemptionTile(
                          cost: 600, promotion: "1 hour of bowling",
                          company: "K bowling Club", shortDescription: "Exchange 500 points for a free 1 hour of bowling at K Bowling Club (for 2)",
                          picture: Image.network('https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1289,h_859,f_auto/w_80,x_15,y_15,g_south_west,l_klook_water/activities/jwspd30smrbl1widdirg/BowlingExperiencein313atSomersetOrchardRoad.jpg', fit: BoxFit.cover,), ),
                        Container(width: 10),
                        PointRedemptionTile(
                          cost: 800, promotion: "\$10 Off",
                          company: "Climb Central", shortDescription: "Get \$10 off for any rock climbing session booked",
                          picture: Image.network('https://www.heretoplay.com.sg/wp-content/uploads/2020/08/scaleup.jpg', fit: BoxFit.cover,), ),
                        Container(width: 10),
                        PointRedemptionTile(
                          cost: 800, promotion: "20% off",
                          company: "Adventure Paddlers", shortDescription: "Get 20% off a single receipt for any kayak rentals (up to \$10)",
                          picture: Image.network('https://www.adventurepaddlers.com.sg/wp-content/uploads/2018/09/watersports.jpg', fit: BoxFit.cover,), ),
                        Container(width: 10),
                      ],
                    )),
                Container(height: 30),
                Align(
                  child: Text(
                    "  Others:",
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
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 400, promotion: "50% off",
                        company: "7 Eleven", shortDescription: "Spend a minimum of \$5 and receive 50% of a single receipt (up to \$5)",
                        picture: Image.network('https://www.capitaland.com/content/dam/capitaland-tenants/imported/en/-/media/cma-malls/websites/storefront_560/other/7eleven_560.jpg.transform/cap-midres/image.jpg', fit: BoxFit.cover,), ),
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 400, promotion: "\$5 Off",
                        company: "Watsons", shortDescription: "Spend a minimum of \$5 and get \$5 off a single receipt at Watsons",
                        picture: Image.network('https://www.capitaland.com/content/dam/capitaland-media-library/retail/Singapore/Singapore/cma-tenants/watsons-logo-982-px-x-818.jpg.transform/cap-midres/image.jpg', fit: BoxFit.cover,), ),
                      Container(width: 10),
                      PointRedemptionTile(
                        cost: 800, promotion: "\$10 Off",
                        company: "Sephora", shortDescription: "Get \$10 off any Sephora product (no min. spending)",
                        picture: Image.network('https://www.lacanadashopping.com/sites/lacanadashopping.com/files/field/operador-logo/sephora_-_logo.jpg', fit: BoxFit.cover,), ),
                      Container(width: 10),
                    ],
                  ),
                ),
                Container(height: 15),
              ],
            )));
  }
}