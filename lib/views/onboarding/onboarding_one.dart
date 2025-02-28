import 'package:flutter/material.dart';
import 'package:live_score_ke/widgets/custom_filled_button.dart';
import 'package:live_score_ke/widgets/custom_outlined_button.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/three");
            },
            child: Text("Skip", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: const [
                  Text(
                    'Welcome to LiveScoreKe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your gateway to live sports, real-time updates, and unforgettable moments. Let’s get started',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomFilledButton(
                    text: "Sign In",
                    onPressed: () {
                      Navigator.pushNamed(context, "/two");
                    },
                  ),
                  SizedBox(height: 16),
                  CustomOutlinedButton(
                    text: 'Create account',
                    onPressed: () {
                      Navigator.pushNamed(context, "/three");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
