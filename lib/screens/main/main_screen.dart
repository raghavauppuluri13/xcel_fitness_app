import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:xcel_fitness_app/screens/main/content/home.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
    return Scaffold(
      body: Stack(
        children: <Widget>[changeUI(_selectedIndex)],
      ),
      appBar: new AppBar(
        centerTitle: true,
        title: Text((_selectedIndex == 0)
            ? "Home"
            : (_selectedIndex == 1) ? "Workouts" : "History"),
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => {},
          )
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
