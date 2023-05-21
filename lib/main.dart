import 'package:flutter/material.dart';
import 'package:flutter_responsive_login_ui/SplashScreen.dart';
import 'package:flutter_responsive_login_ui/login_screen.dart';
import 'package:flutter_responsive_login_ui/pallete.dart';
import 'package:flutter_responsive_login_ui/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.backgroundColor,
      ),
      home: const SplashScreen(),
    );
  }
}
