import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/models.dart';

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

  Future<void> createItem(String uuid, String name, int price,
      String description, double latitude, double longitude) {
    var user = AuthService().user!;
    var ref = _db.collection('listings').doc(uuid);

    var data = {
      'name': name,
      'description': description,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
    };

    return ref.set(data, SetOptions(merge: true));
  }
}
