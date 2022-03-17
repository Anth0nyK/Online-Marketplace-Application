import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Listing {
  String name;
  String description;
  double price;
  String lister;
  String condition;
  String img;
  int heart;
  double longitude;
  double latitude;
  String uuid;
  String listerID;
  int time;

  Listing(
      {this.name = '',
      this.description = '',
      this.price = 0.00,
      this.lister = '',
      this.condition = '',
      this.img = '',
      this.heart = 0,
      this.longitude = 0.00,
      this.latitude = 0.00,
      this.uuid = '',
      this.listerID = '',
      this.time = 0});

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);
  Map<String, dynamic> toJson() => _$ListingToJson(this);
}

@JsonSerializable()
class Likes {
  String itemID;
  String userID;

  Likes({this.itemID = '', this.userID = ''});

  factory Likes.fromJson(Map<String, dynamic> json) => _$LikesFromJson(json);
  Map<String, dynamic> toJson() => _$LikesToJson(this);
}

@JsonSerializable()
class User {
  String userID;
  String userPic;
  String username;
  int completedTrades;
  int totalListing;
  double totalEarning;
  User(
      {this.userID = '',
      this.userPic = '',
      this.username = '',
      this.completedTrades = 0,
      this.totalListing = 0,
      this.totalEarning = 0});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Message {
  int time;
  String text;
  String senderID;

  Message({this.time = 0, this.text = '', this.senderID = ''});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class Contacts {
  String userID;
  String chatroomID;

  Contacts({this.userID = '', this.chatroomID = ''});

  factory Contacts.fromJson(Map<String, dynamic> json) =>
      _$ContactsFromJson(json);
  Map<String, dynamic> toJson() => _$ContactsToJson(this);
}

@JsonSerializable()
class Report {
  String uid;
  int total;
  Map topics;

  Report({this.uid = '', this.topics = const {}, this.total = 0});
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
