import 'package:flutter/material.dart';
import 'package:xcel_fitness_app/screens/authentication/authentication_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        title: 'Xcel Fitness App',
        debugShowCheckedModeBanner: false,
        home: AuthScreen(),
        theme: ThemeData(
    // Define the default brightness and colors.
    primaryColor: Colors.red,
    iconTheme: IconThemeData(color: Colors.white),
    accentColor: Colors.black,
    // Define the default font family.
    fontFamily: 'Lato',

));
  }
}
