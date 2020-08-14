import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xcel_fitness_app/screens/main/main_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';

//login template
class LoginTemplate extends StatefulWidget {
  LoginTemplate();

  @override
  State<LoginTemplate> createState() {
    return _LoginTemplateState();
  }
}

class _LoginTemplateState extends State<LoginTemplate> {
  //variables to change UI based on state

  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;
  bool isAdmin = false;

  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.8,
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 15 * screenHeight / pixelTwoHeight),
                child: Container(
                  child: Text(
                    "Login",
                    style: new TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 32 * screenWidth / pixelTwoWidth,
                    ),
                  ),
                ),
              ),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15 * screenHeight / pixelTwoHeight),
                      child: Container(
                        width: screenWidth * 0.75,
                        //make this a TextField if using controller
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _username,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val != "") {
                              setState(() {
                                _username.text = val;
                              });
                            }

                            bool dotIsNotIn = _username.text.indexOf(".") == -1;
                            bool atIsNotIn = _username.text.indexOf("@") == -1;

                            //validate email locally

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      //make this a TextField if using controller
                      child: TextFormField(
                        controller: _password,
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18 * screenWidth / pixelTwoWidth),
                        validator: (val) /* check whether the form is valid */ {
                          if (val == "") {
                            return "Field is empty";
                          }

                          setState(() {
                            _password.text = val;
                          });

                          //validate password length
                          bool hasLengthLessThan8 = _password.text.length < 8;

                          if (hasLengthLessThan8) {
                            return "Password less than 8";
                          }

                          return null;
                        },
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: new InputDecoration(
                            icon: Icon(Icons.lock), labelText: "Password"),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                        child: !_desiresAutoLogin
                            ? Text("Enable Auto-Login",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.red[600],
                                    fontSize: 18 * screenWidth / pixelTwoWidth))
                            : Text("Disable Auto-Login",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    color: Colors.red,
                                    fontSize:
                                        18 * screenWidth / pixelTwoWidth)),
                        onPressed: () => setState(
                            () => _desiresAutoLogin = !_desiresAutoLogin),
                      ),
                    ),
                    Padding(
                      padding: new EdgeInsets.all(
                          20.0 * screenHeight / pixelTwoHeight),
                      child: ButtonTheme(
                          minWidth: 150 * screenWidth / pixelTwoWidth,
                          height: screenHeight * 0.07,
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red[600],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            child: Container(
                              child: Text(
                                "Login",
                                style: new TextStyle(
                                    fontSize: 20 * screenWidth / pixelTwoWidth,
                                    fontFamily: 'Lato'),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new HomeScreen()));
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_isLogginIn)
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.23),
                child: CircularProgressIndicator(),
              )),
      ],
    );
  }
}

//Register Template Class
class RegisterTemplate extends StatefulWidget {
  @override
  State<RegisterTemplate> createState() {
    return _RegisterTemplateState();
  }
}

class _RegisterTemplateState extends State<RegisterTemplate> {
  String _firstName;
  String _lastName;
  String _username;
  String _password;
  bool _isTryingToRegister = false; //used to give progress bar animation
  bool isNameValid = false;
  bool isAdmin = false;
  final _registrationFormKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget build(BuildContext context) {
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: screenWidth * 0.8,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 45),
                child: Container(
                    child: Text("Register",
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 32 * screenWidth / pixelTwoWidth))),
              ),
              new Form(
                  key: _registrationFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight / 60),
                        child: Container(
                          width: screenWidth * 0.75,
                          child: TextFormField(
                            style: new TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 18 * screenWidth / pixelTwoWidth),
                            textAlign: TextAlign.center,
                            decoration:
                                InputDecoration(labelText: "First Name"),
                            validator: (val) {
                              if (val == "") {
                                return "Field is empty";
                              }

                              setState(() => _firstName = val);

                              return null;
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            labelText: 'Last Name',
                          ),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }

                            setState(() => _lastName = val);
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val == "") {
                              return "Field is empty";
                            }
                            setState(() {
                              _username = val;
                            });

                            //validate email
                            bool dotIsNotIn = _username.indexOf(".") == -1;
                            bool atIsNotIn = _username.indexOf("@") == -1;

                            if (dotIsNotIn || atIsNotIn) {
                              return "Invalid Email Type";
                            }
                            return null;
                          },
                          textAlign: TextAlign.center,
                          decoration: new InputDecoration(
                            icon: Icon(Icons.mail),
                            labelText: "E-mail",
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.75,
                        child: TextFormField(
                          style: new TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            //validate password
                            if (val == "") {
                              return "Field is empty";
                            }

                            setState(() {
                              _password = val;
                            });

                            bool hasLengthLessThan8 = _password.length < 8;

                            if (hasLengthLessThan8) {
                              return "Password less than 8";
                            }

                            return null;
                          },
                          textAlign: TextAlign.center,
                          obscureText: true,
                          decoration: new InputDecoration(
                              icon: Icon(Icons.lock), labelText: "Password"),
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
                                  "Register",
                                  style: new TextStyle(
                                      fontSize:
                                          20 * screenWidth / pixelTwoWidth,
                                      fontFamily: 'Lato'),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            new HomeScreen()));
                              },
                            )),
                      )
                    ],
                  )),
            ],
          ),
        ),
        if (_isTryingToRegister) //to add the progress indicator
          Container(
              width: screenWidth * 0.8,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.27),
                child: CircularProgressIndicator(),
              ))
      ],
    );
  }
}

//settings template
class SettingsTemplate extends StatefulWidget {
  SettingsTemplate();

  @override
  State<SettingsTemplate> createState() {
    return _SettingsTemplateState();
  }
}

BoxDecoration MyBoxDecoration() {
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
                decoration: MyBoxDecoration(),
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
                decoration: MyBoxDecoration(),
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
                decoration: MyBoxDecoration(),
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
                        _addWorkoutButtonClicked = false;
                      });
                    },
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: GestureDetector(
                          child: Container(
                            child: new addWorkoutsTemplate(),
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
  Widget build(BuildContext context) {
    //used to set relative sizing based on a pixel 2 phone
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double pixelTwoWidth = 411.42857142857144;
    double pixelTwoHeight = 683.4285714285714;

    return SizedBox(
      width: screenWidth * 0.8,
      height: screenHeight * 0.6,
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
          body: ListView(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
                  title: Text('Push-Up'),
                  subtitle: Text('Chest'),
                  trailing: Icon(Icons.help_outline),
                  onTap: () => {},
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(FlutterIcons.dumbbell_faw5s, color: Colors.red),
                  title: Text('Sit-Up'),
                  subtitle: Text('Core'),
                  trailing: Icon(Icons.help_outline),
                  onTap: () => {},
                ),
              ),
            ],
          )),
    );
  }
}
