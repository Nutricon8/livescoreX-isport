import 'package:flutter/material.dart';
import 'package:pulsescore/widgets/custom_filled_button.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
          child: Text(
            '1 of 2',
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
          ),
        ),
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

            Padding(
              padding: EdgeInsets.only(
                bottom: 46,
                top: 9,
                left: 9.0,
                right: 9.0,
              ),
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
