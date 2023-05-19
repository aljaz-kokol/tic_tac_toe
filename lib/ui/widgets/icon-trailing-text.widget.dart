import 'package:flutter/material.dart';

class IconTrailingText extends StatelessWidget {
  final String text;
  final Icon? icon;
  final double scaleFactor;
  final Color color;

  const IconTrailingText({
    required this.text,
    this.icon,
    this.scaleFactor = 1.0,
    this.color = Colors.black,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaleFactor: scaleFactor,
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(text: text),
          icon != null
              ? WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: icon,
                  ),
                  alignment: PlaceholderAlignment.middle,
                )
              : const TextSpan(),
        ]),
    );
  }
}
