import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/topic_item.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/market/market_item.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Listing>>(
      future: FirestoreService().getListings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: const LoadingScreen()),
              ],
            ),
            bottomNavigationBar: const BottomNavBar(
              theIndex: 2,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var listings = snapshot.data!;
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
            appBar: AppBar(
              title: Text('Listings'),
              backgroundColor: Color.fromARGB(255, 232, 0, 90),
            ),
            drawer: null,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    ),
                  ],
                ),
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
          return const Text('No topics found in Firestore. Check database');
        }
      },
    );
  }
}
