import 'package:flutter/material.dart';
import 'package:pulsescore/widgets/custom_filled_button.dart';
import 'package:pulsescore/widgets/custom_outlined_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    _setNotificationPreference();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/three");
              },
              child: Text(
                'Skip',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 2),
            Column(
              spacing: 16,
              children: const [
                Text(
                  'Welcome to PulseScore',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                //SizedBox(height: 8),
                Text(
                  'Your gateway to live sports, real-time updates, and unforgettable moments. \nLet’s get started',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Spacer(flex: 2),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFilledButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                ),
                SizedBox(height: 16),
                CustomOutlinedButton(
                  text: 'Create account',
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  },
                ),
              ],
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

Future<void> _setNotificationPreference() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('notificationsEnabled', true);
}
