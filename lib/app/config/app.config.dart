import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/screens/history/game-history.screen.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/screens/history/moves-detail.screen.dart';
import 'package:go_router/go_router.dart';

import '../../ui/screens/game.screen.dart';
import '../../ui/screens/symbol-pick.screen.dart';

abstract class AppConfig {
  static final GoRouter router = GoRouter(routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const SymbolPickScreen(),
        routes: [
          GoRoute(
            path: 'game',
            builder: (context, state) => GameScreen(),
          ),
          GoRoute(
            path: 'history',
            builder: (context, state) => GameHistoryScreen(),
          ),
          GoRoute(
            path: 'history/detail',
            builder: (context, state) {
              if (state.extra is DbMatchDetail) {
                return MovesDetailScreen(match: state.extra as DbMatchDetail);
              }
              return GameHistoryScreen();
            },
          ),
        ])
  ]);
}
