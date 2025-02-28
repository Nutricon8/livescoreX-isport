import 'package:flutter/material.dart';
import 'package:live_score_ke/widgets/custom_drawer.dart';

class LiveScreen extends StatelessWidget {
  //const LiveScreen({Key? key}) : super(key: key);
  final Function(int) onItemTapped;
  LiveScreen({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_outlined),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              onItemTapped(3);
            },
            icon: const Icon(Icons.person_pin),
          ),
        ],
      ),

      drawer: CustomDrawer(onItemTapped: onItemTapped),
      body: ListView.builder(
        itemCount: 3, // Dynamically render items
        itemBuilder: (context, index) => _buildMatchesTab(context),
      ),
    );
  }
}

Widget _buildMatchesTab(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      children: [
        ListTile(
          leading: Image.asset("assets/liverpool.png", height: 24, width: 24),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 4),
              const Text(
                'England',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
              Image.asset("assets/liverpool.png", height: 16, width: 16),
              const SizedBox(width: 4),
              const Text(
                'Premier League',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => Navigator.pushNamed(context, "/league"),
            icon: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
        ListView.builder(
          shrinkWrap: true, // Avoid infinite height
          physics:
              const NeverScrollableScrollPhysics(), // Prevents nested scrolling
          itemCount: 2,
          itemBuilder: (context, index) {
            return _buildMatchItem(
              context,
              '20:00',
              'Liverpool',
              index == 0 ? 'Aston Villa' : 'Arsenal',
              '1.34',
              index == 0 ? '2.35' : '1.18',
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildMatchItem(
  BuildContext context,
  String time,
  String team1,
  String team2,
  String odd1,
  String odd2,
) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 2.0),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/match");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => MatchDetailsScreen()));
      },
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        title: Text(
          team1,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
        subtitle: Text(
          team2,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.star)),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(odd1), const SizedBox(height: 4), Text(odd2)],
            ),
          ],
        ),
      ),
    ),
  );
}
