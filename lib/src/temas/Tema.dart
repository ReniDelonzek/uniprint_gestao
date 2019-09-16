import 'package:flutter/material.dart';

class Tema {
  static ThemeData getTema(BuildContext context) {
    // Find and extend the parent theme using "copyWith". See the next
    // section for more info on `Theme.of`.
    return ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0
        ),
        accentColor: Colors.blue,
        primaryColor: Colors.white);
  }
}
