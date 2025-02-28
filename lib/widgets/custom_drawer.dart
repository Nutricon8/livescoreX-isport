import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  CustomDrawer({required this.onItemTapped});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 0, top: 40),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Davies Tonui',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Tonui@gmail.com', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
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
          _buildDrawerItem(Icons.logout, 'Log Out', () {
            Navigator.of(context).pop();
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
