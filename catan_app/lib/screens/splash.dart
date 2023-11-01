
import 'package:flutter/material.dart';
import 'main_menu.dart';

class SplashScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Garamond'),
      home: Scaffold(
        body: SafeArea(child: MainMenuScreen()),
      ),
    );
  }

}