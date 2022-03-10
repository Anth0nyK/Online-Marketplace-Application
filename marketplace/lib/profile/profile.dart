//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          backgroundColor: Color.fromARGB(255, 232, 0, 90),
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
            CircleAvatar(
              radius: 45,
              child: ClipOval(
                child: Image.network(
                  user.photoURL ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(user.displayName ?? 'Guest',
                style: const TextStyle(
                  height: 2,
                  fontSize: 20,
                )),
            Text(user.email ?? ''),
            Text(user.uid),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Statistics",
                            style: const TextStyle(
                                height: 2,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text("Total listing",
                              style: const TextStyle(
                                height: 2,
                                fontSize: 20,
                              )),
                          Icon(FontAwesomeIcons.clipboardList),
                        ],
                      ),
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text("Completed trades",
                              style: const TextStyle(
                                height: 2,
                                fontSize: 20,
                              )),
                          Icon(FontAwesomeIcons.check),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("Total earning",
                            style: const TextStyle(
                              height: 2,
                              fontSize: 20,
                            )),
                        Icon(FontAwesomeIcons.moneyBill),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 232, 0, 90),
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
        bottomNavigationBar: const BottomNavBar(
          theIndex: 0,
        ),
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
