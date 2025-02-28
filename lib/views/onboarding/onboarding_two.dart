import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/three");
                  },
                  child: Text('Skip', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 80),
              Text(
                'Welcome to LivescoreKe',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your gateway to live sports, real-time updates, and unforgettable moments.\nLet’s get started',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 40),
              AuthButton(
                icon: FontAwesomeIcons.google,
                text: 'Continue with Google',
                onPressed: () {
                  Navigator.pushNamed(context, "/three");
                },
              ),
              const SizedBox(height: 16),
              AuthButton(
                icon: FontAwesomeIcons.envelope,
                text: 'Continue with Email',
                onPressed: () {
                  Navigator.pushNamed(context, "/login");
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text.rich(
                  TextSpan(
                    text:
                        "By creating an account or signing in you agree to our ",
                    style: GoogleFonts.inter(fontSize: 12),
                    children: [
                      TextSpan(
                        text: "terms and conditions",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
