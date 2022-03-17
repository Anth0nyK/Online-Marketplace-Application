import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/chat/chatroom.dart';
import 'package:marketplace/listing/listing_edit.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/error.dart';
import 'package:marketplace/shared/loading.dart';
import 'dart:async';
import 'package:marketplace/market/market_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class ContactItem extends StatelessWidget {
  final Contacts theContact;
  const ContactItem({Key? key, required this.theContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: FirestoreService().getUserDoc(theContact.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          var contact = snapshot.data!;
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ChatroomScreen(
                    TheRoomID: theContact.chatroomID,
                    TheUsername: contact.username,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 45,
                    child: ClipOval(
                      child: Image.network(
                        contact.userPic,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    contact.username,
                    style: const TextStyle(
                      //height: 1.5,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Text('No items found in Firestore. Check database');
        }
      },
    );
  }
}
