import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//notification template
class NotificationTemplate extends StatefulWidget {
  NotificationTemplate();

  @override
  State<NotificationTemplate> createState() {
    return _NotificationTemplateState();
  }
}

class _NotificationTemplateState extends State<NotificationTemplate> {
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Stack(children: <Widget>[
      SizedBox(
        width: screenWidth * 0.8,
        height: screenHeight * 0.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                child: Text(
                  "Notifications",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 32 * screenWidth / pixelTwoWidth,
                  ),
                ),
              ),
            ),
            Spacer(flex: 1),
            Padding(
              padding: EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
              child: Container(
                child: Text(
                  "No Notifications",
                  style: new TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 18 * screenWidth / pixelTwoWidth,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Spacer(flex: 1),
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
                        "Clear All",
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

