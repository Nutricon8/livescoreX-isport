import 'package:flutter/material.dart';
import 'package:live_score_ke/utils/bottom_sheet_utils.dart';
import 'package:live_score_ke/utils/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Favorites"),
          centerTitle: true,
          bottom: TabBar(tabs: [Tab(text: 'Matches'), Tab(text: 'My Teams')]),
        ),
        body: TabBarView(
          children: [_buildMatchesTab(context), _buildMyTeamsTab(context)],
        ),
      ),
    );
  }
}

Widget _buildMatchesTab(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
        Expanded(
          // Ensures ListView takes up available space
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildMatchItem(
                context,
                '20:00',
                'Liverpool',
                'Aston Villa',
                '1.34',
                '2.35',
              ),
              _buildMatchItem(
                context,
                '03:30',
                'Liverpool',
                'Arsenal',
                '1.34',
                '1.18',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildMyTeamsTab(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(padding: EdgeInsets.all(8), child: Text('MY TEAMS')),
      ),
      _buildTeamItem(context, 'Liverpool'),
      _buildTeamItem(context, 'Arsenal'),
    ],
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
    margin: EdgeInsets.symmetric(vertical: 4.0),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
    child: ListTile(
      leading: Column(
        children: [
          Text(
            time,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 8.0),
          ),
          Text(
            time,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
          ),
        ],
      ),
      title: Text(
        team1,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
      ),
      subtitle: Text(
        team2,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.0),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min, // Prevents overflow
        children: [
          IconButton(
            onPressed: () {
              showRemoveTeamBottomSheet(context);
            },
            icon: Icon(Icons.star, color: lightGreenColor),
          ),
          SizedBox(width: 8), // Better spacing
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(odd1),
              SizedBox(height: 4), // Use height instead of width in Column
              Text(odd2),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTeamItem(BuildContext context, String teamName) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 4.0),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
    child: ListTile(
      title: Row(
        children: [
          Image.asset("assets/liverpool.png", height: 30, width: 30),
          SizedBox(width: 4),
          Text(teamName, style: TextStyle(fontSize: 16)),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          showRemoveTeamBottomSheet(context);
        },
        icon: Icon(Icons.star, color: lightGreenColor),
      ),
    ),
  );
}
