import 'package:flutter/material.dart';

// Define color constants
const Color lightGreenColor = Color(0xFF1F9C20);
const Color redColor = Color(0xFFD90D2D);
const Color yellowColor = Color.fromARGB(255, 245, 223, 22);
const Color greenColor = Color(0xFF46A56C);
const Color blueColor = Color(0xFF0437F2);

// Light Theme Colors
const Color kLightBackground = Color(0xFFFFFFFF);
const Color kLightPrimary = Color(0xFFC94038);
const Color kLightAccent = Color(0xFFFFC107);
const Color kLightSurface = Color(0xFFF5F5F5);
const Color kLightText = Color(0xFF18181B);

// Dark Theme Colors
const Color kDarkBackground = Color(0xFF121212);
const Color kDarkPrimary = Color(0xFFC94038);
const Color kDarkAccent = Color(0xFFC94038);
const Color kDarkSurface = Color(0xFF1C1B20);
const Color kDarkText = Colors.white;
const Color white6Percent = Color(0x0FFFFFFF);

// Define Light Theme Color Scheme
final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: kLightPrimary,
  secondary: kLightAccent,
  surface: kLightSurface,
  onPrimary: Colors.white,
  onSecondary: kLightBackground,
  onSurface: kLightText,
  error: Colors.red,
  onError: Colors.white,
);

// Define Dark Theme Color Scheme
final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: kDarkPrimary,
  secondary: kDarkAccent,
  surface: kDarkSurface,
  onPrimary: Colors.white,
  onSecondary: white6Percent,
  onSurface: kDarkText,
  error: Colors.redAccent,
  onError: Colors.white,
);
