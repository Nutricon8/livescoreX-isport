import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livescore_x/utils/ads/banner.dart';
import 'package:livescore_x/views/main/home/favorites_screen.dart';
import 'package:livescore_x/views/main/home/home_page.dart';
import 'package:livescore_x/views/main/home/live_page.dart';
import 'package:livescore_x/views/main/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavScreen extends StatefulWidget {
  final int startIndex;
  const BottomNavScreen({super.key, required this.startIndex});

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onItemTapped: _onItemTapped),
      LivePage(onItemTapped: _onItemTapped),
      FavoritesScreen(),
      ProfileScreen(),
    ];
    _loadLastIndex();
  }

  _loadLastIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastIndex = prefs.getInt('lastIndex') ?? 0;
    setState(() {
      _selectedIndex = lastIndex;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents the default pop behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool exitApp = await showExitConfirmationDialog(context);
          if (exitApp) {
            if (Platform.isAndroid) {
              SystemNavigator.pop(); // Exit on Android
            } else if (Platform.isIOS) {
              exit(0); // Force exit on iOS (Not recommended)
            }
          }
        }
      },
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
                child: child,
              ),
            );
          },
          child: _pages[_selectedIndex],
        ),

        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BannerAdWidget(),
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Material(
                elevation: 10, // Elevation for shadow depth
                shadowColor: Theme.of(context).colorScheme.onSurface,
                //borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart),
                      label: 'Live',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.star_rounded),
                      label: 'Favourite',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Function to show exit confirmation dialog
Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text("Exit App"),
              content: Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Exit"),
                ),
              ],
            ),
      ) ??
      false;
}
