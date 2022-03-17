import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/topic_item.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/listing/listing_create.dart';

class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<List<Listing>>(
        stream: FirestoreService().getListingsStream(),
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
            return Scaffold(
              appBar: AppBar(
                title: Text('All items'),
                backgroundColor: Color.fromARGB(255, 232, 0, 90),
              ),
              drawer: null,
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                //height: MediaQuery.of(context).size.height,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 2,
                  children: listings
                      .map((listing) => MarketItem(listing: listing))
                      .toList(),
                ),
              ),
              bottomNavigationBar: const BottomNavBar(
                theIndex: 2,
              ),
            );
          } else {
            return const Text('No topics found in Firestore. Check database');
          }
        },
      ),
    );
  }
}
