import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  const CustomDrawer({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Stack for Proper Positioning
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 34.0,
                        top: 20,
                        bottom: 20,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32.5,
                            backgroundImage:
                                user?.photoURL != null
                                    ? NetworkImage(user!.photoURL!)
                                    : const AssetImage(
                                          'assets/default_avatar.png',
                                        )
                                        as ImageProvider,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user != null
                                    ? user.displayName ?? 'User'
                                    : 'Guest',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                user != null
                                    ? user.email ?? ''
                                    : 'Not logged in',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Positioned Close Button at Top Right Corner
                    Positioned(
                      right: 24,
                      top: 16,
                      child: Container(
                        width: 34.0,
                        height: 34.0,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(thickness: 1, indent: 31, endIndent: 31),

                // Menu items
                Expanded(
                  child: ListView(
                    children: [
                      _buildDrawerItem(Icons.home, 'Matches', () {
                        Navigator.of(context).pop();
                      }),
                      _buildDrawerItem(Icons.settings, 'Settings', () {
                        Navigator.popAndPushNamed(context, "/settings");
                      }),
                      _buildDrawerItem(Icons.person, 'Profile', () {
                        onItemTapped(3);
                        Navigator.of(context).pop();
                      }),
                      if (user != null)
                        _buildDrawerItem(Icons.logout, 'Log Out', () async {
                          await FirebaseAuth.instance.signOut();
                        })
                      else
                        _buildDrawerItem(Icons.login, 'Log In', () {
                          Navigator.pushNamed(context, "/login");
                        }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
