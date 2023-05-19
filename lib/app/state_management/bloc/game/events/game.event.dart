import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';

import '../../../../game/models/player.game.dart';
import '../../../../game/models/position.game.dart';

abstract class GameEvent {
  const GameEvent();
}

class NewGameEvent extends GameEvent {
  final List<List<GamePosition>> _newGameInitialLayout = [
    [GamePosition(0, 0), GamePosition(0, 1), GamePosition(0, 2)],
    [GamePosition(1, 0), GamePosition(1, 1), GamePosition(1, 2)],
    [GamePosition(2, 0), GamePosition(2, 1), GamePosition(2, 2)],
  ];

  late final GamePlayer human;
  late final GamePlayer computer;
  late final GamePlayer startPlayer;
  final GameDifficulty difficulty;

  NewGameEvent(GameSymbol humanSymbol, {this.difficulty = GameDifficulty.normal}) {
    human = GamePlayer(humanSymbol, PlayerColor.human.color);
    computer = GamePlayer(humanSymbol.oppositeSymbol, PlayerColor.computer.color);
    startPlayer = human;
  }

  NewGameEvent.starWith(GameSymbol humanSymbol, GameSymbol startSymbol, {this.difficulty = GameDifficulty.normal}) {
    human = GamePlayer(humanSymbol, PlayerColor.human.color);
    computer = GamePlayer(humanSymbol.oppositeSymbol, PlayerColor.computer.color);
    if (startSymbol == humanSymbol) {
      startPlayer = human;
    } else {
      startPlayer = computer;
    }
  }
  List<List<GamePosition>> get newGameInitialLayout => _newGameInitialLayout;
}

class SymbolPlacedEvent extends GameEvent {
  final GamePosition _placePosition;
  SymbolPlacedEvent(this._placePosition);
  GamePosition get position => _placePosition;
}

class DifficultyChangeEvent extends GameEvent {
  final GameDifficulty newDifficulty;
  const DifficultyChangeEvent(this.newDifficulty);
}

class ResumeGameEvent extends GameEvent {
  final GameState lastGameState;
  const ResumeGameEvent(this.lastGameState);
}