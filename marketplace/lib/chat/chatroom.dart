import 'dart:ffi';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/chat/contact_item.dart';
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

class ChatroomScreen extends StatefulWidget {
  final String TheRoomID;
  final String TheUsername;
  const ChatroomScreen(
      {Key? key, required this.TheRoomID, required this.TheUsername})
      : super(key: key);

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  String theMessageToSend = "";
  final inputFieldController = TextEditingController();

  @override
  void dispose() {
    inputFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    inputFieldController.text = theMessageToSend;
    //imageLink = widget.listing.img;
  }

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;
    String currentuserID = user!.uid;

    String parseTimeStamp(int value) {
      var date = DateTime.fromMillisecondsSinceEpoch(value);
      var dateTime = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
      return dateTime;
    }

    return StreamBuilder<List<Message>>(
      //stream: FirestoreService().getUserContacts(user?.uid),
      stream: FirestoreService().getMessage(widget.TheRoomID),
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(widget.TheUsername),
              backgroundColor: Color.fromARGB(255, 232, 0, 90),
            ),
            drawer: null,
            body: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height * 0.7,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView(
                    reverse: true,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    children: listings
                        .map((listing) => Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 14, right: 14, top: 10, bottom: 10),
                                  child: Align(
                                    alignment:
                                        (listing.senderID != currentuserID
                                            ? Alignment.topLeft
                                            : Alignment.topRight),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: listing.senderID !=
                                                currentuserID
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(15),
                                                topRight: Radius.circular(15))
                                            : BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                        color: (listing.senderID !=
                                                currentuserID
                                            ? Colors.grey.shade200
                                            : Color.fromARGB(255, 0, 72, 119)),
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        listing.text,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: (listing.senderID !=
                                                    currentuserID
                                                ? Color.fromARGB(255, 0, 0, 0)
                                                : Color.fromARGB(
                                                    255, 255, 255, 255))),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Align(
                                      alignment:
                                          (listing.senderID != currentuserID
                                              ? Alignment.topLeft
                                              : Alignment.topRight),
                                      child: Text(
                                        parseTimeStamp(listing.time),
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      )),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  //height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 300,
                        child: TextField(
                          controller: inputFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          FirestoreService().sendMessage(
                              widget.TheRoomID, inputFieldController.text);
                          inputFieldController.text = "";
                        },
                        icon: Icon(
                          FontAwesomeIcons.locationArrow,
                          color: Color.fromARGB(255, 232, 0, 90),
                          size: 15,
                        ),
                      )
                    ],
                  ),
                )
              ],
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
