import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/models.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Listing>> getListingsStream() {
    var ref = _db.collection('listings');
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Listing.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  Stream<List<Listing>> getHotListingsStream() {
    var ref = _db.collection('listings').orderBy('heart', descending: true);
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Listing.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  Stream<List<Listing>> getNewListingsStream() {
    var ref = _db.collection('listings').orderBy('time', descending: true);
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Listing.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  Stream<List<Listing>> getSearchListingsStream(String query) {
    var ref = _db.collection('listings').where(
          "name",
          isGreaterThanOrEqualTo: query,
          isLessThan: query.substring(0, query.length - 1) +
              String.fromCharCode(query.codeUnitAt(query.length - 1) + 1),
        );
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Listing.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  /// Reads all documments from the topics collection
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('topics');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Topic.fromJson(d));
    return topics.toList();
  }

  Future<User> getUserDoc(String theUserID) async {
    var ref = _db.collection('users').doc(theUserID);
    var snapshot = await ref.get();
    return User.fromJson(snapshot.data() ?? {});
  }

  //Reads all documents from the listings collection
  Future<List<Listing>> getListings() async {
    var ref = _db.collection('listings');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var listings = data.map((d) => Listing.fromJson(d));

    return listings.toList();
  }

  Future<Listing> getTheItem(String? itemID) async {
    var ref = _db.collection('listings').doc(itemID);
    var snapshot = await ref.get();
    return Listing.fromJson(snapshot.data() ?? {});
  }

  Stream<List<Listing>> getUserListingsStream(String? userID) {
    var ref = _db.collection('listings').where('listerID', isEqualTo: userID);
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Listing.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  Future<List<Listing>> getUserListings(String? userID) async {
    var ref = _db.collection('listings').where('listerID', isEqualTo: userID);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var listings = data.map((d) => Listing.fromJson(d));

    return listings.toList();
  }

  Stream<List<Likes>> getUserLikesStream(String? userID) {
    //var ref = _db.collection('users/$currentUserID/likes');
    var ref = _db.collection('users/$userID/likes');
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Likes.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  Stream<List<Likes>> getLikedListingsStream() {
    var user = AuthService().user!;
    var username = user.uid;
    var ref = _db.collectionGroup('likes').where('userID', isEqualTo: username);
    //return ref.snapshots().map((doc) => Listing.fromJson(doc.data()!));
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Likes.fromJson(snapshot.data()))
        .toList());
    //return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  }

  /// Retrieves a single quiz document
  Future<Quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    return Quiz.fromJson(snapshot.data() ?? {});
  }

  /// Listens to current user's report document in Firestore
  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  /// Updates the current user's report document after completing quiz
  Future<void> updateUserReport(Quiz quiz) {
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      }
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateItemInfo(String uuid, String name, String description) {
    var user = AuthService().user!;
    var ref = _db.collection('listings').doc(uuid);

    var data = {
      'name': name,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> createItem(
      String name,
      double price,
      String description,
      double latitude,
      double longitude,
      String? username,
      String? userID,
      String? condition,
      String? img) {
    var user = AuthService().user!;
    var uuid = Uuid();
    String theUUID = uuid.v4();
    var ref = _db.collection('listings').doc(theUUID);

    var data = {
      'name': name,
      'description': description,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'uuid': theUUID,
      'lister': username,
      'listerID': userID,
      'img': img,
      'condition': condition,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> updateItem(
      String UUID,
      String name,
      double price,
      String description,
      double latitude,
      double longitude,
      String? username,
      String? userID,
      String img,
      String? condition) {
    var user = AuthService().user!;
    //UUID = '14df1eb2-7ab9-41cd-84c6-1f5d8a1957cd';
    var ref = _db.collection('listings').doc(UUID);

    var data = {
      'name': name,
      'description': description,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'lister': username,
      'listerID': userID,
      'img': img,
      'condition': condition
    };

    //var data = {'name': 'Macbook2'};

    return ref.update(data);
  }

  void myAsync(String uuid) async {
    //var collection = _db.collectionGroup('likes').where('itemID', isEqualTo: uuid);
    var collection = _db.collection('listings/$uuid/likes');
    //var collection = FirebaseFirestore.instance.collection('users/KgZdS3lPgtZBQGM9gx8GMYJXwAI2/likes');
    //var snapshot = await collection.where('itemID', isEqualTo: uuid).get();
    var snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteItem(String uuid) {
    //var user = AuthService().user!;
    //myAsync(uuid);
    // var likesRef = _db.collection('listings/$uuid/likes');
    // likesRef
    myAsync(uuid);
    var ref = _db.collection('listings').doc(uuid);
    return ref.delete();
  }

  Future<void> createUserDoc() {
    var user = AuthService().user!;
    var ref = _db.collection('users').doc(user.uid);
    var data = {
      'userID': user.uid,
    };

    return ref.set(data, SetOptions(merge: true));
/* 
    if (user != null) {
      var collection = _db.collection('users');
      var docSnapshot = await collection.doc(user.uid).get();

      if (!docSnapshot.exists) {
        var ref = _db.collection('users').doc(user.uid);

        var data = {
          'userID': user.uid,
        };

        return ref.set(data, SetOptions(merge: true));
      }
    }
  }
  */
  }

  Future<String> uploadImage(File image) async {
    //String fileName = p.basename(image.path);
    var uuid = Uuid().v4();

    firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('upload/$uuid');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  Stream<Report> streamItem() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  Future<void> likeAnItem(String? itemID) {
    var user = AuthService().user!;
    String currentUserID = user.uid;
    //'chats/$idUser/messages'
    // var ref = _db.collection('users/$currentUserID/likes').doc(itemID);
    // var data = {
    //   'itemID': itemID,
    // };

    var ref = _db.collection('listings/$itemID/likes').doc(currentUserID);
    var data = {'userID': currentUserID, 'itemID': itemID};

    _db
        .collection('listings')
        .doc(itemID)
        .update({"heart": FieldValue.increment(1)});

    return ref.set(data, SetOptions(merge: true));
  }

  Future<void> unlikeAnItem(String? itemID) {
    var user = AuthService().user!;
    String currentUserID = user.uid;

    //var ref = _db.collection('users/$currentUserID/likes').doc(itemID);
    var ref = _db.collection('listings/$itemID/likes').doc(currentUserID);

    _db
        .collection('listings')
        .doc(itemID)
        .update({"heart": FieldValue.increment(-1)});

    return ref.delete();
  }

  Future<int> getLikeCount(String? itemID) async {
    int likeCount = 0;
    var collection = _db.collection('listings');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      likeCount = data['heart'];
    }
    return likeCount;
  }

  Future<void> addToContact(String otherguyUserID) async {
    var user = AuthService().user!;
    var currentUserID = user.uid;

    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('users/$currentUserID/contacts')
        .doc(otherguyUserID)
        .get();
    bool contactExist = ds.exists;

    if (contactExist == false) {
      var uuid = Uuid();
      String theUUID = uuid.v4();
      var ref =
          _db.collection('users/$currentUserID/contacts').doc(otherguyUserID);

      var data = {
        'userID': otherguyUserID,
        'chatroomID': theUUID,
      };

      ref.set(data, SetOptions(merge: true));

      var ref2 =
          _db.collection('users/$otherguyUserID/contacts').doc(currentUserID);
      var data2 = {
        'userID': currentUserID,
        'chatroomID': theUUID,
      };

      ref2.set(data2, SetOptions(merge: true));

      var ref_chatroom = _db.collection("chats").doc(theUUID);
      var data_chatroom = {
        'contact1': currentUserID,
        'contact2': otherguyUserID
      };

      return ref_chatroom.set(data_chatroom, SetOptions(merge: true));
    }
  }

  Future<Contacts> getChatroomID(String? userID) async {
    // String roomID = "";
    var user = AuthService().user!;
    var currentUserID = user.uid;
    // var collection = _db
    //     .collection('users/$currentUserID/contacts')
    //     .where('userID', isEqualTo: userID);
    // var querySnapshot = await collection.get();
    // for (var queryDocumentSnapshot in querySnapshot.docs) {
    //   Map<String, dynamic> data = queryDocumentSnapshot.data();
    //   roomID = data['chatroomID'];
    // }
    // return roomID;

    var ref = _db.collection('users/$currentUserID/contacts').doc(userID);
    var snapshot = await ref.get();
    return Contacts.fromJson(snapshot.data() ?? {});
  }

  Stream<List<Contacts>> getUserContacts(String? userID) {
    var ref = _db.collection('users/$userID/contacts');
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Contacts.fromJson(snapshot.data()))
        .toList());
  }

  Stream<List<Message>> getMessage(String? roomID) {
    var ref = _db
        .collection('chats/$roomID/messages')
        .orderBy('time', descending: true);
    //var ref =_db.collection('chats/d1eb00a4-1c79-403f-823b-e69c63c3fe45/messages');
    return ref.snapshots().map((snapshot) => snapshot.docs
        .map((snapshot) => Message.fromJson(snapshot.data()))
        .toList());
  }

  Future<void> sendMessage(String chatroomID, String message) {
    var user = AuthService().user!;
    var ref = _db.collection('chats/$chatroomID/messages');
    var data = {
      'senderID': user.uid,
      'text': message,
      'time': DateTime.now().millisecondsSinceEpoch
    };

    return ref.add(data);
/* 
    if (user != null) {
      var collection = _db.collection('users');
      var docSnapshot = await collection.doc(user.uid).get();

      if (!docSnapshot.exists) {
        var ref = _db.collection('users').doc(user.uid);

        var data = {
          'userID': user.uid,
        };

        return ref.set(data, SetOptions(merge: true));
      }
    }
  }
  */
  }

  Future<void> updateTotalListing(int count) {
    var user = AuthService().user!;
    String currentUserID = user.uid;

    return _db
        .collection('users')
        .doc(currentUserID)
        .update({"totalListing": FieldValue.increment(count)});
  }

  Future<void> updateCompletedTrades(int count) {
    var user = AuthService().user!;
    String currentUserID = user.uid;

    return _db
        .collection('users')
        .doc(currentUserID)
        .update({"completedTrades": FieldValue.increment(count)});
  }

  Future<void> updateTotalEarning(double count) {
    var user = AuthService().user!;
    String currentUserID = user.uid;

    return _db
        .collection('users')
        .doc(currentUserID)
        .update({"totalEarning": FieldValue.increment(count)});
  }
}
