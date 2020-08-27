import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool darkMode;
  ThemeData themeData;

  ThemeChanger({this.darkMode = false, this.themeData});

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    accentColor: Colors.black,
    cardColor: Color(0xFFF6F6F6),
    textSelectionHandleColor: Colors.black,
    cursorColor: Colors.grey,
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        color: Colors.white),
    fontFamily: 'Wavehaus',
    textTheme: TextTheme(
      headline1: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Colors.black),
      headline2: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black),
      headline3: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black),
      headline4: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black87),
      bodyText1: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey),
      bodyText2: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.grey),
      button: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Colors.white),
    accentColor: Colors.white,
    cardColor: Color(0xFFF6F6F6),
    textSelectionHandleColor: Colors.white,
    cursorColor: Colors.grey,
    backgroundColor: Colors.black87,
    appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        color: Colors.black),
    fontFamily: 'Wavehaus',
    textTheme: TextTheme(
      headline1: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 26,
          color: Colors.white),
      headline2: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white),
      headline3: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white),
      headline4: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black87),
      bodyText1: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey[100]),
      bodyText2: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.grey[100]),
      button: TextStyle(
          fontFamily: 'Wavehaus',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white),
    ),
  );

  getTheme() => (darkMode) ? darkTheme : lightTheme;

  setTheme(bool dark) {
    darkMode = dark;

    notifyListeners();
  }
}
