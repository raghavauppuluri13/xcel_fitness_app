import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//settings template
class SettingsTemplate extends StatefulWidget {
  SettingsTemplate();

  @override
  State<SettingsTemplate> createState() {
    return _SettingsTemplateState();
  }
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  bool _wantsToChange = false;

  String _firstName = 'Sally';
  String _lastName = 'Johnson';
  String _subscription = 'Trainer';
  String _emailAddress = 'SallyJ@gmail.com';

  void updateSettings() {
    setState(() {
      _wantsToChange = true;
    });
  }

    void applySettings() {
    setState(() {
      //TODO: have controllers from textfields contact firebase with new settings info
      _wantsToChange = false;
    });
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final updateButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[600],
        child: MaterialButton(
          //minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {
            updateSettings();
          },
          child: Text(
            "Update Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 20, color: Colors.white),
          ),
        ));

        final applyButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[600],
        child: MaterialButton(
          //minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {
            applySettings();
          },
          child: Text(
            "Apply New Settings",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 20, color: Colors.white),
          ),
        ));

    return Stack(children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Container(
                child: Text(
                  "Settings",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            (_wantsToChange)
                ? SettingsField(
                    label: "  Name: " + _firstName + " " + _lastName + "  ")
                : SettingsCard(
                    label: "Name: " + _firstName + " " + _lastName + "  "),
            (_wantsToChange)
                ? SettingsField(
                    label: "  Subscription: " + _subscription + "  ")
                : SettingsCard(label: "Subscription: " + _subscription + "  "),
            (_wantsToChange)
                ? SettingsField(label: "  Email: " + _emailAddress + "  ")
                : SettingsCard(label: _emailAddress + "  "),
            (_wantsToChange)
                ? SettingsField(label: "  Type Old Password")
                : Container(),
            (_wantsToChange)
                ? SettingsField(label: "  Type New Password")
                : Container(),
            Padding(
              padding: new EdgeInsets.all(15),
              child: (_wantsToChange) ? applyButton : updateButton,
            ),
          ],
        ),
      ),
    ]);
  }
}

class SettingsField extends StatefulWidget {
  @override
  String label; // label text for textfield

  SettingsField({Key key, this.label}) : super(key: key);

  _SettingsFieldState createState() => _SettingsFieldState();
}

class _SettingsFieldState extends State<SettingsField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(fontFamily: 'Lato', fontSize: 18),
          ),
        ));
  }
}

class SettingsCard extends StatefulWidget {
  @override
  String label; // label text for textfield

  SettingsCard({Key key, this.label}) : super(key: key);

  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
      child: Card(
          child: ListTile(
        leading: Icon(Icons.circle, color: Colors.redAccent),
        title: Text(
          widget.label,
          textAlign: TextAlign.left,
          style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
        ),
      )),
    );
  }
}
