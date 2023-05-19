import 'package:ai_2023_02_28_minmax_alphabeta/app/db/helper.db.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/cubit/score-board.cubit.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/matc-tile.widget.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/score-board.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameHistoryScreen extends StatelessWidget {
  const GameHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScoreBoardCubit scoreBoardCubit = context.read<ScoreBoardCubit>();
    return Scaffold(
      appBar: _appBar('Match History'),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: DatabaseHelper.get.getDetailedMatchListStream(),
              initialData: const [],
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      DbMatchDetail match = snapshot.data![index];
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) async {
                          await DatabaseHelper.get.deleteMatchById(match.id);
                          scoreBoardCubit.decrementStatus(match.status);
                        },
                        secondaryBackground: Container(color: Colors.black,),
                        background: _deleteBackground,
                        key: Key(match.toString()),
                        child: MatchTile(
                          match: match,
                          onShowViews: () =>
                              context.push('/history/detail', extra: match),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: PlayerColor.human.color,
                  ),
                );
              },
            ),
          ),
          ScoreBoard(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(String title) {
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
    );
  }

  Widget get _deleteBackground {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          color: PlayerColor.computer.color,
          borderRadius: BorderRadius.circular(10)
      ),
      child: const Text(
        'Delete',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.3,
      ),
    );
  }
}
