import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketplace/chat/chat.dart';
import 'package:marketplace/favourite/favourite.dart';
import 'package:marketplace/home/home.dart';
import 'package:marketplace/market/market.dart';
import 'package:marketplace/profile/profile.dart';
import 'package:marketplace/services/googleMap.dart';
import 'package:marketplace/listing/listing.dart';

class BottomNavBar extends StatelessWidget {
  final int? theIndex;

  const BottomNavBar({Key? key, @required this.theIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.grey,
      //unselectedItemColor: Colors.grey,
      currentIndex: 2,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.userCircle,
            size: 20,
            color:
                theIndex == 0 ? Color.fromARGB(255, 212, 50, 145) : Colors.grey,
          ),
          label: 'Profile',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.solidHeart,
            size: 20,
            color:
                theIndex == 1 ? Color.fromARGB(255, 212, 50, 145) : Colors.grey,
            //color: Colors.pink,
          ),
          label: 'Favourite',
          //backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.home,
            size: 20,
            color:
                theIndex == 2 ? Color.fromARGB(255, 212, 50, 145) : Colors.grey,
            //color: Colors.amber,
          ),
          label: 'Home',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.paperclip,
            size: 20,
            color:
                theIndex == 3 ? Color.fromARGB(255, 212, 50, 145) : Colors.grey,
          ),
          label: 'Listings',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.comment,
            size: 20,
            color:
                theIndex == 4 ? Color.fromARGB(255, 212, 50, 145) : Colors.grey,
          ),
          label: 'Chat',
          //backgroundColor: Colors.blue,
        ),
      ],
      //fixedColor: Color.fromARGB(255, 212, 50, 145),
      onTap: (int idx) {
        switch (idx) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ProfileScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => LikeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    MarketScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 3:
            //Navigator.pushNamed(context, '/profile');
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    ListingScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 4:
            //Navigator.pushNamed(context, '/profile');
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => ChatScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
        }
      },
    );
  }
}
