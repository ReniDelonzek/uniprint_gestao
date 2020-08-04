import 'package:flutter/material.dart';

class Tema {
  static ThemeData getTema(BuildContext context, {bool darkMode = false}) {
    return ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        appBarTheme: AppBarTheme(
            elevation: 0, color: darkMode ? Colors.black : Colors.white),
        accentColor: getCorPadrao(),
        primaryColor: darkMode ? Colors.black : Colors.white,
        buttonColor: getCorPadrao(),
        scaffoldBackgroundColor: darkMode ? Colors.black : Colors.white,
        buttonTheme: ButtonThemeData(buttonColor: getCorPadrao()),
        inputDecorationTheme: InputDecorationTheme(
            labelStyle:
                TextStyle(color: darkMode ? Colors.white70 : Colors.black87)));
  }
}

getCorPadrao() {
  return Colors.blue;
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
