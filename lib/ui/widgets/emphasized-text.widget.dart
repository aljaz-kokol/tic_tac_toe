import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/player-color.util.dart';
import 'package:flutter/material.dart';

class EmphasizedText extends StatelessWidget {
  final String emphasizedText;
  final Color emphasizedColor;
  final String trailingText;
  final Color trailingColor;

  const EmphasizedText({
    required this.emphasizedText,
    this.emphasizedColor = Colors.black,
    this.trailingText = '',
    this.trailingColor = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: emphasizedText,
          style: TextStyle(
            color: emphasizedColor,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
                text: trailingText,
                style: TextStyle(
                    color: trailingColor, fontWeight: FontWeight.normal))
          ]),
    );
  }
}
