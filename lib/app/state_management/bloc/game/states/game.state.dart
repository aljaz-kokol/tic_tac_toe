import 'package:ai_2023_02_28_minmax_alphabeta/app/game/helpers/game.helper.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/position.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';


class GameState {
  final int matchId;
  final GamePlayer? human;
  final GamePlayer? computer;
  final GamePlayer? startPlayer;
  final GamePlayer? currentPlayer;
  final List<List<GamePosition>> _layout;
  GameDifficulty difficulty; // public because setter and getter do not require extra logic

  GameState(
    this.matchId,
    this.human,
    this.computer,
    this.startPlayer,
    this.currentPlayer,
    this._layout,
    this.difficulty,
  );

  GameState.nextPlayerOf(GameState state)
      : this(
          state.matchId,
          state.human,
          state.computer,
          state.startPlayer,
          state.nextPlayer,
          state.layout,
          state.difficulty,
        );

  GameState.copyOf(GameState state)
      : this(
          state.matchId,
          state.human,
          state.computer,
          state.startPlayer,
          state.currentPlayer,
          state.layout,
          state.difficulty,
        );

  List<List<GamePosition>> get layout => _layout.map((list) => list.map((pos) => GamePosition.clone(pos)).toList()).toList();

  List<GamePosition> get positionsList => _layout.expand((pos) => pos).toList();

  GamePlayer? get nextPlayer => currentPlayer == human ? computer : human;

  /// Returns a list with set board positions
  List<GamePosition> get setPositions => positionsList.where((pos) => pos.isSet).toList();

  /// Returns a list with free board positions
  List<GamePosition> get freePositions => positionsList.where((pos) => !pos.isSet).toList();

  /// Check's if all board positions are set
  bool get boardIsFull => freePositions.isEmpty;

  /// If given [position] is valid it will set it with [newPlayer]
  void setAtPosition(GamePosition position, GamePlayer? newPlayer) {
    if (_isValidPosition(position)) {
      _layout[position.x][position.y].player = newPlayer;
    }
  }

  /// Disable [position] so it can't be interacted with
  void disableAt(GamePosition position) {
    if (_isValidPosition(position)) {
      _layout[position.x][position.y].disable();
    }
  }

  /// Checks if position exists on board (x and y bounds)
  bool _isValidPosition(GamePosition position) {
    return  _layout.asMap().containsKey(position.x) &&
        _layout[position.x].asMap().containsKey(position.y);
  }

  /// Returns a list of winning positions
  /// [ ] means there are no wining positions or it's a tie
  List<GamePosition> get winningPositions => GameHelper.getWinningPositions(_layout);

  bool get isFinalState => boardIsFull || winningPositions.isNotEmpty;

  GamePlayer oppositePlayer(GamePlayer player) {
    if (player == human) return computer!;
    return human!;
  }

  GamePosition? get(int x, int y ){
    if (_isValidPosition(GamePosition(x, y))) {
      return GamePosition.clone(_layout[x][y]);
    }
    return null;
  }
}

class GameOverState extends GameState {
  final GamePlayer? _winner;

  GameOverState.copyOf(
    GameState state,
    this._winner,
  ) : super.nextPlayerOf(state);

  GamePlayer? get winner => _winner;
}

class GameInitializingState extends GameState {
  GameInitializingState() : super(-1, null, null, null, null, [], GameDifficulty.normal);
}