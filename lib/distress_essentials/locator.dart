import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LocationService {
  List<Function> onLocationChangedSubs = [];
  Location _loc = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _data;

  LocationService() {
    _loc.onLocationChanged.listen((LocationData currentLocation) {
      for (int i = 0; i < onLocationChangedSubs.length; i++) {
        onLocationChangedSubs[i](currentLocation);
      }
    });
  }

  void addSubscriberToChangeLocation(Function f) {
    onLocationChangedSubs.add(f);
  }

  Future<LocationData> GetData() async {
    _serviceEnabled = await _loc.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _loc.requestService();
    }
    if (!_serviceEnabled) {
      print("Error opening service.");
    }
    _permissionGranted = await _loc.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _loc.requestPermission();
    }
    LocationData d = await _loc.getLocation();
    return d;
  }
}
