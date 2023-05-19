import 'dart:convert';

import 'package:ai_2023_02_28_minmax_alphabeta/app/state_management/cubit/vertical-slider-control.cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Label {
  final String text;
  final Color? color;

  Label(this.text, this.color);
}

class VerticalSlider<T> extends StatelessWidget {
  final T value;
  final double height;
  final double? width;
  final List<T> values;
  final double divisionThickness;
  final Color divisionColor;
  final Color backgroundColor;
  final BorderRadius? borderRadius;
  final List<Label> labels ;
  final Function(T)? onDrag;
  final Function(T)? onDragStop;
  late final Color trackColor;
  late final VerticalSliderControlCubit<T> sliderControlCubit;

  VerticalSlider({
    required this.value,
    required this.values,
    required this.height,
    this.width,
    this.borderRadius,
    this.onDragStop,
    this.onDrag,
    this.labels = const [],
    this.divisionThickness = 5.0,
    this.divisionColor = const Color(0xFF3E3E3E),
    this.trackColor = Colors.blueAccent,
    this.backgroundColor = const Color(0xFFF4F4F4),
    Key? key,
  }) : super(key: key) {
    sliderControlCubit = VerticalSliderControlCubit<T>(height, values, value);
  }

  void onDragUpdate(double height, VerticalSliderState state) {
    sliderControlCubit.updateHeightWhileDragging(height);
    if (onDrag != null) {
      onDrag!(state.currentElement);
    }
  }

  void onDragOver(double height, VerticalSliderState state) {
    sliderControlCubit.normalizeHeight(height);
    if (onDragStop != null) {
      onDragStop!(state.currentElement);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _labels,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 100),
          child: BlocBuilder(
            bloc: sliderControlCubit,
            builder: (context, VerticalSliderState sliderState) {
              return _sliderBody(sliderState);
            },
          ),
        ),
      ],
    );
  }

  Widget _track({
    required double height,
    required Color trackColor,
    required void Function(double newHeight) onDrag,
    required void Function(double finalHeight) onDragStop,
  }) {
    return GestureDetector(
      onVerticalDragUpdate: (value) {
        height += height * value.delta.dy / 180;
        onDrag(height);
      },
      onVerticalDragEnd: (value) => onDragStop(height),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _sliderBody(VerticalSliderState sliderState) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: RotatedBox(
        quarterTurns: 2,
        child: Stack(
          children: [
            _track(
                height: sliderState.currentHeight,
                onDrag: (height) => onDragUpdate(height, sliderState),
                onDragStop: (height) => onDragOver(height, sliderState),
                trackColor: sliderState.trackColor ?? trackColor),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(values.length - 1, (index) {
                return Divider(
                  color: divisionColor,
                  thickness: divisionThickness,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get _labels {
    return List.generate(values.length, (index) {
      if (labels.length <= index) return const Text('');
      return Text(
        labels[labels.length - index - 1].text,
        textScaleFactor: 1.1,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: labels[labels.length - index - 1].color,
        ),
      );
    });
  }
}
