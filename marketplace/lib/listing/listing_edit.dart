import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:marketplace/listing/listing_item.dart';
import 'package:marketplace/services/auth.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ItemEditScreen extends StatefulWidget {
  final Listing listing;

  const ItemEditScreen({Key? key, required this.listing}) : super(key: key);

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  final nameFieldController = TextEditingController();
  final priceFieldController = TextEditingController();
  final descriptionController = TextEditingController();

  late LatLng thePosition;
  late Widget _pic;
  late String theImageLink;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future<String> uploadImage() async {
    //String fileName = p.basename(image.path);
    var uuid = Uuid().v4();

    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('upload/$uuid');
    await storageRef.putFile(_photo!);
    return await storageRef.getDownloadURL();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadImage().then((String link) {
          updateImg(link);
          //this.widget.listing.img = link;
          //theImageLink = link;
          //_updateImgWidget;
        });
      } else {
        print('No image selected.');
      }
    });
  }

  void updateImg(String link) {
    setState(() {
      this.widget.listing.img = link;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    priceFieldController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _updateImgWidget() async {
    setState(() {
      _pic = CircularProgressIndicator();
    });
    Uint8List bytes =
        (await NetworkAssetBundle(Uri.parse(theImageLink)).load(theImageLink))
            .buffer
            .asUint8List();
    setState(() {
      _pic = Image.memory(bytes);
    });
  }

  var user = AuthService().user;

  String? dropdownvalue = 'New';
  var items = [
    'New',
    'Like new',
    'Used',
  ];

  @override
  void initState() {
    super.initState();
    nameFieldController.text = widget.listing.name;
    priceFieldController.text = widget.listing.price.toString();
    descriptionController.text = widget.listing.description;
    _pic = Image.network(widget.listing.img);
    dropdownvalue = widget.listing.condition;
    //imageLink = widget.listing.img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My listings > Edit'),
        backgroundColor: Color.fromARGB(255, 232, 0, 90),
      ),
      drawer: null,
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text('Item information',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                widget.listing.img,
                                fit: BoxFit.cover,
                                //key: ValueKey(widget.listing.img),
                              ),
                            ),
                          )
                          /*
                          _pic,*/
                          ,
                          ElevatedButton(
                            child: Text('UPLOAD'),
                            style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 232, 0, 90),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () {
                              _showPicker(context);
                            },
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        children: [
                          Text('Name',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
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
                          Text('Condition',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 40,
                            child: DropdownButton(
                              value: dropdownvalue,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue;
                                });
                              },
                            ),
                          ),
                          Text('Price',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                            child: TextField(
                              controller: priceFieldController,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^\d*\.?\d*)')),
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
                alignment: Alignment.center,
                child: Text('Description',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
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
                alignment: Alignment.center,
                child: Text('Pickup location',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
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
                  child: Text('SAVE'),
                  onPressed: () {
                    FirestoreService().updateItem(
                        widget.listing.uuid,
                        nameFieldController.text,
                        double.parse(priceFieldController.text),
                        descriptionController.text,
                        thePosition.latitude,
                        thePosition.longitude,
                        user?.displayName,
                        user?.uid,
                        widget.listing.img,
                        dropdownvalue);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Item information saved'),
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
  final Listing listing;

  const MapSample(
      {Key? key, required this.onLatLongChanged, required this.listing})
      : super(key: key);

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

    allMarkers.add(Marker(
      markerId: MarkerId('The location'),
      draggable: true,
      //position: _userCurrentPositionLatLng,
      position: LatLng(widget.listing.latitude, widget.listing.longitude),
      onDragEnd: ((newPosition) {
        widget.onLatLongChanged(newPosition);
      }),
    ));
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
        myLocationEnabled: true,
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.listing.latitude, widget.listing.longitude),
          zoom: 14.4746,
        ),

        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          /* 
          _location.onLocationChanged.listen((l) {
            controller
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(l.latitude!, l.longitude!),
              zoom: 15,
            )));
          });
              */
          widget.onLatLongChanged(
              LatLng(widget.listing.latitude, widget.listing.longitude));
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
