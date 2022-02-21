import 'package:flutter/material.dart';
import 'package:marketplace/theme.dart';

import 'package:flutter/material.dart';
import 'package:marketplace/login/login.dart';
import 'package:marketplace/shared/shared.dart';
import 'package:marketplace/topics/topics.dart';
import 'package:marketplace/services/auth.dart';
import 'package:marketplace/market/market.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
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
