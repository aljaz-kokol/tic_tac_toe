import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';

class GamePosition {
  final int x;
  final int y;
  late bool _disabled;
  GamePlayer? _player;

  GamePosition(
    this.x,
    this.y, {
    GamePlayer? player,
    bool disabled = false,
  }) {
    _player = player;
    _disabled = disabled;
  }

  GamePosition.clone(GamePosition gamePosition)
      : this(
          gamePosition.x,
          gamePosition.y,
          player: gamePosition.player,
          disabled: gamePosition._disabled,
        );

  bool get isSet => _player != null || _disabled == true;

  GamePlayer? get player => _player;

  bool get disabled => _disabled;

  set player(GamePlayer? player) {
    if (!isSet) {
      _player = player;
    }
  }

  void disable() {
    _disabled = true;
  }

  @override
  bool operator ==(Object other) {
    if (other is! GamePosition) return false;
    return x == other.x && y == other.y;
  }
}
