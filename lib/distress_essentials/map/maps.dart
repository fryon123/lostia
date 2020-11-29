import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sms_destress/distress_essentials/locator.dart';
import 'package:sms_destress/distress_essentials/models/distress.dart';
import 'package:sms_destress/distress_essentials/sms.dart';

class MapWrapper extends StatefulWidget {
  List<LatLng> symbols = [];
  CameraPosition camPos;
  MapWrapper({
    this.camPos,
    this.symbols,
    Key key,
  }) : super(key: key);

  @override
  _MapWrapperState createState() => _MapWrapperState();
}

class _MapWrapperState extends State<MapWrapper> {
  MapboxMapController _controller;
  SmsBackend _smsBackend = SmsBackend();
  LocationService _ls = LocationService();

  void _onCreateMap(MapboxMapController c) {
    _controller = c;
    _controller.onSymbolTapped.add((argument) {
      print(argument);
    });
    _controller.symbols.clear();
    CreateSymbols();
    _ls.onLocationChangedSubs.add(onLocationChanged);
  }

  void onLocationChanged(LocationData d) {
    _controller.clearSymbols();
    _controller.clearLines();
    if (_controller != null)
      _controller.addSymbol(SymbolOptions(
          geometry: LatLng(d.latitude, d.longitude),
          iconSize: 4,
          textOffset: Offset(0, 2),
          textField: "You",
          iconImage: 'marker-15',
          iconColor: "#bd2424"));
    CreateSymbols();
  }

  void CreateSymbols() async {
    var e = await _smsBackend.getDistressMessages();
    _controller.addSymbols(_createSymbolsWithModel(e));
  }

  List<SymbolOptions> _createSymbolsWithModel(List<DistressModel> models) {
    List<SymbolOptions> _symOptions = [];
    for (int i = 0; i < models.length; i++) {
      SymbolOptions _symbolOptions = SymbolOptions(
          geometry: models[i].latLng,
          iconSize: 3,
          textOffset: Offset(0, 2),
          textField: models[i].name,
          iconImage: 'marker-15',
          iconColor: "#bd2424");
      _symOptions.add(_symbolOptions);
    }
    return _symOptions;
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken:
          "pk.eyJ1IjoiZnJ5b24xMjMiLCJhIjoiY2tpMGZ4Ymp1MGs5YTJzcWt5ZmYybjlqdiJ9.p7jjWBde-OQ03_CqvMUNFw",
      initialCameraPosition: widget.camPos,
      onMapCreated: _onCreateMap,
    );
  }
}
