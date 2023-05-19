import 'package:ai_2023_02_28_minmax_alphabeta/app/db/models/db-match.model.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/models/player.game.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-status.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:flutter/material.dart';

class MatchTile extends StatelessWidget {
  final DbMatchDetail match;
  final VoidCallback onShowViews;

  const MatchTile({
    required this.match,
    required this.onShowViews,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(color: Color(0xFFE0E0E0), blurRadius: 3)
          ]
      ),
      child: ExpansionTile(
        textColor: Colors.black,
        iconColor: Colors.black,
        collapsedBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          tooltip: 'View moves',
          color: match.status.color,
          icon: const Icon(Icons.remove_red_eye),
          onPressed: onShowViews,
        ),
        title: _headerDisplay(width: screenWidth * 0.35),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        expandedAlignment: Alignment.centerLeft,
        children: [
          const Divider(height: 1, thickness: 1.0),
          _playersDisplay,
          const Divider(height: 1, thickness: 1.0),
          _difficultyDisplay(width: screenWidth),
          const Divider(height: 1, thickness: 1.0),
          _numberOfMovesDisplay(width: screenWidth),
        ],
      ),
    );
  }

  Widget _getStatusText(GameStatus status) {
    return RichText(
      textScaleFactor: 1.1,
      text: TextSpan(
        text: status == GameStatus.ongoing ? 'Status: ' : "Winner: ",
        style: const TextStyle(color: Color(0xFF030303)),
        children: [
          TextSpan(
            text: status.status,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlayerInfo(String text, GamePlayer player) {
    return Row(
      children: [
        Text(
          text,
          textScaleFactor: 1.1,
        ),
        Icon(player.symbol.icon, color: player.color),
      ],
    );
  }

  Widget _difficultyDisplay({double? width}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      width: width,
      child: RichText(
        textScaleFactor: 1.1,
        text: TextSpan(
            text: 'Difficulty ',
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: match.difficulty.name,
                style: TextStyle(
                  color: match.difficulty.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }

  Widget get _playersDisplay {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getPlayerInfo("You ", match.human),
          _getPlayerInfo("Computer ", match.computer),
        ],
      ),
    );
  }

  Widget _numberOfMovesDisplay({double? width}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      width: width,
      child: RichText(
        textScaleFactor: 1.1,
        text: TextSpan(
            text: 'Num. of moves ',
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: '${match.moves.length}',
                style: TextStyle(
                  color: PlayerColor.unknown.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }

  Widget _headerDisplay({double? width}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          match.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: width,
          child: _getStatusText(match.status),
        ),
      ],
    );
  }
}
