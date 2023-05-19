import 'package:ai_2023_02_28_minmax_alphabeta/app/game/algorithms/game.algorithm.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/events/game.event.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/game.bloc.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/cubit/score-board.cubit.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/game-board.widget.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/icon-trailing-text.widget.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/slider/game-difficulty-slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../app/game/models/position.game.dart';
import '../../app/state_management/bloc/game/states/game.state.dart';
import '../widgets/score-board.widget.dart';

class GameScreen extends StatelessWidget {
  GameScreen({Key? key}) : super(key: key);
  final PanelController _difficultyPanelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    final ScoreBoardCubit scoreBoardCubit = context.read<ScoreBoardCubit>();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: BlocListener<GameBloc, GameState>(
        bloc: gameBloc,
        listener: (context, state) {
          if (state is! GameInitializingState && state.currentPlayer == state.computer) {
              GamePosition bestMove = GameAlgorithm.findBestMoveUsingMinMaxAlphaBeta(state, state.computer!);
              gameBloc.makeMove(bestMove);
          }
        },
        child: BlocBuilder<GameBloc, GameState>(
            builder: (context, gameState) {
              if (gameState is GameInitializingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return SlidingUpPanel(
                  minHeight: 0,
                  controller: _difficultyPanelController,
                  backdropEnabled: true,
                  maxHeight: screenHeight * 0.8,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  panel: _gameDifficultyPopUpPanel(
                    text: 'Difficulty',
                    gameState: gameState,
                    onDragStop: (diff) => gameBloc.add(DifficultyChangeEvent(diff)),
                    height: screenHeight * 0.7,
                    width: screenWidth * 0.35,
                  ),
                  body: Scaffold(
                    appBar: _gameAppBar(gameState.difficulty, canChangeDiff: gameState is! GameOverState),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: GameBoard(
                            state: gameState,
                            onPositionClicked: (position) => gameBloc.makeMove(position),
                            onNewGameClicked: () => gameBloc.newGameFromState(gameState),
                          ),
                        ),
                        _gameStatusText(
                          gameState,
                          onComputerWin: () => scoreBoardCubit.incrementComputer(),
                          onHumanWin: () => scoreBoardCubit.incrementHuman(),
                          onTie: () => scoreBoardCubit.incrementTie(),
                        ),
                        ScoreBoard(
                          human: gameState.human!,
                          computer: gameState.computer!,
                        ),
                      ],
                    ),
                  ));
            }),
      ),
    );
  }

  AppBar _gameAppBar(GameDifficulty currDiff, {bool canChangeDiff = true}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(
        currDiff.name,
        style: TextStyle(color: currDiff.color),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.device_thermostat_outlined,
            size: 30,
            color: currDiff.color,
          ),
          onPressed: () {
            if (canChangeDiff) {
              _difficultyPanelController.open();
            }
          },
        )
      ],
    );
  }

  Row _currentTurnText(GamePlayer player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('It\'s ', textScaleFactor: 1.7),
        Icon(
          player.symbol.icon,
          color: player.color,
          size: 30,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text('turn', textScaleFactor: 1.7),
        ),
      ],
    );
  }

  Widget _gameStatusText(
    GameState gameState, {
    required VoidCallback onHumanWin,
    required VoidCallback onComputerWin,
    required VoidCallback onTie,
  }) {
    if (gameState is GameOverState) {
      if (gameState.winner != null) {
        if (gameState.winner == gameState.human) onHumanWin();
        else onComputerWin();
        return IconTrailingText(
          text: "Winner",
          scaleFactor: 2,
          icon: Icon(gameState.winner!.symbol.icon,
              color: gameState.winner!.color),
        );
      }
      onTie();
      return const Text(
        "It's a Tie",
        textScaleFactor: 2,
        style: TextStyle(fontWeight: FontWeight.bold),
      );
    }
    return _currentTurnText(gameState.currentPlayer!);
  }

  Widget _gameDifficultyPopUpPanel({
    required String text,
    required GameState gameState,
    required void Function(GameDifficulty) onDragStop,
    double? width,
    double height = 100.0,
  }) {
    return Column(
      children: [
        const Text(
          'Difficulty',
          textScaleFactor: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        GameDifficultySlider(
          value: gameState.difficulty,
          height: height,
          values: GameDifficulty.values,
          width: width,
          onDragStop: onDragStop,
          borderRadius: BorderRadius.circular(20.0),
          divisionThickness: 4.0,
        ),
      ],
    );
  }
}
