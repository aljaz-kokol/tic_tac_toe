import 'dart:ui';

import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';

class GamePlayer {
  final GameSymbol symbol;
  Color color;

  GamePlayer(this.symbol, this.color);
  GamePlayer.copyWithColor(GamePlayer player, Color color): this(player.symbol, color);

  @override
  bool operator ==(Object other) {
    if (other is! GamePlayer) return false;
    return symbol == other.symbol;
  }

  @override
  int get hashCode => symbol.hashCode;

}
