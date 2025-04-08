import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livescorex/views/main/bottom_nav.dart';
import 'package:livescorex/widgets/bottom_sheet.dart';
import 'package:livescorex/widgets/custom_filled_button.dart';
import 'package:livescorex/widgets/custom_outlined_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () async {
            bool exitApp = await showExitConfirmationDialog(context);
            if (exitApp) {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ),
        ],
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body:
          user == null
              ? _buildSignUpUI(context)
              : _buildProfileUI(context, user),
    );
  }

  /// UI for users who are not logged in
  Widget _buildSignUpUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You Are Not Signed In!',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30),
            CustomFilledButton(
              text: "Sign In",
              onPressed: () {
                Navigator.pushNamed(context, "/login");
              },
            ),
            SizedBox(height: 16),
            CustomOutlinedButton(
              text: 'Sign Up',
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
            ),
          ],
        ),
      ),
    );
  }

  /// UI for logged-in users
  Widget _buildProfileUI(BuildContext context, User user) {
    String displayName =
        user.displayName ?? "No name available"; // ✅ Get Display Name
    String email = user.email ?? "No email available";
    String? photoUrl = user.photoURL;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.5,
                backgroundImage:
                    photoUrl != null
                        ? NetworkImage(photoUrl)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName, // ✅ Display Name
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    email, // ✅ Email from Firebase
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'ACCOUNT',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('E-mail', style: const TextStyle(fontSize: 16)),
                    Text(email, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 11),
            child: Column(
              children: [
                CustomOutlinedButton(
                  text: 'Log Out',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                ),
                TextButton(
                  onPressed: () async {
                    // Show confirmation bottom sheet
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder:
                          (context) => RemoveTeamBottomSheet(
                            onConfirm: () async {
                              await FirebaseAuth.instance.currentUser?.delete();
                              Navigator.pushReplacementNamed(
                                context,
                                "/register",
                              );
                            },
                          ),
                    );
                  },
                  child: Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
