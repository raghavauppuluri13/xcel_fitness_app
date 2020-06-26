import 'package:flutter/material.dart';
import 'package:xcel_fitness_app/screens/authentication/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xcel Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(title: "Login Screen"),
    );
  }
}