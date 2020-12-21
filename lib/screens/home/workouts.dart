import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:xcel_fitness_app/utility/util_widgets.dart';

//create workout template
class CreateWorkoutTemplate extends StatefulWidget {
  CreateWorkoutTemplate();

  @override
  State<CreateWorkoutTemplate> createState() {
    return _CreateWorkoutTemplateState();
  }
}

class _CreateWorkoutTemplateState extends State<CreateWorkoutTemplate> {
  Icon _addIcon = new Icon(Icons.add);
  Icon _backIcon = new Icon(Icons.arrow_back);
  double pixelTwoWidth = 411.42857142857144;

  bool onClickedTitle = false;
  String _workoutName = "Workout 1";

  bool _addWorkoutButtonClicked = false;

  void openWorkoutsTemplate() {
    setState(() {
      _addWorkoutButtonClicked = true;
    });
  }

  Widget _appBarTitle = new Text('Workout 1', textAlign: TextAlign.center);
  TextStyle style =
      TextStyle(fontFamily: 'Lato', fontSize: 20, color: Colors.white);

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final createWorkoutButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red[600],
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
          onPressed: () {},
          child: Text(
            "Save and Create Workout",
            textAlign: TextAlign.center,
            style: style,
          ),
        ));

    return Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
            icon: _backIcon,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: (onClickedTitle)
              ? TextField(
                  style: style,
                  onChanged: (newVal) => {
                    setState(() {
                      _workoutName = newVal;
                    })
                  },
                )
              : FlatButton(
                  child: new Center(
                    child: Text(
                      _workoutName,
                      textAlign: TextAlign.center,
                      style: style,
                    ),
                  ),
                  onPressed: () => {
                    setState(() {
                      onClickedTitle = true;
                    })
                  },
                ),
          actions: <Widget>[
            IconButton(
              icon: _addIcon,
              onPressed: openWorkoutsTemplate,
            )
          ],
        ),
        body: GestureDetector(
            onTap: () => {
                  if (onClickedTitle)
                    {
                      setState(() {
                        onClickedTitle = false;
                      })
                    }
                },
            child: Stack(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(flex: 1),
                                    Spacer(flex: 1),
                                    Spacer(flex: 1),
                                    Spacer(flex: 1),
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 15.0,
                                                right: 30.0,
                                                left: 30.0),
                                            child: SizedBox(
                                              child: createWorkoutButton,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]))))),
              if (_addWorkoutButtonClicked)
                CurvedPopup(
                    child: new addWorkoutsTemplate(),
                    removePopup: () => setState(() {
                          _addWorkoutButtonClicked = false;
                        })),
            ])));
  }
}

//adding workouts template
class addWorkoutsTemplate extends StatefulWidget {
  addWorkoutsTemplate();

  @override
  State<addWorkoutsTemplate> createState() {
    return _addWorkoutsTemplateState();
  }
}

class _addWorkoutsTemplateState extends State<addWorkoutsTemplate> {
  Map exercises = {
    "Push-Up": {"category": "Chest"},
    "Bench-Press": {"category": "Chest"},
    "Squat": {"category": "Legs"},
    "Lunge": {"category": "Legs"},
    "Plank": {"category": "Core"},
    "Burpee": {"category": "Full Body"},
    "Sit-Up": {"category": "Core"},
    "Calf-Raise": {"category": "Legs"},
    "Lateral-Raise": {"category": "Arms"},
    "Bicep-Curl": {"category": "Arms"}
  };
  List<String> exercisenames = [
    'Push-Up',
    'Bench-Press',
    'Squat',
    'Lunge',
    'Plank',
    'Burpee',
    'Sit-Up',
    'Calf-Raise',
    'Lateral-Raise',
    'Bicep-Curl'
  ];

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.75,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: TextField(
              cursorColor: Colors.red,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search, color: Colors.red),
                  hintText: 'Search...',
                  suffixIcon: new Icon(Icons.mic, color: Colors.red)),
            ),
          ),
          body: Stack(children: <Widget>[
            AlphabetListScrollView(
              strList: exercisenames,
              highlightTextStyle: TextStyle(
                color: Colors.red,
              ),
              showPreview: true,
              itemBuilder: (context, index) {
                return Card(
                  //margin: EdgeInsets.fromLTRB(4.0, 2.0, 40.0, 2.0),
                  child: ListTile(
                    leading:
                        Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
                    title: Text(exercisenames[index]),
                    subtitle: Text(exercises[exercisenames[index]]['category']),
                    trailing: Icon(Icons.help_outline),
                    onTap: () => {},
                  ),
                );
              },
              indexedHeight: (i) {
                return 80;
              },
              keyboardUsage: true,
            ),
            // ListView(
            //   children: <Widget>[
            //     Card(
            //       child: ListTile(
            //         leading:
            //             Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
            //         title: Text('Push-Up'),
            //         subtitle: Text('Chest'),
            //         trailing: Icon(Icons.help_outline),
            //         onTap: () => {},
            //       ),
            //     ),
            //     Card(
            //       child: ListTile(
            //         leading:
            //             Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
            //         title: Text('Sit-Up'),
            //         subtitle: Text('Core'),
            //         trailing: Icon(Icons.help_outline),
            //         onTap: () => {},
            //       ),
            //     ),
            //   ],
            // ),
          ])),
    );
  }
}

//search workout template
class SearchWorkoutTemplate extends StatefulWidget {
  SearchWorkoutTemplate();

  @override
  State<SearchWorkoutTemplate> createState() {
    return _SearchWorkoutTemplateState();
  }
}

class _SearchWorkoutTemplateState extends State<SearchWorkoutTemplate> {
  Icon _searchIcon = new Icon(Icons.search);
  Icon _backIcon = new Icon(Icons.arrow_back);
  Widget _appBarTitle = new Center(
      child: new Text('Search Workouts', textAlign: TextAlign.center));
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: _backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          )
        ],
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',
              suffixIcon: new Icon(Icons.mic)),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Center(
            child: new Text('Search Workouts', textAlign: TextAlign.center));
      }
    });
  }
}

//search history template
class SearchHistoryTemplate extends StatefulWidget {
  SearchHistoryTemplate();

  @override
  State<SearchHistoryTemplate> createState() {
    return _SearchHistoryTemplateState();
  }
}

class _SearchHistoryTemplateState extends State<SearchHistoryTemplate> {
  Icon _searchIcon = new Icon(Icons.search);
  Icon _backIcon = new Icon(Icons.arrow_back);
  Widget _appBarTitle = new Center(
      child: new Text('Search History', textAlign: TextAlign.center));
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: _backIcon,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          )
        ],
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...',
              suffixIcon: new Icon(Icons.mic)),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Center(
            child: new Text('Search History', textAlign: TextAlign.center));
      }
    });
  }
}
