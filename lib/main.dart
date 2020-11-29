import 'package:flutter/material.dart';
import 'package:sms_destress/distress_essentials/map/maps.dart';
import 'package:sms_destress/home.dart';

void main() {
  runApp(Material());
}

class Material extends StatelessWidget {
  MapWrapper map = MapWrapper(
    symbols: [],
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
