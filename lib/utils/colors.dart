// lib/utils/colors.dart
import 'package:flutter/material.dart';

// Define color constants
const Color kDarkColor = Color(0xFF18181B);
const Color kPrimaryColor = Color(0xFF1E88E5);
const Color kAccentColor = Color(0xFFFFC107);

const Color primaryColor = Color(0xFFC94038);
const Color whiteColor = Color(0xFFFFFFFF);
const Color lightGreenColor = Color(0xFF1F9C20);
const Color neutralColor = Color(0xFF2F283B);
const Color neutralTwoColor = Color(0xFF746C82); //for switch bar
const Color redColor = Color(0xFFD90D2D);
const Color yellowColor = Color(0xFFF0DC28);
const Color darkGreenColor = Color(0x48AB933D);
const Color greenColor = Color(0xFF46A56C);
const Color blueColor = Color(0xFF007FFF);
const Color grey900 = Color(0xFF18181B);
const Color lightGreyColor = Color(0x7AF1F1F1);

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
const Color kDarkSurface = Color(0xFF1E1E1E);
const Color kDarkText = Colors.white;

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
  onSecondary: Colors.black,
  onSurface: kDarkText,
  error: Colors.redAccent,
  onError: Colors.white,
);