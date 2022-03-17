import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/loading.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/search.dart';

class HotItems extends StatelessWidget {
  const HotItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Listing>>(
      stream: FirestoreService().getListingsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var listings = snapshot.data!;
          //listings = snapshot.data.documents;
/* 

  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: FirestoreService().getListings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var listings = snapshot.data!; */
/** 
          List<Widget> list =
              topics.map((topic) => TopicItem(topic: topic)).toList();
*/
          return Scaffold(
            /*
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 182, 36, 116),
              title: const Text('NTU Marketplace'),
              actions: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.search,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  //onPressed: () => Navigator.pushNamed(context, '/profile'),
                  onPressed: () {
                    showSearch(context: context, delegate: Search());
                  },
                )
              ],
            ),*/
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
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 1),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
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
                                  showSearch(
                                      context: context, delegate: Search());
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
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 232, 0, 90),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: Text('view all'),
                                  onPressed: () {}),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: listings
                                .map((listing) => Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.33333,
                                    child: MarketItem(listing: listing)))
                                .toList(),
                          ),
                        ),
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
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 232, 0, 90),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: Text('view all'),
                                  onPressed: () {}),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            children: listings
                                .map((listing) => Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.33333,
                                    child: MarketItem(listing: listing)))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /*GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),*/
            bottomNavigationBar: const BottomNavBar(
              theIndex: 2,
            ),
          );
        } else {
          return const Text('No items found in Firestore. Check database');
        }
      },
    );
  }
}
