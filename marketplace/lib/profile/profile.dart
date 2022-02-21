//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/services/auth.dart';

import 'package:marketplace/shared/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);
    var user = AuthService().user;

    if (user != null) {
      // add your UI here
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Color.fromARGB(255, 182, 36, 116),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("User information",
                    style: const TextStyle(
                        height: 2, fontSize: 25, fontWeight: FontWeight.bold)),
              ),
            ),
            Image.network(user.photoURL ?? ''),
            Text(user.displayName ?? 'Guest'),
            Text(user.email ?? ''),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 182, 36, 116),
                  ),
                  child: Text('Sign out'),
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
          ),
          body: Text('Please login'));
    }
  }
}
