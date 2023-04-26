import 'package:flutter/material.dart';

import 'page_transitions_theme.dart';
import 'color_schemes.g.dart';

final lightThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: lightColorScheme.onPrimary,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: lightColorScheme.onPrimary,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: lightColorScheme.onPrimary,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: lightColorScheme.onPrimary,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: lightColorScheme.background,
    selectedIconTheme: const IconThemeData(color: Colors.black87),
    unselectedIconTheme: const IconThemeData(color: Colors.black54),
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.black54,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      backgroundColor: MaterialStatePropertyAll(lightColorScheme.background),
      side: MaterialStatePropertyAll(
          BorderSide(color: lightColorScheme.secondary)),
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          color: lightColorScheme.onBackground,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
      foregroundColor: MaterialStatePropertyAll(lightColorScheme.onBackground),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: lightColorScheme.onBackground,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: lightColorScheme.onBackground),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: lightColorScheme.tertiary),
    ),
    filled: true,
    fillColor: lightColorScheme.shadow,
    hintStyle: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),
  pageTransitionsTheme: pageTransitionsTheme,
);

//

final darkThemeData = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
  textTheme: TextTheme(
    titleLarge: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    labelLarge: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
    titleSmall: TextStyle(
      color: darkColorScheme.onPrimary,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      color: darkColorScheme.onPrimary,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      color: darkColorScheme.onPrimary,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    labelSmall: TextStyle(
      color: darkColorScheme.onPrimary,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkColorScheme.background,
    selectedIconTheme: const IconThemeData(color: Colors.black87),
    unselectedIconTheme: const IconThemeData(color: Colors.black54),
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.black54,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    textStyle: MaterialStatePropertyAll(TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    )),
    backgroundColor: MaterialStatePropertyAll(darkColorScheme.background),
    side:
        MaterialStatePropertyAll(BorderSide(color: darkColorScheme.secondary)),
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  )),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 19,
      fontWeight: FontWeight.normal,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: darkColorScheme.onBackground),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: darkColorScheme.tertiary),
    ),
    filled: true,
    fillColor: darkColorScheme.shadow,
    hintStyle: TextStyle(
      color: darkColorScheme.onBackground,
      fontSize: 15,
      fontWeight: FontWeight.normal,
    ),
  ),
  pageTransitionsTheme: pageTransitionsTheme,
);
