import 'package:flutter/material.dart';
import 'package:sms_destress/distress_essentials/prefName.dart';
import 'package:sms_destress/distress_essentials/store.dart';
import 'package:sms_destress/logo_icons.dart';

class NumberScreen extends StatefulWidget {
  String title;
  PrefNames prefName;
  String numberPref;
  String namePref;

  NumberScreen(
      {@required this.title,
      @required this.namePref,
      @required this.numberPref,
      this.prefName,
      Key key})
      : super(key: key);
  NumberScreenState createState() => NumberScreenState();
}

class NumberScreenState extends State<NumberScreen> {
  String _title = "";
  List<String> numbers = [""];
  List<String> names = [""];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _title = widget.title;
  }

  void _initList() async {
    numbers = await Store.getValues(widget.numberPref);
    names = await Store.getValues(widget.namePref);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _initList();
    return Scaffold(
      appBar: AppBar(
          leading: Icon(
            Logo.logoShield,
            color: Colors.white,
            size: 20,
          ),
          title: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red),
      body: Container(child: createNumberList()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: navigateToNumberScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToNumberScreen() {
    TextEditingController _controller = TextEditingController();
    TextEditingController _controller2 = TextEditingController();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
            title: Text("Add number", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red),
        body: Column(children: [
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Enter Number",
                hintText: "+63999......8",
                prefixIcon: Icon(Icons.contact_page),
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {},
                )),
            autofocus: true,
            onSubmitted: (val) {},
          ),
          TextField(
            controller: _controller2,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                labelText: "Enter Name",
                hintText: "Fryon",
                prefixIcon: Icon(Icons.account_box),
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {},
                )),
            autofocus: true,
            onSubmitted: (val) {},
          ),
          RaisedButton.icon(
              onPressed: () {
                addNumberItem(_controller.text);
                addNameItem(_controller2.text);
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              label: Text("Done"))
        ]),
      );
    }));
  }

  void addNumberItem(String val) {
    if (val.length > 0) {
      setState(() {
        numbers.add(val);
        Store.saveToStringListToPrefName(numbers, widget.numberPref);
      });
    }
  }

  void addNameItem(String val) {
    if (val.length > 0) {
      setState(() {
        names.add(val);
        Store.saveToStringListToPrefName(names, widget.namePref);
      });
    }
  }

  Widget createNumberList() {
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        return Card(
            child: createNumberItem(names[index], numbers[index], index));
      },
    );
  }

  Widget createNumberItem(String nameText, String numberText, int index) {
    return ListTile(
      leading: Icon(Icons.phone),
      title: Text(nameText),
      subtitle: Text(numberText),
      trailing: GestureDetector(
        child: Icon(Icons.delete, color: Colors.red),
        onTap: () => showAlertToRemove(index),
      ),
    );
  }

  void showAlertToRemove(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Do you want to delete this item?"),
            actions: [
              FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop()),
              FlatButton(
                  child: Text("Delete"),
                  onPressed: () {
                    deleteNumberItem(index);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void deleteNumberItem(int index) {
    setState(() {
      numbers.removeAt(index);
      names.removeAt(index);
      Store.saveToStringListToPrefName(numbers, widget.numberPref);
      Store.saveToStringListToPrefName(names, widget.namePref);
    });
  }
}
