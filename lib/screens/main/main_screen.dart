import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:xcel_fitness_app/screens/home/notifications.dart';
import 'package:xcel_fitness_app/screens/home/settings.dart';
import 'package:xcel_fitness_app/screens/home/workouts.dart';
import 'package:xcel_fitness_app/screens/main/content/home.dart';
import 'package:xcel_fitness_app/utility/util_widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSettingsButtonClicked = false;
  bool _isNotificationButtonClicked = false;

  void openSettingsTemplate() {
    setState(() {
      _isSettingsButtonClicked = true;
      _isNotificationButtonClicked = false;
    });
  }

  void openNotificationTemplate() {
    setState(() {
      _isNotificationButtonClicked = true;
      _isSettingsButtonClicked = false;
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
            : (_selectedIndex == 1)
                ? "Workouts"
                : "History"),
        leading: (_selectedIndex == 0)
            ? IconButton(
                icon: Icon(Icons.settings),
                onPressed: openSettingsTemplate,
              )
            : (_selectedIndex == 1)
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new SearchWorkoutTemplate()));
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new SearchHistoryTemplate()));
                    },
                  ),
        actions: <Widget>[
          (_selectedIndex == 0)
              ? IconButton(
                  icon: Icon(Icons.notifications),
                  onPressed: openNotificationTemplate,
                )
              : (_selectedIndex == 1)
                  ? IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateWorkoutTemplate()));
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.crop_din), //empty icon
                      onPressed: () {},
                    )
        ],
      ),
      body: Stack(
        children: <Widget>[
          changeUI(_selectedIndex),
          if (_isSettingsButtonClicked)
            CurvedPopup(
                child: new SettingsTemplate(),
                removePopup: () => setState(() {
                      _isSettingsButtonClicked = false;
                    })),
          if (_isNotificationButtonClicked)
            CurvedPopup(
                child: new NotificationTemplate(),
                removePopup: () => setState(() {
                      _isNotificationButtonClicked = false;
                    })),
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
