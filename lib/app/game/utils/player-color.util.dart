import 'dart:ui';

enum PlayerColor {
  human(Color(0xFF3164F4)),
  computer(Color(0xFFF50057)),
  unknown(Color(0xFF3E3E3E));

  final Color color;
  const PlayerColor(this.color);
}