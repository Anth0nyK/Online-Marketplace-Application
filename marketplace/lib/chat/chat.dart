import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/chat/contact_item.dart';
import 'package:marketplace/favourite/liked_item.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/listing/listing_create.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    return StreamBuilder<List<Contacts>>(
      stream: FirestoreService().getUserContacts(user?.uid),
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
              title: Text('My contact'),
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
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: ContactItem(
                                theContact: listing,
                              ),
                            ),
                            Divider(),
                          ],
                        ))
                    .toList(),
              ),
            ),
            bottomNavigationBar: const BottomNavBar(
              theIndex: 4,
            ),
          );
        } else {
          return const Text('No items found in Firestore. Check database');
        }
      },
    );
  }
}
