import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/topic_item.dart';

import 'package:marketplace/services/models.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/listing/listing_item.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';

class ListingCreateScreen extends StatefulWidget {
  const ListingCreateScreen({Key? key}) : super(key: key);

  @override
  State<ListingCreateScreen> createState() => _ListingCreateScreenState();
}

class _ListingCreateScreenState extends State<ListingCreateScreen> {
  final nameFieldController = TextEditingController();
  final priceFieldController = TextEditingController();
  final descriptionController = TextEditingController();

  late LatLng thePosition;

  @override
  void dispose() {
    nameFieldController.dispose();
    priceFieldController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My listings > Add'),
        backgroundColor: Color.fromARGB(255, 232, 0, 90),
      ),
      drawer: null,
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        children: const [
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              //labelText: 'Password',
                            ),
                          ),
                          Text('Upload photo')
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        children: [
                          Text('Name'),
                          SizedBox(
                            height: 30,
                            child: TextField(
                              controller: nameFieldController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                //labelText: 'Password',
                              ),
                            ),
                          ),
                          Text('Price'),
                          SizedBox(
                            height: 30,
                            child: TextField(
                              controller: priceFieldController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                //labelText: 'Password',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                //padding: EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Text('Description',
                    style: TextStyle(color: Colors.black, fontSize: 22)),
              ),
              SizedBox(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.85,
                child: TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Divider(),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                //padding: EdgeInsets.all(15.0),
                alignment: Alignment.centerLeft,
                child: Text('Pickup location',
                    style: TextStyle(color: Colors.black, fontSize: 22)),
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
                      onLatLongChanged: (newPosition) {
                        thePosition = newPosition;
                      },
                    ),
                  ),
                ),
              ),
              Divider(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 232, 0, 90),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text('Submit'),
                  onPressed: () {
                    FirestoreService().createItem(
                        '123123',
                        nameFieldController.text,
                        int.parse(priceFieldController.text),
                        descriptionController.text,
                        thePosition.latitude,
                        thePosition.longitude);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Created an new item'),
                          );
                        });
                  }),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: const BottomNavBar(
        theIndex: 3,
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  //final Listing listing;
  final ValueChanged<LatLng> onLatLongChanged;

  const MapSample({Key? key, required this.onLatLongChanged}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  final location.Location _location = location.Location();
  late LatLng currentPosition;
  Geolocator geolocator = Geolocator();

  late Position userLocation;

  List<Marker> allMarkers = [];

  void myAsync() async {
    await _getLocation().then((position) {
      this.userLocation = position;
      /* 
      allMarkers.add(Marker(
        markerId: MarkerId('The location'),
        draggable: true,
        //position: _userCurrentPositionLatLng,
        //position: LatLng(userLocation.latitude, userLocation.longitude),
        position: LatLng(position.latitude, position.longitude),
        onDragEnd: ((newPosition) {
          widget.onLatLongChanged(newPosition);
        }),
      ));*/
    });
  }

  @override
  void initState() {
    super.initState();

    myAsync();

    /** 
    _getLocation().then((position) {
      userLocation = position;
      //allMarkers.clear();
      return userLocation;
    }).then((value) {
      allMarkers.add(Marker(
        markerId: MarkerId('The location'),
        draggable: true,
        //position: _userCurrentPositionLatLng,
        position: LatLng(userLocation.latitude, userLocation.longitude),
        onDragEnd: ((newPosition) {
          widget.onLatLongChanged(newPosition);
        }),
      ));
    });
*/
    //var a = userLocation;

/* 
    allMarkers.add(Marker(
      markerId: MarkerId('The location'),
      draggable: true,
      //position: _userCurrentPositionLatLng,
      position: LatLng(userLocation.latitude, userLocation.longitude),
      onDragEnd: ((newPosition) {
        widget.onLatLongChanged(newPosition);
      }),
    ));
    */
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      allMarkers = [];
      allMarkers.add(Marker(
        markerId: MarkerId('The location'),
        draggable: true,
        //position: _userCurrentPositionLatLng,
        //position: LatLng(userLocation.latitude, userLocation.longitude),
        position: tappedPoint,
        onDragEnd: ((newPosition) {
          widget.onLatLongChanged(newPosition);
        }),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: GoogleMap(
        //myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(52.958121, -1.15404),
          zoom: 14.4746,
        ),

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _location.onLocationChanged.listen((l) {
            controller
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(l.latitude!, l.longitude!),
              zoom: 15,
            )));
          });
          widget.onLatLongChanged(
              LatLng(userLocation.latitude, userLocation.longitude));
        },
        //markers: Set.from(allMarkers),
        markers: Set<Marker>.of(allMarkers),
        onTap: _handleTap,

        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
      ),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }
}
