import 'package:flutter/material.dart';
import 'package:xcel_fitness_app/screens/main/main_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _desiresAutoLogin = false;
  bool _isLogginIn = false;
  bool isAdmin = false;

  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: _email,
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
        obscureText: false,
        style: style,
        decoration: new InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
        ));
    final passwordField = TextField(
        obscureText: true,
        style: style,
        decoration: new InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide(color: Colors.blue)),
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
        ));

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[600],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => new HomeScreen()));
        },
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
        onPressed: () {},
        child: Text("Sign Up",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.red[600], fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
                          padding: EdgeInsets.only(top: 15.0, right: 30.0,left: 30.0),
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
                          padding: EdgeInsets.only(top: 15.0, right: 30.0,left: 30.0),
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
    );
  }
}
