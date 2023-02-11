import "package:flutter/material.dart";

Color primaryColor = const Color(0xffEE1520);
Color bgColor = const Color(0xff191919);
ButtonStyle primaryButton = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.white),
  surfaceTintColor: MaterialStateProperty.all(Colors.black),
  foregroundColor: MaterialStateProperty.all(Colors.black),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 20))
);

ThemeData themeData = ThemeData(
  fontFamily: "Netflix",
  primaryColor: primaryColor,
  scaffoldBackgroundColor: bgColor,
  colorScheme: const ColorScheme.dark().copyWith(
    primary: primaryColor,
    error: Colors.red,
    onPrimary: primaryColor,
    onSecondary: Colors.white.withOpacity(0.2),
    onSurface: Colors.white,
    onBackground: bgColor,
    onError: Colors.red,
    brightness: Brightness.dark,
    secondary: Colors.white.withOpacity(0.2),
    secondaryContainer: Colors.white.withOpacity(0.2),
    surface: Colors.white,
    background: Colors.white,
  )
);