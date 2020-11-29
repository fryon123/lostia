import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:sms_destress/distress_essentials/prefName.dart';
import 'package:sms_destress/screens/ReceiverScreen.dart';
import 'package:sms_destress/screens/SenderScreen.dart';
import 'package:sms_destress/screens/numberList.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabItems = [
    NumberScreen(
      title: "Your Distressers",
      namePref: "names_allowed",
      numberPref: "numbers_allowed",
      prefName: PrefNames.allowedNumbers,
    ),
    SenderScreen(),
    ReceiverScreen()
  ];
  int _activePage = 1;

  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabItems[_activePage],
      bottomNavigationBar: CurvedNavigationBar(
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
          setState(() {
            _activePage = index;
          });
        },
      ),
    );
  }
}
