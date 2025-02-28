import 'package:flutter/material.dart';
import 'package:live_score_ke/views/main/favorite/favorites_screen.dart';
import 'package:live_score_ke/views/main/home/home_page.dart';
import 'package:live_score_ke/views/main/live/live_screen.dart';
import 'package:live_score_ke/views/main/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavScreen extends StatefulWidget {
  final int startIndex;
  BottomNavScreen({required this.startIndex});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(onItemTapped: _onItemTapped),
      LiveScreen(onItemTapped: _onItemTapped),
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
    return Scaffold(
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
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Live'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourite'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
