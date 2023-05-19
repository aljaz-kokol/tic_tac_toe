import 'dart:math';

import 'package:ai_2023_02_28_minmax_alphabeta/app/game/helpers/game.helper.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/position.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';

abstract class GameAlgorithm {
  static GamePosition findBestMoveUsingMinMax(GameState state, GamePlayer maxPlayer) {
    Map<GameState, GamePosition> possibleStates = _getAllNextPossibleStates(state);
    GamePosition bestMove = possibleStates.values.first;
    int bestValue = -double.maxFinite.toInt();

    for (GameState possState in possibleStates.keys) {
      int minMaxValue = _minMax(possState, state.difficulty.depth - 1, maxPlayer);
      if (bestValue < minMaxValue) {
        bestMove = possibleStates[possState]!;
        bestValue = minMaxValue;
      }
    }
    return bestMove;
  }

  static GamePosition findBestMoveUsingMinMaxAlphaBeta(GameState state, GamePlayer maxPlayer) {
    Map<GameState, GamePosition> possibleStates = _getAllNextPossibleStates(state);
    GamePosition bestMove = possibleStates.values.first;
    int bestValue = -double.maxFinite.toInt();
    for (GameState possState in possibleStates.keys) {
      int minMaxValue = _minMaxAlphaBeta(possState, state.difficulty.depth - 1, maxPlayer, bestValue, -bestValue);
      if (bestValue < minMaxValue) {
        bestMove = possibleStates[possState]!;
        bestValue = minMaxValue;
      }
    }
    return bestMove;
  }

  static int _minMax(GameState state, int depth, GamePlayer maxPlayer) {
    if (state.isFinalState || depth <= 0) {
      return GameHelper.getGameStateHeuristic(state, maxPlayer, state.oppositePlayer(maxPlayer));
    }
    if (state.currentPlayer == maxPlayer) {
      int bestValue = -double.maxFinite.toInt();
      for (GameState possibleState in _getAllNextPossibleStates(state).keys) {
        bestValue = max(bestValue, _minMax(possibleState, depth - 1, maxPlayer));
      }
      return bestValue;
    }
    int worstValue = double.maxFinite.toInt();
    for (GameState possibleState in _getAllNextPossibleStates(state).keys) {
      worstValue = min(worstValue, _minMax(possibleState, depth - 1, maxPlayer));
    }
    return worstValue;
  }

  static int _minMaxAlphaBeta(GameState state, int depth, GamePlayer maxPlayer, int alpha, int beta) {
    if (state.isFinalState || depth <= 0) {
      return GameHelper.getGameStateHeuristic(state, maxPlayer, state.oppositePlayer(maxPlayer));
    }
    if (state.currentPlayer == maxPlayer) {
      int bestValue = -double.maxFinite.toInt();
      for (GameState possibleState in _getAllNextPossibleStates(state).keys) {
        bestValue = max(bestValue, _minMaxAlphaBeta(possibleState, depth - 1, maxPlayer, alpha, beta));
        alpha = max(alpha, bestValue);
        if (bestValue >= beta) break;
      }
      return bestValue;
    }
    int worstValue = double.maxFinite.toInt();
    for (GameState possibleState in _getAllNextPossibleStates(state).keys) {
      worstValue = min(worstValue, _minMaxAlphaBeta(possibleState, depth - 1, maxPlayer, alpha, beta));
      beta = min(beta, worstValue);
      if (worstValue <= alpha) break;
    }
    return worstValue;
  }

  // GamePosition represents the move we had to make to get to the state in key
  static Map<GameState, GamePosition> _getAllNextPossibleStates(GameState state) {
    Map<GameState, GamePosition> possibleStatesMap = {};
    for (GamePosition freePos in state.freePositions) {
      GameState possibleState = GameState.nextPlayerOf(state);
      possibleState.setAtPosition(freePos, state.currentPlayer);
      possibleStatesMap[possibleState] = freePos;
    }
    return possibleStatesMap;
  }
}