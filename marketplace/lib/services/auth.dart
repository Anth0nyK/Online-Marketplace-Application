import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> googleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      //if cannot find google account
      if (googleUser == null) return;
      //if can find a google account
      final googleAuth = await googleUser.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);

      var user = AuthService().user!;
      var collection = _db.collection('users');
      var docSnapshot = await collection.doc(user.uid).get();

      if (!docSnapshot.exists) {
        var ref = _db.collection('users').doc(user.uid);

        var data = {
          'userID': user.uid,
          'userPic': user.photoURL,
          'username': user.displayName,
          'totalListing': 0,
          'completedTrades': 0,
          'totalEarning': 0,
        };

        return ref.set(data, SetOptions(merge: true));
      } else {
        var ref = _db.collection('users').doc(user.uid);

        var data = {
          'userID': user.uid,
          'userPic': user.photoURL,
          'username': user.displayName
        };

        return ref.update(data);
      }
    } on FirebaseAuthException catch (e) {
      // handle error
    }
  }
}
