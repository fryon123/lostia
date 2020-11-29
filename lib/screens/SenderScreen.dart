import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sms/contact.dart';
import 'package:sms_destress/distress_essentials/locator.dart';
import 'package:sms_destress/distress_essentials/models/distress.dart';
import 'package:sms_destress/distress_essentials/prefName.dart';
import 'package:sms_destress/distress_essentials/sms.dart';
import 'package:sms_destress/distress_essentials/store.dart';
import 'package:sms_destress/logo_icons.dart';
import 'package:sms_destress/screens/numberList.dart';
import 'package:unicorndial/unicorndial.dart';

class SenderScreen extends StatelessWidget {
  String _name;
  var cont;
  void getContact() async {
    UserProfileProvider provider = new UserProfileProvider();
    UserProfile profile = await provider.getUserProfile();
    _name = profile.fullName;
    print(profile.fullName);
  }

  Widget build(BuildContext context) {
    getContact();
    cont = context;
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text("Send SOS")), backgroundColor: Colors.red),
      floatingActionButton: UnicornDialer(
        parentButtonBackground: Colors.red[500],
        parentButton: Icon(Icons.settings),
        childButtons: [
          UnicornButton(
            currentButton: FloatingActionButton(
              backgroundColor: Colors.red[300],
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NumberScreen(
                    title: "Your Receivers",
                    namePref: "names",
                    numberPref: "numbers",
                    prefName: PrefNames.registeredNumbers,
                  );
                }));
              },
              child: Icon(Icons.contact_page),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 180,
            ),
            Center(
              child: RaisedButton(
                onPressed: () async {
                  LocationData _d = await LocationService().GetData();

                  DistressModel _m = DistressModel(
                      latlang: LatLng(_d.latitude, _d.longitude),
                      nameString: _name,
                      timeString: DateTime.now().toString());
                  SmsBackend().SendData(_m, await Store.getValues("numbers"));
                },
                shape: CircleBorder(),
                color: Colors.red,
                child: Container(
                  child: Center(
                      child: Icon(
                    Logo.logoShield,
                    color: Colors.white,
                    size: 80,
                  )),
                  height: 200,
                  width: 200,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
