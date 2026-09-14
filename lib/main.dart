  import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart'; // Required for kIsWeb

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:livescorex/firebase_options.dart';
import 'package:livescorex/utils/ads/app_open.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/league.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/team.dart';
import 'package:livescorex/utils/notification_manager.dart';
import 'package:livescorex/utils/theme_provider.dart';
import 'package:livescorex/views/main/bottom_nav.dart';
import 'package:livescorex/views/main/home/live_match_details.dart';
import 'package:livescorex/views/main/settings_screen.dart';
import 'package:livescorex/views/onboarding/onboarding_four.dart';
import 'package:livescorex/views/onboarding/onboarding_one.dart';
import 'package:livescorex/views/onboarding/onboarding_three.dart';
import 'package:livescorex/views/onboarding/sign_in_screen.dart';
import 'package:livescorex/views/onboarding/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String taskKey = "fetch_shared_prefs_task";
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool isServiceRunning = false; // Flag to track if the service is running

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Only initialize ads if the app is NOT running on the Web
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Request permission from the user
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  //await initializeBackgroundService();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: AppInitializer(),
    ),
  );
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: "notifications_channel",
      initialNotificationTitle: "Match Updates Running",
      initialNotificationContent: "Fetching match updates in background",
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground, // Updated function reference
    ),
  );

  service.startService();
}

// Fix for iOS onBackground function
Future<bool> onIosBackground(ServiceInstance service) async {
  // This ensures the background task can still run on iOS
  return true;
}

void onStart(ServiceInstance service) async {
  // Use this for background isolate
  DartPluginRegistrant.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;

  if (notificationsEnabled) {
    // 🧠 Set as foreground service (important to keep it alive!)
    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();
      service.setForegroundNotificationInfo(
        title: "Match Updates Running",
        content: "Monitoring live scores in the background",
      );
    }

    // Trigger the task immediately
    service.invoke('checkMatchUpdates');

    // Listen for custom invoke calls
    service.on('checkMatchUpdates').listen((event) async {
      List<Match> liveMatches = await ApiService().getLiveMatches(true);
      await checkMatchUpdates(liveMatches);
    });

    isServiceRunning = true;
    run15SecondTask();

    service.on('stopService').listen((event) {
      isServiceRunning = false;
      service.stopSelf();
    });
  }
}

Future<void> run15SecondTask() async {
  while (isServiceRunning) {
    try {
      List<Match> liveMatches = await ApiService().getLiveMatches(true);
      await checkMatchUpdates(liveMatches);
    } catch (e) {
      return;
    }
    await Future.delayed(Duration(seconds: 10));
  }
}

class MyApp extends StatefulWidget {
  final bool isFirstLaunch;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({required this.isFirstLaunch});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppOpenAdManager.loadAd();

    AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: 'notifications_channel',
        channelName: 'Match Alerts',
        channelDescription: 'Notifications for favorite matches',
        defaultColor: ColorScheme.of(context).primary,
        ledColor: ColorScheme.of(context).primary,
        importance: NotificationImportance.Max,
        playSound: false,
      ),
    ]);

    // Setup the listener
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: (receivedAction) async {
        // Handle navigation based on notification tap
        if (receivedAction.buttonKeyPressed == 'open_app') {
          // Navigate to the main app screen
        } else if (receivedAction.buttonKeyPressed == 'view_match') {
          String? matchJson = receivedAction.payload?['match'];

          if (matchJson != null) {
            Map<String, dynamic> matchMap = jsonDecode(
              matchJson,
            ); // Convert JSON string to Map

            // Manually reconstruct the Match object
            /*Match match = Match(
              matchId: matchMap['matchId'],
              league: League(
                id: matchMap['league']['id'],
                name: matchMap['league']['name'],
                image: matchMap['league']['image'],
                country: matchMap['league']['country'],
                countryFlag: matchMap['league']['countryFlag'],
              ),
              id: matchMap['id'],
              home: Team(
                id: matchMap['home']['id'],
                name: matchMap['home']['name'],
                image: matchMap['home']['image'],
              ),
              away: Team(
                id: matchMap['away']['id'],
                name: matchMap['away']['name'],
                image: matchMap['away']['image'],
              ),
              homeScore: matchMap['homeScore'],
              awayScore: matchMap['awayScore'],
              date: matchMap['date'],
              elapsed: matchMap['elapsed'],
              short: matchMap['short'],
              halftimeScore: matchMap['halftimeScore'],
              extra: matchMap['extra'], // Include extra field
            );

            // Use a global navigator key to access the context
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (context) => LiveMatchDetails(match: match),
              ),
            );*/
          }
        }
      },
      onNotificationCreatedMethod: (receivedNotification) async {},
      onNotificationDisplayedMethod: (receivedNotification) async {},
      onDismissActionReceivedMethod: (receivedAction) async {},
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is active again
      AppOpenAdManager.showAdIfAvailable(); // Show the ad when returning
    } else if (state == AppLifecycleState.paused) {
      // App moved to the background
    } else if (state == AppLifecycleState.detached) {
      // App is terminating
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LivescoreX',
      themeMode:
          Provider.of<ThemeProvider>(context).isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
      navigatorKey: MyApp.navigatorKey,
      // 👇 Apply SafeArea globally using the builder
      builder: (context, child) {
        return SafeArea(child: child ?? const SizedBox.shrink());
      },
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
              borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: lightColorScheme.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: lightColorScheme.onSurface,
          ),
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
          iconTheme: IconThemeData(color: lightColorScheme.onSurface, size: 24),
        ),

        cardTheme: CardThemeData(
          color: lightColorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: lightColorScheme.onSecondary,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: lightColorScheme.surface,
          selectedItemColor: lightColorScheme.primary,
          unselectedItemColor: lightColorScheme.onSurface,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            //TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
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
              borderRadius: BorderRadius.circular(10),
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
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 48),
            side: BorderSide(color: darkColorScheme.primary),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: darkColorScheme.onSurface,
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

        cardTheme: CardThemeData(
          color: darkColorScheme.onSecondary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          shadowColor: darkColorScheme.onSecondary,
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: darkColorScheme.surface,
          selectedItemColor: darkColorScheme.primary,
          unselectedItemColor: darkColorScheme.onSurface,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.white, // Background color of the sheet
          elevation: 8.0, // Shadow effect
          modalBackgroundColor:
              Colors.grey[200], // Background color for modal bottom sheets
          modalElevation: 10.0, // Elevation for modal sheets
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ), // Rounded corners
          ),
          clipBehavior: Clip.antiAlias, // Ensures smooth clipping
          shadowColor: Colors.black54, // Shadow color
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            //TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      initialRoute:
          widget.isFirstLaunch ? '/' : '/main', // Dynamic initial route

      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            page = OnboardingOne();
            break;
          case '/three':
            page = OnboardingThree();
            break;
          case '/four':
            page = OnboardingFour();
            break;
          case '/register':
            page = SignUpScreen();
            break;
          case '/login':
            page = SignInScreen();
            break;
          case '/main':
            page = BottomNavScreen(startIndex: 0);
            break;
          case '/settings':
            page = SettingsScreen();
            break;
          case '/match-details':
            final match = settings.arguments as Match;
            page = LiveMatchDetails(match: match);
            break;
          default:
            page = OnboardingOne();
        }

        return MaterialPageRoute(builder: (context) => page);
      },
    );
  }
}

class AppInitializer extends StatelessWidget {
  Future<bool> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (firstLaunch) {
      await prefs.setBool('firstLaunch', false);
    }
    return firstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstLaunch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return MyApp(isFirstLaunch: snapshot.data!);
      },
    );
  }
}
