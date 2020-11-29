import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_destress/distress_essentials/prefName.dart';

class Store {
  static void clear(String prefName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefName, "");
  }

  static void saveToStringListToPrefName(
      List<String> numbers, String prefName) async {
    String appended = _appendString(numbers);
    final prefs = await SharedPreferences.getInstance();
    final key = prefName;
    await prefs.setString(key, appended);
  }

  static Future<List<String>> getValues(String prefname) async {
    final prefs = await SharedPreferences.getInstance();

    String s = await prefs.getString(prefname) ?? "";
    if (s == null) return [""];
    List<String> _stringList = s.split(":");
    List<String> _stringListTemp = [];

    for (int i = 0; i < _stringList.length; i++) {
      if (_stringList[i] != "") _stringListTemp.add(_stringList[i]);
    }
    return _stringListTemp;
  }

  static String _appendString(List<String> numbers) {
    String appended = "";
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] != "") appended += numbers[i] + ":";
    }
    return appended;
  }
}
