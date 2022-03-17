import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/market/hot_items.dart';
import 'package:marketplace/market/new_items.dart';
import 'package:marketplace/market/view_all.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/topics/search.dart';
import 'package:marketplace/market/market_item.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Text("NTU Marketplace"),
            //Divider(),
            SizedBox(
              height: 0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(children: [
                Container(
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: ExactAssetImage('assets/home.jpg'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    //color: Colors.blue,
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 1),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Text(
                        "NTU Marketplace",
                        style: const TextStyle(
                            height: 2,
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                // bottomLeft
                                offset: Offset(-1.5, -1.5),
                                color: Color.fromARGB(255, 232, 0, 90),
                              ),
                              Shadow(
                                  // bottomRight
                                  offset: Offset(1.5, -1.5),
                                  color: Color.fromARGB(255, 232, 0, 90)),
                              Shadow(
                                  // topRight
                                  offset: Offset(1.5, 1.5),
                                  color: Color.fromARGB(255, 232, 0, 90)),
                              Shadow(
                                  // topLeft
                                  offset: Offset(-1.5, 1.5),
                                  color: Color.fromARGB(255, 232, 0, 90)),
                            ]),
                      ),
                      ElevatedButton.icon(
                          onPressed: () {
                            showSearch(context: context, delegate: Search());
                          },
                          icon: Icon(FontAwesomeIcons.search),
                          label: Text("Search",
                              style: const TextStyle(
                                  fontSize: 30, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 232, 0, 90),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)))),
                    ],
                  ),
                  alignment: Alignment.bottomCenter,
                ),
              ]),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Align(
                        child: Text(
                          'Hot items',
                          style: TextStyle(fontSize: 25),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Spacer(),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: Color.fromARGB(255, 232, 0, 90),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(20))),
                      //       child: Text('view all'),
                      //       onPressed: () {}),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  HotItems(),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Row(
                    children: [
                      Align(
                        child: Text(
                          'New items',
                          style: TextStyle(fontSize: 25),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      Spacer(),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //           primary: Color.fromARGB(255, 232, 0, 90),
                      //           shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(20))),
                      //       child: Text('view all'),
                      //       onPressed: () {}),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  NewItems(),
                  Divider(),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 232, 0, 90),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        child: Text('view all'),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ViewAllScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(
        theIndex: 2,
      ),
    );
  }
}
