//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/shared/progress_bar.dart';
import 'package:marketplace/topics/drawer.dart';

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
                  fit: BoxFit.contain,
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
                      color: Colors.pink,
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

class ItemScreen extends StatelessWidget {
  final Listing listing;

  const ItemScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 182, 36, 116),
      ),
      body: ListView(children: [
        Container(
          child: Image.network(
            listing.img,
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
                        listing.name,
                        style: const TextStyle(
                            height: 2,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "\$" + listing.price.toString(),
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
                        listing.condition,
                        style: const TextStyle(
                          height: 2,
                          fontSize: 25,
                          //fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.pink,
                            size: 25,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            listing.heart.toString(),
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
                    child: Text(listing.description),
                    alignment: Alignment.topLeft,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(FontAwesomeIcons.solidCommentDots),
                            label: Text("Chat"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 182, 36, 116),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)))),
                      ),
                      Spacer(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(FontAwesomeIcons.solidHeart),
                            label: Text("Favourite"),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 182, 36, 116),
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
                  )
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
