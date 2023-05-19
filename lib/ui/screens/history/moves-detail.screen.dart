import 'dart:async';

import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/position.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/game.bloc.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/states/game.state.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/emphasized-text.widget.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/game-board.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovesDetailScreen extends StatefulWidget {
  static const List<BottomNavigationBarItem> _displayOptionsList = [
    BottomNavigationBarItem(
      icon: Icon(Icons.groups),
      label: 'All moves',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Your moves',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monitor),
      label: 'Computer moves',
    ),
  ];

  final DbMatchDetail match;
  final StreamController<List<GamePosition>> movesStream = StreamController<List<GamePosition>>();

  MovesDetailScreen({required this.match, Key? key}) : super(key: key);

  @override
  State<MovesDetailScreen> createState() => _MovesDetailScreenState();
}

class _MovesDetailScreenState extends State<MovesDetailScreen> {
  final StreamController<int >selectedDisplayOptionStream = StreamController<int>();

  Color getDisplayOptionActiveColor(int index) {
    if (index == 0) return PlayerColor.unknown.color;
    if (index == 1) return PlayerColor.human.color;
    return PlayerColor.computer.color;
  }

  void _onDisplayOptionSelect(int index) {
    selectedDisplayOptionStream.sink.add(index);
    if (index == 0) widget.movesStream.sink.add(widget.match.moves);
    if (index == 1) widget.movesStream.sink.add(widget.match.moves.where((move) => move.player == widget.match.human).toList());
    if (index == 2) widget.movesStream.sink.add(widget.match.moves.where((move) => move.player == widget.match.computer).toList());
  }

  @override
  void dispose() {
    super.dispose();
    widget.movesStream.close();
    selectedDisplayOptionStream.close();
  }

  @override
  void initState() {
    super.initState();
    widget.movesStream.sink.add(widget.match.moves);
  }

  @override
  Widget build(BuildContext context) {
    final GameBloc gameBloc = context.read<GameBloc>();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(
        widget.match.name,
        showContinue: widget.match.status == GameStatus.ongoing,
        onContinue: () {
          gameBloc.resumeGame(widget.match.finalGameState);
          context.go('/game');
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: selectedDisplayOptionStream.stream,
        builder: (context, snapshot) {
          final int selectedIndex = snapshot.data ?? 0;
          return BottomNavigationBar(
            items: MovesDetailScreen._displayOptionsList,
            onTap: _onDisplayOptionSelect,
            currentIndex: selectedIndex,
            selectedItemColor: getDisplayOptionActiveColor(selectedIndex),
          );
        },
      ),
      body: StreamBuilder(
        stream: widget.movesStream.stream,
        builder: (context, snapshot) {
          List<GamePosition> moves = snapshot.data ?? [];
          return ListView.builder(
            itemCount: moves.length,
            itemBuilder: (context, index) {
              GamePosition move = moves[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _inactiveGameBoard(
                        state: widget.match.getStateFromMove(move),
                        width: screenWidth * 0.42,
                        height: screenHeight * 0.22,
                        subtitle: EmphasizedText(
                          emphasizedText:
                              move.player == widget.match.human ? 'You' : 'Computer',
                          emphasizedColor: move.player!.color,
                          trailingText: ' played',
                          trailingColor: PlayerColor.unknown.color,
                        )),
                    Container(
                      width: 2,
                      height: screenHeight * 0.25,
                      color: PlayerColor.unknown.color,
                    ),
                    _inactiveGameBoard(
                      state: widget.match.getOptimalGameStateFromMove(move),
                      width: screenWidth * 0.42,
                      height: screenHeight * 0.22,
                      subtitle: EmphasizedText(
                        emphasizedText: 'Optimal',
                        emphasizedColor: Colors.green,
                        trailingText: ' play',
                        trailingColor: PlayerColor.unknown.color,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }

  PreferredSizeWidget _appBar(
    String title, {
    required void Function() onContinue,
    bool showContinue = false,
  }) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: Text(
        title,
        textScaleFactor: 1.4,
        style: TextStyle(
          color: PlayerColor.unknown.color,
        ),
      ),
      actions: showContinue
          ? [
              IconButton(
                onPressed: onContinue,
                icon: Icon(Icons.sports_esports),
              )
            ]
          : null,
    );
  }

  Widget _inactiveGameBoard(
      {required GameState state,
      double? width,
      double? height,
      Widget? subtitle}) {
    return Column(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: GameBoard(
            width: width,
            state: state,
            padding: const EdgeInsets.all(5),
            thickness: 1,
            onNewGameClicked: () {},
            onPositionClicked: (_) {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: subtitle ?? const SizedBox(),
        ),
      ],
    );
  }
}
