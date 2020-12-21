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

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
      border: Border.all(
        color: Colors.red,
        width: 3.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(30.0)));
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    String _firstName = 'Sally';
    String _lastName = 'Johnson';
    String _subscription = 'Trainer';
    String _emailAddress = 'SallyJ@gmail.com';

    return Stack(children: <Widget>[
      Container(
        width: screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                child: Text(
                  "Settings",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 32 * screenWidth / pixelTwoWidth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                decoration: myBoxDecoration(),
                child: Text(
                  "  Name:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" +
                      _firstName +
                      " " +
                      _lastName +
                      "  ",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18 * screenWidth / pixelTwoWidth,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                decoration: myBoxDecoration(),
                child: Text(
                  "  Subscription:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" +
                      _subscription +
                      "  ",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18 * screenWidth / pixelTwoWidth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                decoration: myBoxDecoration(),
                child: Text(
                  "  Email:\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" +
                      _emailAddress +
                      "  ",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18 * screenWidth / pixelTwoWidth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: new EdgeInsets.all(screenHeight / 45),
              child: ButtonTheme(
                  minWidth: 150.0,
                  height: screenHeight * 0.07,
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.red[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      child: Text(
                        "Reset Password",
                        style: new TextStyle(
                            fontSize: 20 * screenWidth / pixelTwoWidth,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    onPressed: () {},
                  )),
            )
          ],
        ),
      ),
    ]);
  }
}
