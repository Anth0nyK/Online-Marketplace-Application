//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/chat/chatroom.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/progress_bar.dart';
import 'package:marketplace/topics/drawer.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class MarketItem extends StatelessWidget {
  final Listing listing;
  const MarketItem({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ItemScreen(listing: listing),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 4,
              child: SizedBox(
                child: Image.network(
                  //'assets/covers/${listing.img}',
                  listing.img,

                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                //padding: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(left: 0, right: 0),
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
    );
  }
}

class MapSample extends StatefulWidget {
  final Listing listing;

  const MapSample({Key? key, required this.listing}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> allMarkers = [];
  @override
  void initState() {
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('The location'),
        draggable: false,
        onTap: () {
          print("Marker tapped" + widget.listing.longitude.toString());
        },
        position: LatLng(widget.listing.latitude, widget.listing.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.listing.latitude, widget.listing.longitude),
          zoom: 14.4746,
        ),
        markers: Set.from(allMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
      ),
    );
  }
}

class ItemScreen extends StatefulWidget {
  final Listing listing;

  const ItemScreen({Key? key, required this.listing}) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  int likes = 0;
  bool isLiked = false;
  String chatroomID = "";
  String userID = "";

  checkIfLikedOrNot() async {
    String itemID = widget.listing.uuid;
    var user = AuthService().user!;
    String currentUserID = user.uid;
    //var ref = FirebaseFirestore.instance.collection('users').doc(user.uid);
    DocumentSnapshot ds = await FirebaseFirestore.instance
        //.collection("users/$currentUserID/likes")
        .collection("listings/$itemID/likes")
        //'chats/$idUser/messages'
        .doc(currentUserID)
        .get();
    setState(() {
      isLiked = ds.exists;
    });
  }

  void addToContactAction(String thatguyUserID) {
    var user = AuthService().user!;
    String currentUserID = user.uid;
    if (currentUserID != thatguyUserID) {
      FirestoreService().addToContact(thatguyUserID).then((value) {
        FirestoreService().getChatroomID(thatguyUserID).then((Contacts result) {
          setState(() {
            chatroomID = result.chatroomID;
            userID = result.userID;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ChatroomScreen(
                TheRoomID: chatroomID,
                TheUsername: widget.listing.lister,
              ),
            ),
          );
        });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('You cannot start a chat with yourself'),
            );
          });
    }
  }

  void likeAction() {
    if (isLiked == false) {
      like();
    }
    if (isLiked == true) {
      unlike();
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  void like() {
    setState(() {
      likes = likes + 1;
    });

    FirestoreService().likeAnItem(widget.listing.uuid);
  }

  void unlike() {
    setState(() {
      likes = likes - 1;
    });

    FirestoreService().unlikeAnItem(widget.listing.uuid);
  }

  getLikeCounts() async {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIfLikedOrNot();
    getLikeCounts();
    setState(() {
      likes = widget.listing.heart;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 232, 0, 90),
      ),
      body: ListView(children: [
        Container(
          child: Image.network(
            widget.listing.img,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
        Divider(),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          //color: Color.fromARGB(255, 182, 36, 116),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        widget.listing.name,
                        style: const TextStyle(
                            height: 2,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "\$" + widget.listing.price.toString(),
                        style: const TextStyle(
                            height: 2,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.listing.condition,
                        style: const TextStyle(
                          height: 2,
                          fontSize: 25,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            //widget.listing.heart.toString(),
                            likes.toString(),
                            style: const TextStyle(
                              height: 2,
                              fontSize: 25,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    child: Text(widget.listing.description),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              addToContactAction(widget.listing.listerID);
                            },
                            icon: Icon(FontAwesomeIcons.solidCommentDots),
                            label: Text("Chat"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 232, 0, 90),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)))),
                      ),
                      Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              likeAction();
                            },
                            icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : FontAwesomeIcons.heart,
                                color: isLiked ? Colors.white : null),
                            label: Text("Favourite"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 232, 0, 90),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)))),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    "Pickup location",
                    style: const TextStyle(
                        height: 2, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        heightFactor: 1,
                        widthFactor: 2.5,
                        child: MapSample(
                          listing: widget.listing,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 40),
                ],
              ),
            ),
          ),
        ),

        //QuizList(topic: topic)
      ]),
    );
  }
}
