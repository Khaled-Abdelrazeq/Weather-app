import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'GUI/HomePage.dart' as HomePage;

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather app",
    home: //MyHome(),
    HomePage.HomePage(),
  )
);
