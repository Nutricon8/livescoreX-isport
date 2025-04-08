import 'dart:ui';

import 'package:livescorex/utils/models/team.dart';

class Player {
  final String name;
  final String position;
  final int shirtNumber;
  final Team team;
  final Offset grid;
  Player({
    required this.name, //"name"
    required this.position, //"pos"
    required this.shirtNumber, //"number"
    required this.team, //team.id
    required this.grid,
  });
}

Offset convertGrid(String grid) {
  List<String> parts = grid.split(':');
  if (parts.length != 2) return const Offset(0.5, 0.5);

  int row = int.parse(parts[0]);
  int col = int.parse(parts[1]);

  double x = (col - 1) / 5;
  double y = (row - 1) / 5;

  return Offset(x, y);
}
