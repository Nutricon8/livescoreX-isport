import 'package:flutter/material.dart';
import 'package:live_score_ke/utils/theme_provider.dart';
import 'package:live_score_ke/views/main/home/league_details_screen.dart';
import 'package:live_score_ke/views/main/home/match_details_screen.dart';
import 'package:live_score_ke/views/main/profile_screen.dart';
import 'package:live_score_ke/views/main/settings_screen.dart';
import 'package:live_score_ke/views/main/bottom_nav.dart';
import 'package:live_score_ke/views/onboarding/onboarding_one.dart';
import 'package:live_score_ke/views/onboarding/onboarding_two.dart';
import 'package:live_score_ke/views/onboarding/onboarding_three.dart';
import 'package:live_score_ke/views/onboarding/onboarding_four.dart';
import 'package:live_score_ke/views/onboarding/sign_in.dart';
import 'package:live_score_ke/views/onboarding/sign_up.dart';
import 'package:live_score_ke/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeMode = await ThemeProvider.getThemeMode();
  runApp(MyApp(themeMode: themeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode themeMode;
  const MyApp({Key? key, required this.themeMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  Future<void> toggleTheme() async {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
    await ThemeProvider.setThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Livescore App',
      themeMode: _themeMode,

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: lightColorScheme.surface,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
            foregroundColor: lightColorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 48),
            //textStyle: TextStyle(color: lightColorScheme.surface, fontSize: 16),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: lightColorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: lightColorScheme.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: lightColorScheme.onSurface),
          filled: true,
          fillColor: lightColorScheme.onSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: lightColorScheme.surface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: lightColorScheme.onSurface),
          ),
        ),

        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: lightColorScheme.onSurface,
          ),
          bodyLarge: TextStyle(fontSize: 18, color: lightColorScheme.onSurface),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: lightColorScheme.onSurface,
          ),
          bodySmall: TextStyle(fontSize: 14, color: lightColorScheme.onSurface),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.onSurface,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.surface,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: lightColorScheme.onSurface,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: lightColorScheme.onSurface),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          elevation: 10,
          color: lightColorScheme.surface,
        ),

        cardTheme: CardTheme(
          color: lightColorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: darkColorScheme.onSecondary,
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkColorScheme.surface,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: darkColorScheme.primary,
            foregroundColor: lightColorScheme.surface,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 48),
            textStyle: TextStyle(color: darkColorScheme.surface, fontSize: 16),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: darkColorScheme.primary,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: darkColorScheme.primary),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: darkColorScheme.onSurface),
          filled: true,
          fillColor: darkColorScheme.onSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkColorScheme.surface),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: darkColorScheme.onSurface),
          ),
        ),

        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: darkColorScheme.onSurface,
          ),
          bodyLarge: TextStyle(fontSize: 18, color: darkColorScheme.onSurface),
          bodyMedium: TextStyle(fontSize: 16, color: darkColorScheme.onSurface),
          bodySmall: TextStyle(fontSize: 14, color: darkColorScheme.onSurface),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: darkColorScheme.onSurface,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.surface,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: darkColorScheme.onSurface,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: darkColorScheme.onSurface),
        ),

        cardTheme: CardTheme(
          color: darkColorScheme.onSecondary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: darkColorScheme.onSecondary,
        ),

        bottomAppBarTheme: BottomAppBarTheme(
          elevation: 10,
          color: darkColorScheme.surface,
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      // Define named routes
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingOne(),
        '/two': (context) => OnboardingTwo(),
        '/three': (context) => OnboardingThree(),
        '/four': (context) => OnboardingFour(),
        '/register': (context) => SignUpScreen(),
        '/login': (context) => SignInScreen(),
        '/main': (context) => BottomNavScreen(startIndex: 0),
        '/match': (context) => MatchDetailsScreen(),
        '/league': (context) => LeagueDetailsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(toggleTheme: toggleTheme),
      },
    );
  }
}
