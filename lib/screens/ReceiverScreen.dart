import 'dart:core';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';
import 'package:sms_destress/distress_essentials/locator.dart';
import 'package:sms_destress/distress_essentials/map/maps.dart';
import 'package:sms_destress/distress_essentials/models/distress.dart';
import 'package:sms_destress/distress_essentials/parser.dart';
import 'package:sms_destress/distress_essentials/sms.dart';

class ReceiverScreen extends StatefulWidget {
  @override
  _ReceiverScreenState createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  bool _isList = false;
  var _currentTab;
  var _map;
  List<DistressModel> _models;
  SmsBackend _sms = SmsBackend();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sms.addSubscriberToReceive(() {
      print("received");
      setState(() {});
    });
    setDistressModels();
    _currentTab = MapWrapper(
      symbols: [LatLng(0, 0)],
      camPos: CameraPosition(target: LatLng(0, 0)),
    );
    _map = _currentTab;
  }

  void setDistressModels() async {
    _models = await SmsBackend().getDistressMessages();
    setState(() {});
  }

  void setCamera(int index) {
    setState(() {
      _isList = false;
      _currentTab = MapWrapper(
          symbols: [LatLng(0, 0)],
          camPos: CameraPosition(target: _models[index].latLng, zoom: 15));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receive", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_isList) {
                      _currentTab = Container(
                        child: DistressList(
                          onTap: setCamera,
                          m: _models,
                        ),
                      );
                    } else {
                      _currentTab = _map;
                    }
                    _isList = !_isList;
                  });
                },
                child: Icon(
                  Icons.list,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: _currentTab,
    );
  }
}

class DistressList extends StatelessWidget {
  Function onTap;
  List<DistressModel> m = [];
  DistressList({this.onTap, this.m, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: m.length,
        itemBuilder: (BuildContext ctxt, int index) {
          DateTime t = DateTime.parse(m[index].time) ?? DateTime.now();
          var diff = DateTime.now().difference(t);
          Color r = diff.inHours < 1 ? Colors.red : Colors.green;
          return Card(
            child: InkWell(
              onTap: () {
                onTap(index);
              },
              child: Column(
                children: [
                  ListTile(
                      leading: Icon(
                        Icons.circle,
                        color: r,
                      ),
                      title: Text(m[index].name),
                      subtitle: Text(m[index].time)),
                ],
              ),
            ),
          );
        });
  }
}
