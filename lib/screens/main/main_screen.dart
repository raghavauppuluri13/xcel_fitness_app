import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:xcel_fitness_app/screens/main/content/home.dart';
import 'package:xcel_fitness_app/screens/authentication/templates.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSettingsButtonClicked = false;

  void openSettingsTemplate() {
    setState(() {
      _isSettingsButtonClicked = true;
    });
  }

  Widget changeUI(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeUI();
      case 1:
        return Container();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text((_selectedIndex == 0)
            ? "Home"
            : (_selectedIndex == 1) ? "Workouts" : "History"),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: openSettingsTemplate,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => {},
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          changeUI(_selectedIndex),
          if (_isSettingsButtonClicked)
            Stack(children: [
              GestureDetector(
                child: Container(
                  color: Colors.black45,
                  width: screenWidth,
                  height: screenHeight,
                ),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _isSettingsButtonClicked = false;
                  });
                },
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      child: Container(
                        child: new SettingsTemplate(),
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                ),
              ),
            ]),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 500),
        color: Colors.black,
        buttonBackgroundColor: Colors.red,
        height: 50,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(FlutterIcons.dumbbell_mco, size: 30),
          Icon(Icons.history, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
