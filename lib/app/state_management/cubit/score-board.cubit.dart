import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:bloc/bloc.dart';

class ScoreBoardCubit extends Cubit<Map<GameStatus, int>> {
  ScoreBoardCubit(super.initialState);

  void incrementHuman() {
    state[GameStatus.humanWin] = state[GameStatus.humanWin]! + 1;
    emit(Map<GameStatus, int>.from(state));
  }

  void incrementComputer() {
    state[GameStatus.computerWin] = state[GameStatus.computerWin]! + 1;
    emit(Map<GameStatus, int>.from(state));
  }

  void incrementTie() {
    state[GameStatus.tie] = state[GameStatus.tie]! + 1;
    emit(Map<GameStatus, int>.from(state));
  }

  void decrementStatus(GameStatus status) {
    if (status == GameStatus.humanWin) {
      state[GameStatus.humanWin] = state[GameStatus.humanWin]! - 1;
    } else if (status == GameStatus.computerWin) {
      state[GameStatus.computerWin] = state[GameStatus.computerWin]! - 1;
    } else if (status == GameStatus.tie) {
      state[GameStatus.tie] = state[GameStatus.tie]! - 1;
    }
    emit(Map<GameStatus, int>.from(state));
  }
}