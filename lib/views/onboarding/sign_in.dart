import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:live_score_ke/widgets/custom_filled_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  Future<void> _handleGoogleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Welcome! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: null,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: null,
              ),
            ),
            const SizedBox(height: 30),
            TextField(decoration: InputDecoration(labelText: 'Email address')),
            const SizedBox(height: 20),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: null),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomFilledButton(
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, "/four");
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(child: Divider(color: null)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('Or with', style: TextStyle(color: null)),
                ),
                Expanded(child: Divider(color: null)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: SignInButton(
                Buttons.google,
                onPressed: _handleGoogleSignIn,
                text: 'Sign in with Google',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.onBackground, // Use theme text color
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context)
                                .colorScheme
                                .primary, // Use primary color from theme
                        decoration: TextDecoration.underline,
                        decorationColor: Theme.of(context).colorScheme.primary,
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, "/register");
                            },
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
