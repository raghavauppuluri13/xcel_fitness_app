import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Center(
        child: Column(
      children: <Widget>[
        Container(
          padding: new EdgeInsets.fromLTRB(screenWidth / 20, screenHeight / 40,
              screenWidth / 20, screenHeight / 80),
          width: double.infinity,
          child: Text(
            "Today",
            textAlign: TextAlign.left,
            style: new TextStyle(
                fontSize: 36 * screenWidth / pixelTwoWidth,
                fontFamily: 'Lato-Regular'),
          ),
        ),
        Container(
            height: screenHeight * 0.59,
            width: screenWidth * 0.95,
            child: ListView(
              children: <Widget>[
                Card(
                    child: ListTile(
                  leading: Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
                  title: Text('Upper Body Workout',
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20 * screenWidth / pixelTwoWidth)),
                  subtitle: Text(
                    'Click to start workout!',
                    style:
                        TextStyle(fontSize: 16 * screenWidth / pixelTwoWidth),
                  ),
                  onTap: () => {},
                )),
              ],
            )),
      ],
    ));
  }
}
