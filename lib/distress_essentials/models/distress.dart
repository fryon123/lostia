import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class DistressModel {
  LatLng latLng;
  String name;
  String time;
  DistressModel({latlang, nameString, timeString}){
    latLng = latlang;
    name = nameString;
    time = timeString;
  }
}