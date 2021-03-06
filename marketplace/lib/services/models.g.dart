// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.00,
      lister: json['lister'] as String? ?? '',
      condition: json['condition'] as String? ?? '',
      img: json['img'] as String? ?? '',
      heart: json['heart'] as int? ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.00,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.00,
      uuid: json['uuid'] as String? ?? '',
      listerID: json['listerID'] as String? ?? '',
      time: json['time'] as int? ?? 0,
    );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'lister': instance.lister,
      'condition': instance.condition,
      'img': instance.img,
      'heart': instance.heart,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'uuid': instance.uuid,
      'listerID': instance.listerID,
      'time': instance.time,
    };

Likes _$LikesFromJson(Map<String, dynamic> json) => Likes(
      itemID: json['itemID'] as String? ?? '',
      userID: json['userID'] as String? ?? '',
    );

Map<String, dynamic> _$LikesToJson(Likes instance) => <String, dynamic>{
      'itemID': instance.itemID,
      'userID': instance.userID,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      userID: json['userID'] as String? ?? '',
      userPic: json['userPic'] as String? ?? '',
      username: json['username'] as String? ?? '',
      completedTrades: json['completedTrades'] as int? ?? 0,
      totalListing: json['totalListing'] as int? ?? 0,
      totalEarning: (json['totalEarning'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userID,
      'userPic': instance.userPic,
      'username': instance.username,
      'completedTrades': instance.completedTrades,
      'totalListing': instance.totalListing,
      'totalEarning': instance.totalEarning,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      time: json['time'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      senderID: json['senderID'] as String? ?? '',
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'time': instance.time,
      'text': instance.text,
      'senderID': instance.senderID,
    };

Contacts _$ContactsFromJson(Map<String, dynamic> json) => Contacts(
      userID: json['userID'] as String? ?? '',
      chatroomID: json['chatroomID'] as String? ?? '',
    );

Map<String, dynamic> _$ContactsToJson(Contacts instance) => <String, dynamic>{
      'userID': instance.userID,
      'chatroomID': instance.chatroomID,
    };

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      uid: json['uid'] as String? ?? '',
      topics: json['topics'] as Map<String, dynamic>? ?? const {},
      total: json['total'] as int? ?? 0,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'uid': instance.uid,
      'total': instance.total,
      'topics': instance.topics,
    };
