import 'package:ai_2023_02_28_minmax_alphabeta/app/game/utils/game-difficulty.util.dart';
import 'package:ai_2023_02_28_minmax_alphabeta/ui/widgets/slider/vertical-slider.widget.dart';
import '../../../app/state_management/cubit/vertical-slider-control.cubit.dart';

class GameDifficultySlider extends VerticalSlider<GameDifficulty> {
  static final List<Label> _diffLabels = List.generate(
    GameDifficulty.values.length,
    (index) => Label(
      GameDifficulty.values[index].name,
      GameDifficulty.values[index].color,
    ),
  );

  GameDifficultySlider({
    required super.value,
    required super.values,
    required super.height,
    super.borderRadius,
    super.width,
    super.onDragStop,
    super.divisionThickness,
  }): super(labels: _diffLabels, trackColor: value.color);

  @override
  void onDragUpdate(double height, VerticalSliderState state) {
    super.onDragUpdate(height, state);
    sliderControlCubit
        .updateColor((state.currentElement as GameDifficulty).color);
  }
}
