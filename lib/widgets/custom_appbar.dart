import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
    : preferredSize = const Size.fromHeight(120.0),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Column(
        children: const [
          Text(
            'English Premier League',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Sunday, 3 February 2025 at 21:00',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
        IconButton(icon: const Icon(Icons.share), onPressed: () {}),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.star_border),
                        onPressed: () {},
                      ),
                      SizedBox(width: 4),
                      Column(
                        children: [
                          Image.asset(
                            'assets/liverpool.png',
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(height: 4),
                          Text('Liverpool'),
                        ],
                      ),
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        '21:00',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Today'),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/aston_villa.png',
                            height: 40,
                            width: 40,
                          ),
                          SizedBox(height: 4),
                          Text('Aston Villa'),
                        ],
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.star_border),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
