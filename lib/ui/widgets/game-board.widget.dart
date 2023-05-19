import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';
import 'package:flutter/material.dart';

import '../../app/game/models/position.game.dart';

class GameBoard extends StatelessWidget {
  final GameState state;
  final double? width;
  final double? height;
  final double thickness;
  final EdgeInsets padding;
  final void Function(GamePosition) onPositionClicked;
  final void Function() onNewGameClicked;

  const GameBoard({
    required this.state,
    required this.onPositionClicked,
    required this.onNewGameClicked,
    this.width,
    this.height,
    this.thickness = 3.0,
    this.padding = const EdgeInsets.all(25),
    Key? key,
  }) : super(key: key);

  GamePosition _getGamePositionFromIndex(int index) {
    final int x = (((index + 3) / 3).floor() - 1);
    final int y = (index + 3) % 3;
    return state.layout[x][y];
  }

  @override
  Widget build(BuildContext context) {
    final double areaWidth = MediaQuery.of(context).size.width;
    final double areaHeight = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      padding: padding,
      child: Stack(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              GamePosition gamePosition = _getGamePositionFromIndex(index);
              return GestureDetector(
                onTap: () => onPositionClicked(gamePosition),
                child: _gameBoardItem(gamePosition),
              );
            },
          ),
          _newGameOverlay(
              show: (state is GameOverState),
              width: areaWidth,
              height: areaHeight),
        ],
      ),
    );
  }

  Container _gameBoardItem(GamePosition gamePosition) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: gamePosition.x == 1
              ? BorderSide(color: Colors.black, width: thickness)
              : BorderSide.none,
          bottom: gamePosition.x == 1
              ? BorderSide(color: Colors.black, width: thickness)
              : BorderSide.none,
          right: gamePosition.y == 0
              ? BorderSide(color: Colors.black, width: thickness)
              : BorderSide.none,
          left: gamePosition.y == 2
              ? BorderSide(color: Colors.black, width: thickness)
              : BorderSide.none,
        ),
      ),
      child: Icon(
        gamePosition.player?.symbol.icon,
        color: !gamePosition.disabled
            ? gamePosition.player?.color
            : PlayerColor.unknown.color,
        size: width != null ? width! / 5 : 100,
      ),
    );
  }

  Widget _newGameOverlay({required bool show, double? width, double? height}) {
    if (show) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.black.withAlpha(36),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    splashFactory: NoSplash.splashFactory,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: onNewGameClicked,
                child: Text(
                  'New Game',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: state.difficulty.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox(width: 0, height: 0);
  }
}
