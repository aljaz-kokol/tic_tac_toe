import 'package:ai_2023_02_28_minmax_alphabeta/app/db/helper.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/bloc/game/game.bloc.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/cubit/score-board.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'app/config/app.config.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => GameBloc()),
        FutureProvider(
            create: (_) async => ScoreBoardCubit({
              GameStatus.humanWin : await DatabaseHelper.get.countMatchesWhereStatus(GameStatus.humanWin),
              GameStatus.computerWin : await DatabaseHelper.get.countMatchesWhereStatus(GameStatus.computerWin),
              GameStatus.tie : await DatabaseHelper.get.countMatchesWhereStatus(GameStatus.tie),
            }),
            initialData: ScoreBoardCubit({
              GameStatus.humanWin : 0,
              GameStatus.computerWin : 0,
              GameStatus.tie : 0
            })
        )
      ],
      child: const TicTacToeApp(),
    ),
  );
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreBoardCubit>(
      builder: (context, cubit, widget) {
        return MaterialApp.router(
          title: 'Tic Tac Toe',
          routerConfig: AppConfig.router,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color(0xFFECECEC) ,
          ),
        );
      },
    );
  }
}
