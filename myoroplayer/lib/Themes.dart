import "package:flutter/material.dart";

ThemeData light = ThemeData(
  colorScheme: ColorScheme(
    brightness:   Brightness.light,
    primary:      Color(0xFFEDE6D6),
    onPrimary:    Color(0xFF181818),
    secondary:    Color(0xFFEDE6D6),
    onSecondary:  Color(0xFF181818),
    background:   Color(0xFFEDE6D6),
    onBackground: Color(0xFF181818),
    surface:      Color(0xFFEDE6D6),
    onSurface:    Color(0xFF181818),
    error:        Colors.red,
    onError:      Colors.white
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      fontFamily: "Ubuntu",
      fontWeight: FontWeight.normal,
      fontSize:   24
    )
  )
);

ThemeData dark = ThemeData(
  colorScheme: ColorScheme(
    brightness:   Brightness.dark,
    primary:      Color(0xFF181818),
    onPrimary:    Color(0xFFEDE6D6),
    secondary:    Color(0xFF181818),
    onSecondary:  Color(0xFFEDE6D6),
    background:   Color(0xFF181818),
    onBackground: Color(0xFFEDE6D6),
    surface:      Color(0xFF181818),
    onSurface:    Color(0xFFEDE6D6),
    error:        Colors.red,
    onError:      Colors.white
  )
);
