import 'package:flutter/material.dart';
import 'package:xcel_fitness_app/screens/authentication/templates.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  bool _isLoginButtonClicked = false;
  bool _isRegisterButtonClicked = false;

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;
  bool isAdmin = false;

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);

  void createNewLoginTemplate() {
    setState(() {
      _isLoginButtonClicked = true;
      _isRegisterButtonClicked = false;
    });
  }

  void createNewRegisterTemplate() {
    setState(() {
      _isRegisterButtonClicked = true;
      _isLoginButtonClicked = false;
    });
  }

  void createNewForgotPasswordTemplate() {
    setState(() {
      _isLoginButtonClicked = false;
      _isRegisterButtonClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[600],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewLoginTemplate,
        child: Text("Sign In",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: createNewRegisterTemplate,
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.red[600], fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Center(
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(30.0),
                                child: SizedBox(
                                  width: 300.0,
                                  child: Image(
                                    image: AssetImage('assets/images/XF.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(flex: 1),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, right: 30.0, left: 30.0),
                              child: SizedBox(
                                child: loginButton,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Forgot login details? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 2.0,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Reset Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      height: 2.0,
                                      fontSize: 15.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0, right: 30.0, left: 30.0),
                              child: SizedBox(
                                child: signupButton,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              )),
            ),
          ),
          if (_isLoginButtonClicked)
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
                    _isLoginButtonClicked = false;
                  });
                },
              ),
              Container(
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      child: Container(
                        child: new LoginTemplate(),
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
          if (_isRegisterButtonClicked)
            Stack(children: <Widget>[
              GestureDetector(
                child: Container(color: Colors.black45),
                onTap: () {
                  setState(() {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _isRegisterButtonClicked = false;
                  });
                },
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                    child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                    child: new RegisterTemplate(),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                  ),
                )),
              )
            ]),
        ],
      ),
    );
  }
}
