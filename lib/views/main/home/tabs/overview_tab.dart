import 'package:flutter/material.dart';
import 'package:live_score_ke/utils/colors.dart';

class OverviewTab extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {
      'name': 'M. Lamb',
      'number': 32,
      'team': 'red',
      'position': Offset(0.5, 0.07),
    },
    {
      'name': 'K. West',
      'number': 6,
      'team': 'red',
      'position': Offset(0.1, 0.2),
    },
    {
      'name': 'M. Keynote',
      'number': 18,
      'team': 'red',
      'position': Offset(0.4, 0.2),
      'card': 'yellow',
    },
    {
      'name': 'A. Smith',
      'number': 3,
      'team': 'red',
      'position': Offset(0.6, 0.2),
    },
    {
      'name': 'K. Kimway',
      'number': 6,
      'team': 'red',
      'position': Offset(0.9, 0.2),
    },
    {
      'name': 'D. Partey',
      'number': 8,
      'team': 'red',
      'position': Offset(0.2, 0.4),
    },
    {
      'name': 'G. Marten',
      'number': 9,
      'team': 'red',
      'position': Offset(0.8, 0.4),
    },
    {
      'name': 'M. Keynote',
      'number': 8,
      'team': 'red',
      'position': Offset(0.4, 0.4),
    },
    {
      'name': 'A. Smith',
      'number': 35,
      'team': 'red',
      'position': Offset(0.6, 0.4),
    },
    {
      'name': 'A. Heard',
      'number': 10,
      'team': 'red',
      'position': Offset(0.5, 0.45),
    },

    {
      'name': 'M. Lamb',
      'number': 32,
      'team': 'blue',
      'position': Offset(0.5, 0.93),
    },
    {
      'name': 'K. West',
      'number': 7,
      'team': 'blue',
      'position': Offset(0.1, 0.8),
    },
    {
      'name': 'A. Smith',
      'number': 8,
      'team': 'blue',
      'position': Offset(0.4, 0.8),
    },
    {
      'name': 'M. Keynote',
      'number': 35,
      'team': 'blue',
      'position': Offset(0.6, 0.8),
    },
    {
      'name': 'K. Kimway',
      'number': 6,
      'team': 'blue',
      'position': Offset(0.9, 0.8),
    },
    {
      'name': 'D. Partey',
      'number': 8,
      'team': 'blue',
      'position': Offset(0.2, 0.6),
    },
    {
      'name': 'G. Marten',
      'number': 9,
      'team': 'blue',
      'position': Offset(0.8, 0.6),
    },
    {
      'name': 'M. Keynote',
      'number': 8,
      'team': 'blue',
      'position': Offset(0.4, 0.6),
    },
    {
      'name': 'A. Smith',
      'number': 35,
      'team': 'blue',
      'position': Offset(0.6, 0.6),
    },
    {
      'name': 'A. Heard',
      'number': 10,
      'team': 'blue',
      'position': Offset(0.5, 0.55),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1.5,
          decoration: BoxDecoration(
            color: greenColor,
            //border: Border.all(color: Theme.of(context).colorScheme.surface, width: 4),
          ),
          child: Stack(
            children: [
              _buildPitchLines(),
              ...players
                  .map((player) => _buildPlayer(context, player))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(child: CustomPaint(painter: PitchPainter()));
  }

  Widget _buildPlayer(BuildContext context, Map<String, dynamic> player) {
    return Positioned(
      left: player['position'].dx * MediaQuery.of(context).size.width - 20,
      top:
          player['position'].dy * MediaQuery.of(context).size.height * 1.5 - 20,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: player['team'] == 'red' ? redColor : blueColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  player['number'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (player['card'] == 'yellow')
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(width: 10, height: 15, color: yellowColor),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(player['name'], style: TextStyle(fontSize: 10)),
        ],
      ),
    );
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

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    canvas.drawRect(Rect.fromLTWH(50, 0, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(150, 0, size.width - 300, 50), paint);
    canvas.drawOval(Rect.fromLTWH(size.width / 2 - 50, 80, 100, 30), paint);

    canvas.drawRect(
      Rect.fromLTWH(50, size.height - 100, size.width - 100, 100),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(150, size.height - 50, size.width - 300, 50),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width / 2 - 50, size.height - 110, 100, 30),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


/*import 'package:flutter/material.dart';

class FootballPitchScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {'name': 'M. Lamb', 'number': 32, 'team': 'red', 'position': Offset(0.5, 0.1)},
    {'name': 'K. West', 'number': 6, 'team': 'red', 'position': Offset(0.1, 0.2)},
    {'name': 'M. Keynote', 'number': 18, 'team': 'red', 'position': Offset(0.4, 0.2), 'card': 'yellow'},
    {'name': 'A. Smith', 'number': 3, 'team': 'red', 'position': Offset(0.6, 0.2)},
    {'name': 'K. Kimway', 'number': 6, 'team': 'red', 'position': Offset(0.9, 0.2)},
    {'name': 'D. Partey', 'number': 8, 'team': 'red', 'position': Offset(0.2, 0.4)},
    {'name': 'G. Marten', 'number': 9, 'team': 'red', 'position': Offset(0.8, 0.4)},
    {'name': 'M. Keynote', 'number': 8, 'team': 'red', 'position': Offset(0.4, 0.4)},
    {'name': 'A. Smith', 'number': 35, 'team': 'red', 'position': Offset(0.6, 0.4)},
    {'name': 'A. Heard', 'number': 10, 'team': 'red', 'position': Offset(0.5, 0.45)},

    {'name': 'M. Lamb', 'number': 32, 'team': 'blue', 'position': Offset(0.5, 0.9)},
    {'name': 'K. West', 'number': 7, 'team': 'blue', 'position': Offset(0.1, 0.8)},
    {'name': 'A. Smith', 'number': 8, 'team': 'blue', 'position': Offset(0.4, 0.8)},
    {'name': 'M. Keynote', 'number': 35, 'team': 'blue', 'position': Offset(0.6, 0.8)},
    {'name': 'K. Kimway', 'number': 6, 'team': 'blue', 'position': Offset(0.9, 0.8)},
    {'name': 'D. Partey', 'number': 8, 'team': 'blue', 'position': Offset(0.2, 0.6)},
    {'name': 'G. Marten', 'number': 9, 'team': 'blue', 'position': Offset(0.8, 0.6)},
    {'name': 'M. Keynote', 'number': 8, 'team': 'blue', 'position': Offset(0.4, 0.6)},
    {'name': 'A. Smith', 'number': 35, 'team': 'blue', 'position': Offset(0.6, 0.6)},
    {'name': 'A. Heard', 'number': 10, 'team': 'blue', 'position': Offset(0.5, 0.55)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1.5,
          decoration: BoxDecoration(
            color: Colors.green[800],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Stack(
            children: [
              _buildPitchLines(),
              ...players.map((player) => _buildPlayer(context, player)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PitchPainter(),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, Map<String, dynamic> player) {
    return Positioned(
      left: player['position'].dx * MediaQuery.of(context).size.width - 20,
      top: player['position'].dy * MediaQuery.of(context).size.height * 1.5 - 20,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: player['team'] == 'red' ? Color(0xFFC94038) : Colors.blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  player['number'].toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (player['card'] == 'yellow')
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 15,
                    color: Colors.yellow,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            player['name'],
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    canvas.drawRect(Rect.fromLTWH(50, 0, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(150, 0, size.width - 300, 50), paint);
    canvas.drawOval(Rect.fromLTWH(size.width / 2 - 50, 80, 100, 30), paint);

    canvas.drawRect(Rect.fromLTWH(50, size.height - 100, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(150, size.height - 50, size.width - 300, 50), paint);
    canvas.drawOval(Rect.fromLTWH(size.width / 2 - 50, size.height - 110, 100, 30), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
*/

/*import 'package:flutter/material.dart';

class FootballPitchScreen extends StatelessWidget {
  final List<Map<String, dynamic>> players = [
    {'name': 'M. Lamb', 'number': 32, 'team': 'red', 'position': Offset(0.5, 0.1)},
    {'name': 'K. West', 'number': 6, 'team': 'red', 'position': Offset(0.1, 0.2)},
    {'name': 'M. Keynote', 'number': 18, 'team': 'red', 'position': Offset(0.4, 0.2), 'card': 'yellow'},
    {'name': 'A. Smith', 'number': 3, 'team': 'red', 'position': Offset(0.6, 0.2)},
    {'name': 'K. Kimway', 'number': 6, 'team': 'red', 'position': Offset(0.9, 0.2)},
    {'name': 'D. Partey', 'number': 8, 'team': 'red', 'position': Offset(0.2, 0.35)},
    {'name': 'G. Marten', 'number': 9, 'team': 'red', 'position': Offset(0.8, 0.35)},
    {'name': 'M. Keynote', 'number': 8, 'team': 'red', 'position': Offset(0.4, 0.4)},
    {'name': 'A. Smith', 'number': 35, 'team': 'red', 'position': Offset(0.6, 0.4)},
    {'name': 'A. Heard', 'number': 10, 'team': 'red', 'position': Offset(0.5, 0.5)},

    {'name': 'M. Lamb', 'number': 32, 'team': 'blue', 'position': Offset(0.5, 0.9)},
    {'name': 'K. West', 'number': 7, 'team': 'blue', 'position': Offset(0.1, 0.8)},
    {'name': 'A. Smith', 'number': 8, 'team': 'blue', 'position': Offset(0.4, 0.8)},
    {'name': 'M. Keynote', 'number': 35, 'team': 'blue', 'position': Offset(0.6, 0.8)},
    {'name': 'K. Kimway', 'number': 6, 'team': 'blue', 'position': Offset(0.9, 0.8)},
    {'name': 'D. Partey', 'number': 8, 'team': 'blue', 'position': Offset(0.2, 0.65)},
    {'name': 'G. Marten', 'number': 9, 'team': 'blue', 'position': Offset(0.8, 0.65)},
    {'name': 'M. Keynote', 'number': 8, 'team': 'blue', 'position': Offset(0.4, 0.6)},
    {'name': 'A. Smith', 'number': 35, 'team': 'blue', 'position': Offset(0.6, 0.6)},
    {'name': 'A. Heard', 'number': 10, 'team': 'blue', 'position': Offset(0.5, 0.55)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 1.5,
          decoration: BoxDecoration(
            color: Colors.green[800],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Stack(
            children: [
              _buildPitchLines(),
              ...players.map((player) => _buildPlayer(context, player)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPitchLines() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PitchPainter(),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context, Map<String, dynamic> player) {
    return Positioned(
      left: player['position'].dx * MediaQuery.of(context).size.width - 20,
      top: player['position'].dy * MediaQuery.of(context).size.height * 1.5 - 20,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: player['team'] == 'red' ? Color(0xFFC94038) : Colors.blue,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  player['number'].toString(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (player['card'] == 'yellow')
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 15,
                    color: Colors.yellow,
                  ),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            player['name'],
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 50, paint);

    canvas.drawRect(Rect.fromLTWH(50, 0, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(150, 0, size.width - 300, 50), paint);
    canvas.drawArc(Rect.fromLTWH(size.width / 2 - 50, 70, 100, 60), 0, 3.14, false, paint);

    canvas.drawRect(Rect.fromLTWH(50, size.height - 100, size.width - 100, 100), paint);
    canvas.drawRect(Rect.fromLTWH(150, size.height - 50, size.width - 300, 50), paint);
    canvas.drawArc(Rect.fromLTWH(size.width / 2 - 50, size.height - 130, 100, 60), 3.14, 3.14, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
*/