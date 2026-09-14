import 'package:flutter/material.dart';
import 'package:livescorex/utils/models/league.dart';

class LeagueAppbar extends StatelessWidget implements PreferredSizeWidget {
  final League league;
  const LeagueAppbar({required this.league, Key? key}) : super(key: key);
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
        preferredSize: const Size.fromHeight(200.0),
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
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Image.network(
                        league.logo ?? '',

                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.sports_soccer,
                            //size: 20,
                          );
                        },
                        loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) return child;
                          return const Center(child: Icon(Icons.sports_soccer));
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      league.name ?? '',
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
