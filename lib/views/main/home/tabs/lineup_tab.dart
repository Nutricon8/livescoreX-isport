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
    _lineupFuture = ApiService().getLineups(widget.match.matchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Player>>(
        future: _lineupFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No lineup data available for this match'),
            );
          }
          return _buildField(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildField(List<Player> players) {
    // Players are tagged teamId='home' or 'away' by getLineups.
    final homePlayers = players.where((p) => p.teamId == 'home').toList();
    final awayPlayers = players.where((p) => p.teamId == 'away').toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Pitch visualization — disabled for now (no grid coordinates in
          // the API response), but kept so you can re-enable if needed.
          // Container(
          //   width: double.infinity,
          //   height: 676,
          //   decoration: BoxDecoration(color: greenColor),
          //   child: Stack(
          //     children: [
          //       _buildPitchLines(),
          //       ...players.map((p) => _buildPlayer(context, p)).toList(),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 10),
          _buildLineup(homePlayers, awayPlayers, widget.match),
        ],
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(child: CustomPaint(painter: PitchPainter()));
  }

  Widget _buildPlayer(BuildContext context, Player player) {
    // Disabled — no grid coordinates from the API. Kept for future use.
    return const SizedBox.shrink();
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 676), paint);
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);
    _drawPenaltyArea(canvas, size, paint, top: true);
    _drawPenaltyArea(canvas, size, paint, top: false);
  }

  void _drawPenaltyArea(
      Canvas canvas,
      Size size,
      Paint paint, {
        required bool top,
      }) {
    final y = top ? -20.0 : size.height - 80;
    final ySmall = top ? -40.0 : size.height - 40;
    final yArc = top ? 20.0 : size.height - 60;

    canvas.drawRect(Rect.fromLTWH(50, y, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(130, ySmall, size.width - 260, 80), paint);
    canvas.drawOval(Rect.fromLTWH(size.width / 2 - 30, yArc, 60, 40), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
        // ---- Home column ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImage(
                    imageString: '',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      match.homeName ?? '',
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
              _buildTeamSection('Starting 11', homePlayers, isSubstitute: false),
              _buildTeamSection('Substitutes', homePlayers, isSubstitute: true),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // ---- Away column ----
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomImage(
                    imageString: '',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      match.awayName ?? '',
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
              _buildTeamSection('Starting 11', awayPlayers, isSubstitute: false),
              _buildTeamSection('Substitutes', awayPlayers, isSubstitute: true),
            ],
          ),
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
  // We can't distinguish starters from substitutes based on grid coords
  // (the API doesn't provide them), but getLineups() already puts backups
  // into the list with the same teamId, so all players show under
  // "Starting 11" for now. If you later want to split, tag players during
  // parsing (see `isSubstitute` param in `_appendLineupPlayers`).
  final filtered = players.toList();

  if (filtered.isEmpty) return const SizedBox.shrink();

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
      ...filtered.map((player) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${player.number}. ${player.name}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    ],
  );
}