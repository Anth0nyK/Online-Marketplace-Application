import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/models.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documments from the topics collection
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('topics');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Topic.fromJson(d));
    return topics.toList();
  }

  //Reads all documents from the listings collection
  Future<List<Listing>> getListings() async {
    var ref = _db.collection('listings');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var listings = data.map((d) => Listing.fromJson(d));

    return listings.toList();
  }

  Future<List<Listing>> getUserListings(String? userID) async {
    var ref = _db.collection('listings').where('listerID', isEqualTo: userID);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var listings = data.map((d) => Listing.fromJson(d));

    return listings.toList();
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
      'condition': condition
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

  Future<void> deleteItem(String uuid) {
    //var user = AuthService().user!;
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
}
