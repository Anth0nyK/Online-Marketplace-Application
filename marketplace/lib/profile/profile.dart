//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/market/market_item.dart';
import 'package:marketplace/services/firestore.dart';
import 'package:marketplace/shared/loading.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:marketplace/services/models.dart';
import 'package:marketplace/services/auth.dart';

import 'package:marketplace/shared/bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = AuthService().user;

    if (user != null) {
      return Container(
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<User>(
          future: FirestoreService().getUserDoc(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(message: snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              var theUserDoc = snapshot.data!;

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
                                height: 2,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
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
                                  Spacer(),
                                  Text(theUserDoc.totalListing.toString(),
                                      style: const TextStyle(
                                        height: 2,
                                        fontSize: 20,
                                      )),
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
                                  Spacer(),
                                  Text(theUserDoc.completedTrades.toString(),
                                      style: const TextStyle(
                                        height: 2,
                                        fontSize: 20,
                                      )),
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
                                Spacer(),
                                Text(r"$" + theUserDoc.totalEarning.toString(),
                                    style: const TextStyle(
                                      height: 2,
                                      fontSize: 20,
                                    )),
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
              return const Text('No items found in Firestore. Check database');
            }
          },
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
