import 'dart:async';

import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';
import 'package:bloc/bloc.dart';

import '../../../db/helper.db.dart';
import '../../../game/models/position.game.dart';
import 'events/game.event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitializingState()) {
    on<NewGameEvent>(_onNewGame);
    on<SymbolPlacedEvent>(_onSymbolPlaced);
    on<DifficultyChangeEvent>(_onDifficultyChanged);
    on<ResumeGameEvent>(_onResumeGame);
  }

  void newGame(GameSymbol humanSymbol) {
    add(NewGameEvent(humanSymbol));
  }

  void newGameFromState(GameState state) {
    add(NewGameEvent.starWith(
      state.computer!.symbol,
      state.startPlayer!.symbol,
      difficulty: state.difficulty,
    ));
  }

  void changeDifficulty(GameDifficulty difficulty) {
    add(DifficultyChangeEvent(difficulty));
  }

  void makeMove(GamePosition position) {
    add(SymbolPlacedEvent(position));
  }

  void resumeGame(GameState lastState) {
    add(ResumeGameEvent(lastState));
  }

  Future<void> _onNewGame(NewGameEvent event, Emitter<GameState> emit) async {
    emit(GameInitializingState());
    int id = await DatabaseHelper.get.insertMatch(event.difficulty, event.human.symbol);
    emit(
      GameState(id, event.human, event.computer, event.startPlayer,
          event.startPlayer, event.newGameInitialLayout, event.difficulty),
    );
  }


  void _onResumeGame(ResumeGameEvent event, Emitter<GameState> emit) {
    emit(event.lastGameState);
  }

  Future<void> _onSymbolPlaced(
      SymbolPlacedEvent event, Emitter<GameState> emit) async {
    if (!event.position.isSet) {
      bool isHuman = state.currentPlayer == state.human;
      state.setAtPosition(event.position, state.currentPlayer);
      GamePosition position = state.get(event.position.x, event.position.y)!;
      List<GamePosition> winPositions = state.winningPositions;
      if (winPositions.isNotEmpty || state.boardIsFull) {
        await _onGameEnd(winPositions, emit);
        await DatabaseHelper.get.insertMove(
            state.matchId, position, isHuman);
        return;
      }
      emit(GameState.nextPlayerOf(state));
      await DatabaseHelper.get.insertMove(
          state.matchId, position, isHuman);
    }
  }

  Future<void> _onDifficultyChanged(
      DifficultyChangeEvent event, Emitter<GameState> emit) async {
    if (event.newDifficulty != state.difficulty) {
      state.difficulty = event.newDifficulty;
      emit(GameState.copyOf(state));
      await DatabaseHelper.get
          .updateMatchDifficulty(state.matchId, event.newDifficulty);
    }
  }

  Future<void> _onGameEnd(
      List<GamePosition> winPositions, Emitter<GameState> emit) async {
    for (GamePosition pos in state.positionsList) {
      if (winPositions.indexWhere((winPos) => winPos == pos) == -1) {
        state.disableAt(pos);
      }
    }
    if (winPositions.isEmpty) {
      emit(GameOverState.copyOf(state, null));
      await DatabaseHelper.get.updateMatchStatus(state.matchId, GameStatus.tie);
    } else {
      emit(GameOverState.copyOf(state, winPositions.first.player));
      if (winPositions.first.player == state.human) {
        await DatabaseHelper.get
            .updateMatchStatus(state.matchId, GameStatus.humanWin);
      } else {
        await DatabaseHelper.get.updateMatchStatus(state.matchId, GameStatus.computerWin);
      }
    }
  }
}
