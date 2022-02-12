//import 'dart:js';

import 'package:marketplace/about/about.dart';
import 'package:marketplace/profile/profile.dart';
import 'package:marketplace/login/login.dart';
import 'package:marketplace/topics/topics.dart';
import 'package:marketplace/home/home.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
