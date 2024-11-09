import 'package:flutter/material.dart';
import 'package:labw3/app/presentation/components/coord_input.dart';

List<Widget> buildCoords(
  String selectedCoords,
  int startX,
  int startY,
  int endX,
  int endY,
  int radius,
  int iter,
  Function(int) onStartXChanged,
  Function(int) onStartYChanged,
  Function(int) onEndXChanged,
  Function(int) onEndYChanged,
  Function(int) onRadiusChanged,
  Function(int) onIterChanged,
) {
  switch (selectedCoords) {
    case 'Bresenham Circle':
      return [
        BuildCoordinateInput(
          label: "Center X",
          initialValue: startX,
          onChanged: (value) {
            onStartXChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "Center Y",
          initialValue: startY,
          onChanged: (value) {
            onStartYChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "Radius",
          initialValue: radius,
          onChanged: (value) {
            onRadiusChanged(int.parse(value));
          },
        ),
      ];

    case 'Casteljau':
      return [
        BuildCoordinateInput(
          label: "Start X",
          initialValue: startX,
          onChanged: (value) {
            onStartXChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "Start Y",
          initialValue: startY,
          onChanged: (value) {
            onStartYChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "End X",
          initialValue: endX,
          onChanged: (value) {
            onEndXChanged(int.parse(value) - 1);
          },
        ),
        BuildCoordinateInput(
          label: "End Y",
          initialValue: endY,
          onChanged: (value) {
            onEndYChanged(int.parse(value) - 1);
          },
        ),
        BuildCoordinateInput(
          label: "Iters",
          initialValue: iter,
          onChanged: (value) {
            onIterChanged(int.parse(value));
          },
        ),
      ];

    case 'Step By Step':
    case 'DDA':
    case 'Wu':
    case 'Bresenham Line':
    default:
      return [
        BuildCoordinateInput(
          label: "Start X",
          initialValue: startX,
          onChanged: (value) {
            onStartXChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "Start Y",
          initialValue: startY,
          onChanged: (value) {
            onStartYChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "End X",
          initialValue: endX,
          onChanged: (value) {
            onEndXChanged(int.parse(value));
          },
        ),
        BuildCoordinateInput(
          label: "End Y",
          initialValue: endY,
          onChanged: (value) {
            onEndYChanged(int.parse(value));
          },
        ),
      ];
  }
}
