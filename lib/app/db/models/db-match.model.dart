import 'dart:ui';

import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-difficulty.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match-status.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-symbol.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/query/generator.query.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/table-field.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/types/types.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/algorithms/game.algorithm.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/position.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';
import 'package:flutter/material.dart';

class DbMatch {
  static const DbTableField dbId = DbTableField('id', DbType.primaryKey);

  static final DbTableField dbHumanSymbolId = DbTableField(
      'FK_human_symbol_id', DbType.int,
      reference: DbReferenceField(DbSymbol.tableName, DbSymbol.dbId));

  static final DbTableField dbDifficultyId = DbTableField(
      'FK_difficulty_id', DbType.int,
      reference: DbReferenceField(DbDifficulty.tableName, DbDifficulty.dbId));

  static final DbTableField dbMatchStatusId = DbTableField(
      'FK_match_status_id', DbType.int,
      reference: DbReferenceField(DbMatchStatus.tableName, DbMatchStatus.dbId));

  static const String tableName = 'Match';

  final int id;
  final int humanSymbolId;
  final int difficultyId;
  final int matchStatusId;

  const DbMatch(this.id, this.humanSymbolId, this.difficultyId,
      this.matchStatusId);

  factory DbMatch.fromMap(Map<String, dynamic> map) =>
      DbMatch(
        map[dbId.name],
        map[dbHumanSymbolId.name],
        map[dbDifficultyId.name],
        map[dbMatchStatusId.name],
      );

  static String get createSql =>
      QueryGenerator.createTable(
        tableName,
        [dbId, dbHumanSymbolId, dbDifficultyId, dbMatchStatusId],
      );
}

class DbMatchDetail {
  final int id;
  final String name;
  final GamePlayer human;
  final GamePlayer computer;
  final GameDifficulty difficulty;
  final GameStatus status;
  final List<GamePosition> moves;

  DbMatchDetail(this.id,
      this.name,
      this.human,
      this.computer,
      this.difficulty,
      this.status,
      this.moves,);

  GamePlayer get currentPlayer {
    if (moves.isNotEmpty) {
      if (moves.last.player! == human) return computer;
    }
    return human;
  }

  GamePlayer get startPlayer {
    if (moves.isNotEmpty) {
      if (moves.first.player! == computer) return computer;
    }
    return human;
  }

  GameState get finalGameState {
    return GameState(
        id,
        human,
        computer,
        startPlayer,
        currentPlayer,
        _boardLayoutFromPositionList(moves),
        difficulty
    );
  }

  GameState getStateFromMove(GamePosition move) {
    int moveIndex = moves.indexOf(move);
    GamePlayer? currentPlayer = moveIndex - 1 < 0 ? startPlayer : moves[moveIndex - 1].player;
    return GameState(
        id,
        human,
        computer,
        startPlayer,
        currentPlayer,
        _boardLayoutFromPositionListDisabled(moves.sublist(0, moveIndex + 1)),
        difficulty
    );
  }

  GameState getOptimalGameStateFromMove(GamePosition move) {
    int moveIndex = moves.indexOf(move);
    GamePosition previousMove = moveIndex - 1 < 0 ? moves.first : moves[moveIndex- 1];
    GameState state = getStateFromMove(previousMove);
    state.difficulty = GameDifficulty.impossible;
    GamePosition optimalMove = GameAlgorithm.findBestMoveUsingMinMaxAlphaBeta(state, move.player!);
    optimalMove.player = GamePlayer.copyWithColor(move.player!, Colors.green);
    var optimalMoves = moves.sublist(0, moveIndex);
    optimalMoves.add(optimalMove);
    return GameState(
        id,
        human,
        computer,
        startPlayer,
        state.currentPlayer,
        _boardLayoutFromPositionListDisabled(optimalMoves),
        difficulty
    );
  }

  static List<List<GamePosition>> _boardLayoutFromPositionList(
      List<GamePosition> positions) {
    final List<List<GamePosition>> gameLayout = [
      [GamePosition(0, 0), GamePosition(0, 1), GamePosition(0, 2)],
      [GamePosition(1, 0), GamePosition(1, 1), GamePosition(1, 2)],
      [GamePosition(2, 0), GamePosition(2, 1), GamePosition(2, 2)],
    ];
    for (GamePosition position in positions) {
      gameLayout[position.x][position.y].player = position.player!;
    }
    return gameLayout;
  }

  /// Dissable all but the last move placed
  static List<List<GamePosition>> _boardLayoutFromPositionListDisabled(List<GamePosition> positions) {
    final List<List<GamePosition>> gameLayout = [
      [GamePosition(0, 0), GamePosition(0, 1), GamePosition(0, 2)],
      [GamePosition(1, 0), GamePosition(1, 1), GamePosition(1, 2)],
      [GamePosition(2, 0), GamePosition(2, 1), GamePosition(2, 2)],
    ];
    for (GamePosition position in positions) {
      gameLayout[position.x][position.y].player = position.player!;
      if (positions.indexOf(position) < positions.length - 1) {
        gameLayout[position.x][position.y].disable();
      }
    }
    return gameLayout;
  }
}
