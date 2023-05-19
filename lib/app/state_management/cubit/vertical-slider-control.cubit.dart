import 'dart:ui';
import 'package:bloc/bloc.dart';

class VerticalSliderState<T> {
  final double currentHeight;
  final T currentElement;
  final Color? trackColor;

  VerticalSliderState(this.currentHeight, this.currentElement,
      {this.trackColor});
}

class VerticalSliderControlCubit<T> extends Cubit<VerticalSliderState> {
  final double _maxHeight;
  final List<T> _values;
  final T _startValue;

  VerticalSliderControlCubit(this._maxHeight, this._values, this._startValue)
      : super(
          VerticalSliderState(
              (_maxHeight / _values.length) *
                  (_values.indexOf(_startValue) + 1),
              _startValue),
        );

  void updateHeightWhileDragging(double height) {
    int elementIndex = (height / (_maxHeight / _values.length)).ceil() - 1;
    if (elementIndex >= _values.length) elementIndex = _values.length - 1;
    emit(
      VerticalSliderState(
        height,
        _values[elementIndex],
      ),
    );
  }

  void normalizeHeight(double height) {
    int elementNum = (height / (_maxHeight / _values.length)).ceil();
    if (elementNum >= _values.length) elementNum = _values.length;
    double normalizedHeight = (_maxHeight / _values.length) * elementNum;
    emit(VerticalSliderState(normalizedHeight, _values[elementNum - 1]));
  }

  void updateColor(Color trackColor) {
    emit(VerticalSliderState(
      state.currentHeight,
      state.currentElement,
      trackColor: trackColor,
    ));
  }
}
