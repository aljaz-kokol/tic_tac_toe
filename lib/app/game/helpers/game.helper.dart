import '../../game/models/player.game.dart';
import '../../game/models/position.game.dart';
import '../../state_management/bloc/game/states/game.state.dart';

abstract class GameHelper {
  static List<GamePosition> getWinningPositions(List<List<GamePosition>> layout) {
    // Check rows
    for (List<GamePosition> boardRow in layout) {
      if (_positionListToPlayerSet(boardRow).length == 1) {
        return boardRow;
      }
    }
    // Check columns
    for (List<GamePosition> column in _getColumns(layout)) {
      if (_positionListToPlayerSet(column).length == 1) {
        return column;
      }
    }
    // Check left diagonal
    List<GamePosition> leftDiagonal = _getLeftDiagonal(layout);
    if (_positionListToPlayerSet(_getLeftDiagonal(layout)).length == 1) {
      return leftDiagonal;
    }
    // Check right diagonal
    List<GamePosition> rightDiagonal = _getRightDiagonal(layout);
    if (_positionListToPlayerSet(rightDiagonal).length == 1) {
      return rightDiagonal;
    }
    return [];
  }

  static int getGameStateHeuristic(GameState state, GamePlayer maxPlayer, GamePlayer minPlayer) {
    List<GamePosition> winPositions = state.winningPositions;
    if (winPositions.isNotEmpty) {
      return winPositions.first.player! == maxPlayer
          ? 100
          : -100; // if max won then 100 else -100
    }
    if (state.boardIsFull) return 0; // Tie
    // may player - min player
    return _getPlayerHeuristic(state.layout, maxPlayer) - _getPlayerHeuristic(state.layout, minPlayer);
  }

  static int _getPlayerHeuristic(List<List<GamePosition>> layout, GamePlayer player) {
    // Evely player in [column, row, diagonal] must be equal to player or be null
    int availableColumns = 0;
    for (List<GamePosition> column in _getColumns(layout)) {
      if (_positionsOnlyContainPlayer(column, player)) availableColumns++;
    }

    int availableRows = 0;
    for (List<GamePosition> row in layout) {
      if (_positionsOnlyContainPlayer(row, player)) availableRows++;
    }

    int availableDiagonals = 0;
    if (_positionsOnlyContainPlayer(_getLeftDiagonal(layout), player)) availableDiagonals++;
    if (_positionsOnlyContainPlayer(_getRightDiagonal(layout), player)) availableDiagonals++;

    return availableColumns + availableRows + availableDiagonals;
  }

  static bool _positionsOnlyContainPlayer(List<GamePosition> positions, GamePlayer player) {
    Set<GamePlayer?> playerSet = _positionListToPlayerSet(positions);
    return playerSet
        .every((colPlayer) => (colPlayer == player) || (colPlayer == null));
  }

  /// Convert [posList] to Set of GamePlayer? objects.
  /// Used to see how many players are in a list of given positions. Used to check if someone has won.
  /// Null player also counts.
  static Set<GamePlayer?> _positionListToPlayerSet(List<GamePosition> posList) {
    Set<GamePlayer?> playerSet = posList.map((pos) => pos.player).toSet();
    if (playerSet.length == 1 && playerSet.first == null) return {};
    return playerSet;
  }

  static List<List<GamePosition>> _getColumns(List<List<GamePosition>> layout) {
    List<List<GamePosition>> columns = [];
    for (int i = 0; i < layout.length; i++) {
      columns.add(layout.map((row) => row[i]).toList());
    }
    return columns;
  }

  static List<GamePosition> _getLeftDiagonal(List<List<GamePosition>> layout) =>
      layout.map((row) => row[layout.indexOf(row)]).toList();

  static List<GamePosition> _getRightDiagonal(List<List<GamePosition>> layout) =>
      layout.map((row) => row[layout.length - layout.indexOf(row) - 1]).toList();
}
