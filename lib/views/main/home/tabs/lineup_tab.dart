import 'package:flutter/material.dart';
import 'package:livescorex/utils/api_service.dart';
import 'package:livescorex/utils/colors.dart';
import 'package:livescorex/utils/models/match.dart';
import 'package:livescorex/utils/models/player.dart';
import 'package:livescorex/widgets/custom_image.dart';

class LineupTab extends StatefulWidget {
  final Match match;

  const LineupTab({super.key, required this.match});

  @override
  _LineupTabState createState() => _LineupTabState();
}

class _LineupTabState extends State<LineupTab> {
  late Future<List<Player>> _lineupFuture;

  @override
  void initState() {
    super.initState();
    _lineupFuture = ApiService().getLineups(widget.match.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Player>>(
        future: _lineupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("An error occurred while fetching lineup data"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No lineup data available for this match"),
            );
          }
          List<Player> players = snapshot.data!;
          return _buildField(players);
        },
      ),
    );
  }

  Widget _buildField(List<Player> players) {
    List<Player> homePlayers =
        players
            .where((player) => player.team.id == widget.match.home.id)
            .toList();
    List<Player> awayPlayers =
        players
            .where((player) => player.team.id == widget.match.away.id)
            .toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 676,
            decoration: BoxDecoration(color: greenColor),
            child: Stack(
              children: [
                _buildPitchLines(),
                ...players
                    .map((player) => _buildPlayer(context, player))
                    .toList(),
              ],
            ),
          ),
          SizedBox(height: 10),
          _buildLineup(homePlayers, awayPlayers, widget.match),
        ],
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(child: CustomPaint(painter: PitchPainter()));
  }

  Widget _buildPlayer(BuildContext context, Player player) {
    if (player.grid != Offset.zero) {
      return Positioned(
        left: player.grid.dx * MediaQuery.of(context).size.width - 20,
        top: player.grid.dy * 676 - 20,
        child: Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    player.team.id == widget.match.home.id
                        ? redColor
                        : blueColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                player.shirtNumber.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
            ),
            Text(
              player.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(); // If player.grid is Offset.zero, return an empty widget
    }
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    // Full pitch
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 676), paint);

    // Center Line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    // Penalty Boxes & Goals (Fixed size)
    _drawPenaltyArea(canvas, size, paint, top: true);
    _drawPenaltyArea(canvas, size, paint, top: false);
  }

  void _drawPenaltyArea(
    Canvas canvas,
    Size size,
    Paint paint, {
    required bool top,
  }) {
    double y = top ? -20 : size.height - 80;
    double ySmall = top ? -40 : size.height - 40;
    double yArc = top ? 20 : size.height - 60;

    // Larger penalty box
    canvas.drawRect(Rect.fromLTWH(50, y, size.width - 100, 100), paint);
    // Larger inner penalty box
    canvas.drawRect(Rect.fromLTWH(130, ySmall, size.width - 260, 80), paint);
    // Penalty arc
    canvas.drawOval(Rect.fromLTWH(size.width / 2 - 30, yArc, 60, 40), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//lineups list:

Widget _buildLineup(
  List<Player> homePlayers,
  List<Player> awayPlayers,
  Match match,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(
                  imageString: match.home.image,
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    match.home.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // Home Team Starting 11
            _buildTeamSection("Starting 11", homePlayers, isSubstitute: false),
            // Home Team Substitutes
            _buildTeamSection("Substitutes", homePlayers, isSubstitute: true),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(
                  imageString: match.away.image,
                  width: 40,
                  height: 40,
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    match.away.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            // Away Team Starting 11
            _buildTeamSection("Starting 11", awayPlayers, isSubstitute: false),
            // Away Team Substitutes
            _buildTeamSection("Substitutes", awayPlayers, isSubstitute: true),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTeamSection(
  String title,
  List<Player> players, {
  bool isSubstitute = false,
}) {
  List<Player> filteredPlayers =
      players
          .where(
            (player) =>
                isSubstitute
                    ? player.grid == Offset.zero
                    : player.grid != Offset.zero,
          )
          .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      ...filteredPlayers.map((player) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${player.shirtNumber}. ${player.name}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    ],
  );
}
