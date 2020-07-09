import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:xcel_fitness_app/screens/main/main_screen.dart';

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
