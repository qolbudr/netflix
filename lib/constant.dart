import "package:flutter/material.dart";

Color primaryColor = const Color(0xffEE1520);
Color bgColor = const Color(0xff191919);
ButtonStyle primaryButton = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
  ),
  backgroundColor: MaterialStateProperty.all(Colors.white),
  surfaceTintColor: MaterialStateProperty.all(Colors.black),
  foregroundColor: MaterialStateProperty.all(Colors.black),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 20))
);

ButtonStyle defaultButton = ButtonStyle(
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
  ),
  backgroundColor: MaterialStateProperty.all(primaryColor),
  foregroundColor: MaterialStateProperty.all(Colors.white)
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

List<String> genre = [
	"Action",
	"Adventure",
	"Animation",
	"Comedy",
	"Crime",
	"Documentary",
	"Drama",
	"Family",
	"Fantasy",
	"History",
	"Horror",
	"Music",
	"Mystery",
	"Romance",
	"Science Fiction",
	"TV Movie",
	"Thriller",
	"War",
	"Western",
	"Action & Adventure",
  "Kids",
  "News",
  "Reality",
  "Sci-Fi & Fantasy",
  "Soap",
  "Talk",
  "War & Politics"
];