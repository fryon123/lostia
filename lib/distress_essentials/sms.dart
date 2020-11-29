import 'package:sms/sms.dart';
import 'package:sms_destress/distress_essentials/parser.dart';
import 'package:sms_destress/distress_essentials/store.dart';
import 'package:sms_destress/distress_essentials/models/distress.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class SmsService {
  SmsSender sender = new SmsSender();
  Function _listener;
  void setListener(Function listener) {
    sender.onSmsDelivered.listen((SmsMessage message) {
      print("Sms Delivered.");
      _listener = listener;
      _listener(message);
    });
  }

  void send({String message, List<String> recepients_}) async {
    for (int i = 0; i < recepients_.length; i++) {
      sender.sendSms(new SmsMessage(recepients_[i], message));
    }
  }
}

class SmsBackend {
  List<Function> onReceiveSmsSubs = [];
  SmsService ser = SmsService();
  SmsReceiver receiver = SmsReceiver();

  List<String> rec = [];
  Function onDataReceived;

  SmsBackend() {
    receiver.onSmsReceived.listen(_notify);
  }
  void _notify(msg) {
    print("notifying");
    for (int i = 0; i < onReceiveSmsSubs.length; i++) {
      print("$i iteration");
      onReceiveSmsSubs[i](msg);
    }
  }

  void addSubscriberToReceive(Function function) {
    onReceiveSmsSubs.add(function);
  }

  void SendData(DistressModel _model, List<String> rec) {
    String parsed = Parser().serialize(model: _model);
    print(parsed);
    ser.send(message: parsed, recepients_: rec);
  }

  Future<List<DistressModel>> getDistressMessages() async {
    List<String> _numbers = await Store.getValues("numbers_allowed");
    print(_numbers);
    List<DistressModel> _model = [];
    SmsQuery _query = SmsQuery();
    for (int i = 0; i < _numbers.length; i++) {
      List<SmsMessage> _messages = await _query
          .querySms(address: _numbers[i], kinds: [SmsQueryKind.Inbox]);
      for (int u = 0; u < _messages.length; u++) {
        DistressModel _parsed = Parser.parseString(_messages[u].body);
        if (_parsed != null) _model.add(_parsed);
      }
    }
    return _model;
  }
}
