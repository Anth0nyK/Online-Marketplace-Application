import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/market/market.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/services/firestore.dart';

import '../login/login.dart';

class ChatScreen extends StatelessWidget {
  //final String itemID;
  //const HomeScreen({Key? key, required this.itemID}) : super(key: key);
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('listings')
          .doc("52a7765d-c468-421e-9c83-ac7eeb23605c")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //return const LoadingScreen();
          return const Text('loading');
        } else if (snapshot.hasError) {
          return const Center(
            //child: ErrorMessage(),
            child: Text('error.'),
          );
        } else if (snapshot.hasData) {
          return const MarketScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
