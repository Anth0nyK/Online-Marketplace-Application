import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/listing/listing_edit.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/error.dart';
import 'package:marketplace/shared/loading.dart';
import 'package:marketplace/shared/progress_bar.dart';
import 'package:marketplace/topics/drawer.dart';
import 'dart:async';
import 'package:marketplace/market/market_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class LikedItem extends StatefulWidget {
  final Likes theItem;

  const LikedItem({Key? key, required this.theItem}) : super(key: key);

  @override
  State<LikedItem> createState() => _LikedItemState();
}

class _LikedItemState extends State<LikedItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Listing>(
      future: FirestoreService().getTheItem(widget.theItem.itemID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var listing = snapshot.data!;
          return Container(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ItemScreen(listing: listing),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 4,
                              child: SizedBox(
                                child: Image.network(
                                  //'assets/covers/${listing.img}',
                                  listing.img,
                                  //fit: BoxFit.contain,
                                  height: double.infinity,
                                  //height: MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                //padding: const EdgeInsets.only(left: 10, right: 10),
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                child: Row(
                                  children: [
                                    Divider(),
                                    Text(
                                      listing.name,
                                      style: const TextStyle(
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    Spacer(),
                                    Text(
                                      listing.condition,
                                      style: const TextStyle(height: 1.5),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            //Flexible(child: TopicProgress(topic: topic)),
                            Flexible(
                                child: Row(
                              children: [
                                Text("\$" + listing.price.toString()),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.solidHeart,
                                      color: Color.fromARGB(255, 232, 0, 90),
                                      size: 15,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(listing.heart.toString()),
                                  ],
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 232, 0, 90),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text('Unlike'),
                              onPressed: () {
                                FirestoreService().unlikeAnItem(listing.uuid);
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Text('No items found in Firestore. Check database');
        }
      },
    );
  }
}
