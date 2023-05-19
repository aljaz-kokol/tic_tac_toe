import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-symbol.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/events/game.event.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/game.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SymbolPickScreen extends StatelessWidget {
  const SymbolPickScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final GameBloc gameBloc = context.read<GameBloc>();
    return Scaffold(
      appBar: _appBar(
        'Choose a symbol',
        onViewHistory: () => context.go('/history'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...GameSymbol.values.map((symbol) {
              return _symbolButton(
                symbol.icon,
                context,
                onPressed: () {
                  gameBloc.newGame(symbol);
                  context.go('/game');
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(String title,
      {required void Function() onViewHistory}) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        onPressed: onViewHistory,
        color: PlayerColor.unknown.color,
        icon: const Icon(Icons.history),
        iconSize: 30,
        tooltip: 'View match history',
      ),
      title: Text(
        title,
        textScaleFactor: 1.4,
        style: TextStyle(
          color: PlayerColor.unknown.color,
        ),
      ),
    );
  }

  Widget _symbolButton(IconData symbolIcon, BuildContext context,
      {required VoidCallback onPressed}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.5,
      height: screenHeight * 0.2,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) =>
              states.contains(MaterialState.pressed)
                  ? const Color(0xFFF8F8F8)
                  : Colors.white),
          shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
          elevation: MaterialStateProperty.resolveWith(
              (states) => states.contains(MaterialState.pressed) ? 10 : 4),
        ),
        child: Icon(
          symbolIcon,
          size: screenHeight * 0.15,
          color: const Color(0xFF3E3E3E),
        ),
      ),
    );
  }
}
