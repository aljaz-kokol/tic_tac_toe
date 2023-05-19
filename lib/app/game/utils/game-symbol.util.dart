import 'package:flutter/material.dart';

enum GameSymbol {
  x(Icons.close),
  o(Icons.circle_outlined);

  final IconData icon;
  const GameSymbol(this.icon);

  GameSymbol get oppositeSymbol {
    if (this == x) return o;
    return x;
  }

  static GameSymbol fromName(String symbolName) {
    for (GameSymbol symbol in GameSymbol.values) {
      if (symbol.toString() == symbolName) {
        return symbol;
      }
    }
    return x;
  }
}