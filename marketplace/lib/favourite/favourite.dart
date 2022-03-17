import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/favourite/liked_item.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/topic_item.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/listing/listing_create.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    return StreamBuilder<List<Likes>>(
      //stream: FirestoreService().getUserLikesStream(user?.uid),
      stream: FirestoreService().getLikedListingsStream(),
      // return FutureBuilder<List<Listing>>(
      //   future: FirestoreService().getUserListings(user?.uid),
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

          // if (snapshot.data == null) {
          //   return Scaffold(
          //     appBar: AppBar(
          //       title: Text('My favourite2'),
          //       backgroundColor: Color.fromARGB(255, 38, 7, 95),
          //     ),
          //     drawer: null,
          //     body: Container(),
          //   );
          // }
/** 
          List<Widget> list =
              topics.map((topic) => TopicItem(topic: topic)).toList();
*/

/* */
          return Scaffold(
            appBar: AppBar(
              title: Text('My favourite'),
              backgroundColor: Color.fromARGB(255, 232, 0, 90),
            ),
            drawer: null,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              //height: MediaQuery.of(context).size.height,
              child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.zero,
                children: listings
                    .map((listing) => Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: LikedItem(theItem: listing),
                            ),
                            Divider(),
                          ],
                        ))
                    .toList(),
              ),

              /*ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  children: listings
                      .map((listing) => Container(
                          height:
                              MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: MarketItem(listing: listing)))
                      .toList(),
                ),*/
            ),
            /*GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => TopicItem(topic: topic)).toList(),
            ),*/
            bottomNavigationBar: const BottomNavBar(
              theIndex: 1,
            ),
          );
        } else {
          return const Text('No items found in Firestore. Check database');
        }
      },
    );
  }
}
