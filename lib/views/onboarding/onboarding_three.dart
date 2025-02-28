import 'package:flutter/material.dart';
import 'package:live_score_ke/widgets/custom_filled_button.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: Text('1 of 2', style: TextStyle(color: null)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome to\nLivescoreKe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: null,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your gateway to live sports, real-time\nupdates, and unforgettable moments.\nLet’s get started',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: null),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: CustomFilledButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.pushNamed(context, "/four");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
