import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/loading.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/search.dart';

class NewItems extends StatelessWidget {
  const NewItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<Listing>>(
        stream: FirestoreService().getNewListingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var listings = snapshot.data!;

            return Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                children: listings
                    .map((listing) => Container(
                        width: MediaQuery.of(context).size.width * 0.33333,
                        child: MarketItem(listing: listing)))
                    .toList(),
              ),
            );
          } else {
            return const Text('No items found in Firestore. Check database');
          }
        },
      ),
    );
  }
}
