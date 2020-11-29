import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CurvedBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: 1,
      height: 50.0,
      items: <Widget>[
        Icon(Icons.contact_phone, size: 30, color: Colors.white),
        Icon(Icons.send, size: 30, color: Colors.white),
        Icon(Icons.location_on, size: 30, color: Colors.white),
      ],
      color: Colors.red,
      buttonBackgroundColor: Colors.red,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 600),
      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, '/receiverScreen');
        }
        if (index == 1) {
          Navigator.pushNamed(context, '/secondScreen');
        }
      },
    );
  }
}
