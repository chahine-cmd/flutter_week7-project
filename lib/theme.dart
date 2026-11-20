import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
);

final ThemeData themeData = ThemeData(
  colorScheme: colorScheme,

  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primary,
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(220, 50),
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  textTheme: const TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  ),
);