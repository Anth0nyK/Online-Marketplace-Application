import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Color.fromARGB(255, 212, 50, 145),
      unselectedItemColor: Colors.grey,
      currentIndex: 2,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.userCircle,
            size: 20,
          ),
          label: 'Profile',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.solidHeart,
            size: 20,
            //color: Colors.pink,
          ),
          label: 'Favourite',
          //backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.home,
            size: 20,
            //color: Colors.amber,
          ),
          label: 'Home',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.paperclip,
            size: 20,
          ),
          label: 'Listings',
          //backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.comment,
            size: 20,
          ),
          label: 'Chat',
          //backgroundColor: Colors.blue,
        ),
      ],
      //fixedColor: Color.fromARGB(255, 212, 50, 145),
      onTap: (int idx) {
        switch (idx) {
          case 0:
            Navigator.pushNamed(context, '/profile');
            break;
          case 1:
            Navigator.pushNamed(context, '/about');
            break;
          case 2:
            Navigator.pushNamed(context, '/');
            break;
          case 3:
            //Navigator.pushNamed(context, '/profile');
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/profile',
              (route) => false,
            );
            break;
        }
      },
    );
  }
}
