import 'dart:ui';

enum GameDifficulty {
  superEasy('Super Easy', 1, Color(0xFF43A047)),
  easy('Easy', 2, Color(0xFF368239)),
  normal('Normal', 3, Color(0xFFFFA000)),
  aboveAverage('Above Average', 4, Color(0xFFFF6F00)),
  challenging('Challenging', 5, Color(0xFFFF4800)),
  hard('Hard', 6, Color(0xFFE91E63)),
  extraHard('Extra Hard', 7, Color(0xFFF50057)),
  extreme('Extreme', 8, Color(0xFFFF1744)),
  impossible('Impossible', 9,Color(0xFFF50031) );

  final int depth;
  final Color color;
  final String name;

  const GameDifficulty(this.name, this.depth, this.color);

  static GameDifficulty fromName(String name) {
    for (GameDifficulty diff in values) {
      if (diff.name == name) return diff;
    }
    return GameDifficulty.superEasy;
  }
}