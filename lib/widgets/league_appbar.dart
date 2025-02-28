import 'package:flutter/material.dart';

class PremierLeagueAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PremierLeagueAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(160);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Transform.translate(
          offset: Offset(0, -20), // Move up by 10 pixels
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Image.asset(
                        'assets/liverpool.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Premier League',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
