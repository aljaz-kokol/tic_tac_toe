import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/cubit/score-board.cubit.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/icon-trailing-text.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ScoreBoard extends StatelessWidget {
  late final GamePlayer? human;
  late final GamePlayer? computer;

  ScoreBoard(
      {this.human, this.computer, Key? key})
      : super(key: key) {
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final ScoreBoardCubit scoreBoardCubit = context.read<ScoreBoardCubit>();
    return BlocBuilder<ScoreBoardCubit, Map<GameStatus, int>>(
      bloc: scoreBoardCubit,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          width: screenWidth,
          child: Card(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: StaggeredGrid.count(
              crossAxisCount: 3,
              axisDirection: AxisDirection.down,
              children: [
                ..._scoreBordHead(context),
                // Score board body
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.5,
                  child: _scoreBoardItem(
                    child: Text(
                      '${state[GameStatus.humanWin]}',
                      textScaleFactor: 4.5,
                      style: TextStyle(
                        color: PlayerColor.human.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.5,
                  child: _scoreBoardItem(
                    child: Text(
                      '${state[GameStatus.tie]}',
                      textScaleFactor: 4.5,
                      style: TextStyle(
                        color: PlayerColor.unknown.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leftBorder: true,
                    rightBorder: true,
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1.5,
                  child: _scoreBoardItem(
                    child: Text(
                      '${state[GameStatus.computerWin]}',
                      textScaleFactor: 4.5,
                      style: TextStyle(
                        color: PlayerColor.computer.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _scoreBoardItem({
    required Widget child,
    bool bottomBorder = false,
    bool topBorder = false,
    bool leftBorder = false,
    bool rightBorder = false,
    int borderColorValue = 0xFFC1C1C1,
    double borderWidth = 2,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: bottomBorder
              ? BorderSide(color: Color(borderColorValue), width: borderWidth)
              : BorderSide.none,
          top: topBorder
              ? BorderSide(color: Color(borderColorValue), width: borderWidth)
              : BorderSide.none,
          left: leftBorder
              ? BorderSide(color: Color(borderColorValue), width: borderWidth)
              : BorderSide.none,
          right: rightBorder
              ? BorderSide(color: Color(borderColorValue), width: borderWidth)
              : BorderSide.none,
        ),
      ),
      child: child,
    );
  }

  List<Widget> _scoreBordHead(BuildContext context) {
    return [
      _scoreBoardItem(
        child: IconTrailingText(
          text: 'You',
          icon: _humanIcon,
        ),
        bottomBorder: true,
      ),
      _scoreBoardItem(
        child: IconTrailingText(
          text: 'Tie',
          icon: Icon(
            Icons.device_unknown_outlined,
            color: PlayerColor.unknown.color,
          ),
        ),
        bottomBorder: true,
        leftBorder: true,
        rightBorder: true,
      ),
      _scoreBoardItem(
        child: IconTrailingText(
          text: 'Computer',
          icon: _computerIcon,
        ),
        bottomBorder: true,
      ),
    ];
  }

  Icon get _humanIcon {
    return Icon(
        human != null ? human!.symbol.icon : Icons.person,
        color: human != null ? human!.color : PlayerColor.human.color,
    );
  }

  Icon get _computerIcon {
    return Icon(
      computer != null ? computer!.symbol.icon : Icons.monitor,
      color: computer != null ? computer!.color : PlayerColor.computer.color,
    );
  }
}
