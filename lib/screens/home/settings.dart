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
  Widget build(BuildContext context) {

    final updateButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[600],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {},
          child: Text(
            "Update Settings",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Lato', fontSize: 20, color: Colors.white),
          ),
        ));

    String _firstName = 'Sally';
    String _lastName = 'Johnson';
    String _subscription = 'Trainer';
    String _emailAddress = 'SallyJ@gmail.com';

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
            SettingsField(label: "  Name: " + _firstName + " " + _lastName + "  "),
            SettingsField(label: "  Subscription: " + _subscription + "  "),
            SettingsField(label: "  Email: " + _emailAddress + "  "),
            Padding(
              padding: new EdgeInsets.all(15),
              child: updateButton,
            )
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
              padding: EdgeInsets.only(
                  top: 15,
                  left: 10.0,
                  right: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 18),
                ),
                )
            );
}
}