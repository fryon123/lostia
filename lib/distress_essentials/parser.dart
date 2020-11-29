import 'package:sms_destress/distress_essentials/models/distress.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class Parser {
  String serialize({DistressModel model}) {
    LatLng ll = model.latLng;
    String parsed = model.name +
        ":" +
        ll.latitude.toString() +
        ":" +
        ll.longitude.toString() +
        ":" +
        model.time;
    return parsed;
  }

  static DistressModel parseString(String s) {
    try {
      List<String> strings = s.split(":");
      return DistressModel(
        nameString: strings[0],
        latlang: LatLng(double.parse(strings[1]), double.parse(strings[2])),
        timeString: strings[3],
      );
    } catch (e) {
      return null;
    }
  }
}
