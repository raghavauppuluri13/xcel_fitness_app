import 'dart:convert';
import 'dart:io';

import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gsheets/gsheets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xcel_fitness_app/screens/main/main_screen.dart';
import 'package:xcel_fitness_app/utility/config.dart';
import 'package:xcel_fitness_app/utility/global.dart';
import 'package:xcel_fitness_app/utility/notifiers.dart';

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

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  String _tier = "";

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;

  _LoginTemplateState() {
    autoLogin();
  }

  //will auto fill the user's information in the controllers
  void autoLogin() async {
    final appDirectory =
        await getApplicationDocumentsDirectory(); //get app directory

    //check whether the file exists
    if (File(appDirectory.path + "/user.json").existsSync()) {
      Map userInfo = json.decode(File(appDirectory.path + "/user.json")
          .readAsStringSync()); //read data from file

      //alter UI with the autofill information
      setState(() {
        _desiresAutoLogin = userInfo['auto'];

        if (_desiresAutoLogin) {
          _email.text = userInfo['email'];
          _password.text = userInfo['password'];
        }
      });
    } else {
      Global.userDataFile = File(appDirectory.path + "/user.json");
    }
  }

  //try executing the actual login process
  void executeLogin() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _email.text, password: _password.text)
        .then((authResult) async /*sign in callback */ {
      String userId =
          authResult.user.uid; //used to query for the user data in firestore

      Global.uid = userId;

      DocumentSnapshot userDocument = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .get();
      var userData = userDocument.data();

      // Sets tier
      _tier = userData["tier"];
      Global.tier = _tier;

      final appDirectory = await getApplicationDocumentsDirectory();

      //write to json file

      final userStorageFile = File(appDirectory.path + "/user.json");

      //setting the state container file to the userStorageFile

      Global.userDataFile = userStorageFile;

      assert(Global.userDataFile != null);

      Map jsonInformation = {
        'auto': _desiresAutoLogin,
        'email': _email.text,
        'password': _password.text,
        'tier': _tier
      };

      await Global.userDataFile.writeAsString(
          json.encode(jsonInformation)); //update file information

      //changes screen to profile screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new HomeScreen()));
    }).catchError((error) {
      print(error);

      setState(() => _isLogginIn = false);
      //if credentials are invalid then throw the error
      if (error.toString().contains("INVALID") ||
          error.toString().contains("WRONG") ||
          error.toString().contains("NOT_FOUND")) {
        showDialog(
            context: context,
            builder: (context) {
              return SingleActionPopup(
                  "Invalid Credentials", "Error", Colors.black);
            });
      }

      //if network times out, throw error
      else if (error.toString().contains("NETWORK")) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorPopup(
                  "Network timed out, please check your wifi connection", () {
                Navigator.of(context).pop();
                setState(() {
                  _isLogginIn = true;
                });
                executeLogin();
              });
            });
      }
    });
  }

  //grabs login information from cloud firestore
  void tryToLogin() async {
    setState(() {
      _isLogginIn = true;
    });
    executeLogin();
    // Connectivity()
    //     .checkConnectivity()
    //     .then((connectionState) /*check whether phone is connected to wifi */ {
    //   if (connectionState == ConnectivityResult.none) {
    //     //connection is not established
    //     throw Exception("Phone is not connected to wifi");
    //   } else {
    //     executeLogin();
    //   }
    // }).catchError((error) {
    //   setState(() => _isLogginIn = false);

    //   //wifi exception
    //   if (error.toString().contains("Phone")) {
    //     //show error in UI
    //     showDialog(
    //         context: context,
    //         builder: (context) {
    //           return ErrorPopup("Phone is not connected to Wifi",
    //               () /*actions */ {
    //             Navigator.of(context).pop();
    //             tryToLogin();
    //           });
    //         });
    //   }
    // });

    //grabbing the information from firebase auth
  }

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
                          controller: _email,
                          style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18 * screenWidth / pixelTwoWidth),
                          validator: (val) {
                            if (val != "") {
                              setState(() {
                                _email.text = val;
                              });
                            }

                            bool dotIsNotIn = _email.text.indexOf(".") == -1;
                            bool atIsNotIn = _email.text.indexOf("@") == -1;

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
                            onPressed: () => tryToLogin(),
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
  String _email;
  String _password;
  String _tier;
  bool _isTryingToRegister = false; //used to give progress bar animation
  bool isNameValid = false;

  final _registrationFormKey = GlobalKey<FormState>();

  Future<String> authenticateUser() async {
    String newUid;
    UserCredential authRes = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _email.trim(), password: _password.trim());
    newUid = authRes.user.uid;

    //cache results

    //write to json file
    final appDirectory = await getApplicationDocumentsDirectory();
    final userStorageFile = File(appDirectory.path + "/user.json");

    //basic user information
    Map jsonInformation = {
      'auto': true,
      'email': _email,
      'password': _password,
      'tier': _tier,
    } as Map;

    userStorageFile.writeAsStringSync(
        json.encode(jsonInformation)); //write to fie syncronolys

    //persist useful references like File Pointers
    Global.userDataFile = userStorageFile;
    Global.uid = newUid;

    //create new document with data

    Map<String, dynamic> updatedUserData = {
      "first_name": _firstName.trim(),
      "email": _email.trim(),
      "last_name": _lastName.trim(),
      "tier": _tier.trim(),
      "uid": newUid,
    };

    await Firestore.instance
        .collection("Users")
        .document(newUid)
        .setData(updatedUserData);
    // usersMap[fullName] = newUid;

    // await Firestore.instance
    //     .collection("Aggregators")
    //     .document("User")
    //     .updateData({"users": usersMap as Map});

    return "Finished";
  }

  //executes the actual registration
  void executeRegistration() async {
    final gsheets = GSheets(gsheetsConfig);
    final ss = await gsheets.spreadsheet(sheetId);
    // get worksheet by its title
    var sheet = ss.worksheetByTitle('Member Sheet');
    var firstNames = await sheet.values.column(1);
    var lastNames = await sheet.values.column(2);
    var tierValues = await sheet.values.column(3);

    var fIndex = firstNames.indexOf(_firstName.trim());
    //whether first name exists
    if (fIndex != -1) {
      //checks whether last name given matches last name in database
      if (_lastName.trim() == lastNames.elementAt(fIndex)) {
        isNameValid = true;
        //check whether user may be an admin tier
        if (tierValues.elementAt(fIndex).contains("Admin")) {
          _tier = tierValues.elementAt(fIndex);
          Global.tier = _tier;
        }
        //truly authenticate the user to firebase
        await authenticateUser()
            .then((_) /* call back for creating a users document*/ {
          setState(() => _isTryingToRegister = false);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen())); //go to profile screen

          //catching invalid email error
        }).catchError((error) {
          setState(() => _isTryingToRegister = false);

          //if email already exists throw an error popup
          if (error.toString().contains("ALREADY")) {
            showDialog(
                context: context,
                builder: (context) {
                  return SingleActionPopup(
                      "Email is already in use", "ERROR!", Colors.red);
                });
          }

          //catch a network timed out error
          if (error.toString().contains("NETWORK")) {
            showDialog(
                context: context,
                builder: (context) {
                  return ErrorPopup(
                      "Network timed out, please check your wifi connection",
                      () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isTryingToRegister = true;
                    });
                    executeRegistration();
                  });
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  print(error);
                  return ErrorPopup(
                      "Oof. Something went wrong during registration.", () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isTryingToRegister = true;
                    });
                    executeRegistration();
                  });
                });
          }
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SingleActionPopup(
                "Enter your first and last name correctly.",
                "User not Matched",
                Colors.red);
          });
      setState(() => _isTryingToRegister = false);
    }
  }

  //handles registration of user
  void tryToRegister() async {
    //checking to make sure multiple attempts at registering doesn't occur
    if (!_isTryingToRegister) {
      setState(() => _isTryingToRegister = true);

      if (_registrationFormKey.currentState
          .validate()) /*check whether form is valid */ {
        executeRegistration();
        // Connectivity().checkConnectivity().then(
        //     (connectionState) /* check whether connection is established */ {
        //   if (connectionState == ConnectivityResult.none) {
        //     throw Exception("Phone is not connected to wifi");
        //   } else {
        //     executeRegistration();
        //   }
        // }).catchError((connectionError) {
        //   setState(() => _isTryingToRegister = false);

        //   //show error on UI
        //   if (connectionError.toString().contains("wifi")) {
        //     showDialog(
        //         context: context,
        //         builder: (context) {
        //           return ErrorPopup("Phone is not connected to wifi", () {
        //             Navigator.of(context).pop();
        //             tryToRegister();
        //           });
        //         });
        //   }
        // });
      } else {
        setState(() => _isTryingToRegister = false);
      }
    }
  }

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
                              _email = val;
                            });

                            //validate email
                            bool dotIsNotIn = _email.indexOf(".") == -1;
                            bool atIsNotIn = _email.indexOf("@") == -1;

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
                              onPressed: () => tryToRegister(),
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
