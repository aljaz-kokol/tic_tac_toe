import 'dart:ui';

import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';

enum GameStatus {
  ongoing("Ongoing"),
  humanWin("You"),
  computerWin("Computer"),
  tie("No-one/Tie");

  final String status;
  const GameStatus(this.status);

  static GameStatus fromStatusName(String statusName) {
    for (GameStatus status in values) {
      if (status.status == statusName) return status;
    }
    return GameStatus.ongoing;
  }

  Color get color {
    if (this == GameStatus.humanWin)  return PlayerColor.human.color;
    if (this == GameStatus.computerWin)  return PlayerColor.computer.color;
    return PlayerColor.unknown.color;
  }
}